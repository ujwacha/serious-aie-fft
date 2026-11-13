#!/usr/bin/env python3
"""Golden vs FPGA range-Doppler plot for the moving 1153 nm lidar scene.

Golden : float model, ADC -> Q15 range Hamming -> 2048-pt FFT ->
         Q15 Doppler Hamming -> 256-pt FFT.
FPGA   : the real chain from tb/work: HLS range mask/cube -> HLS Doppler
         window -> real AIE 256-point FFT (one x86simulator run per frame).

Only the active range block(s) are shown, because those are the bins the
pipeline keeps and sends to the Doppler stage.

    ./moving_plot.py

Writes work/plots/moving_{golden,fpga,compare}.{svg,png}.
"""

from __future__ import annotations

import math
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import rd_test as R  # noqa: E402

WORK = HERE / "work"
PLOTS = WORK / "plots"
ROOT = HERE.parent.parent
AIE = ROOT / "fft_accelerator_component"
BUILD = AIE / "build" / "x86sim"
SIMOUT = BUILD / "x86simulator_output" / "data"
SETTINGS = Path.home() / "FPGA/2026.1/Vitis/settings64.sh"

N_RANGE = R.N_RANGE
N_DOPPLER = R.N_DOPPLER
BLOCK = R.BLOCK


# ---------------------------------------------------------------------------
# SVG helpers
# ---------------------------------------------------------------------------
def esc(s):
    return (str(s).replace("&", "&amp;").replace("<", "&lt;")
            .replace(">", "&gt;"))


class Svg:
    def __init__(self, w, h):
        self.w, self.h = w, h
        self.parts = []

    def add(self, s):
        self.parts.append(s)

    def rect(self, x, y, w, h, fill, stroke="none", sw=1):
        self.add(f'<rect x="{x:.2f}" y="{y:.2f}" width="{w:.2f}" '
                 f'height="{h:.2f}" fill="{fill}" stroke="{stroke}" '
                 f'stroke-width="{sw}"/>')

    def line(self, x1, y1, x2, y2, stroke="#333", sw=1, dash=None):
        d = f' stroke-dasharray="{dash}"' if dash else ""
        self.add(f'<line x1="{x1:.1f}" y1="{y1:.1f}" x2="{x2:.1f}" '
                 f'y2="{y2:.1f}" stroke="{stroke}" stroke-width="{sw}"{d}/>')

    def circle(self, cx, cy, r, stroke="#fff", sw=2, fill="none"):
        self.add(f'<circle cx="{cx:.1f}" cy="{cy:.1f}" r="{r:.1f}" '
                 f'fill="{fill}" stroke="{stroke}" stroke-width="{sw}"/>')

    def text(self, x, y, s, size=12, fill="#111", anchor="start",
             weight="normal", family="sans-serif", rotate=None):
        tr = f' transform="rotate({rotate} {x:.1f} {y:.1f})"' if rotate else ""
        self.add(f'<text x="{x:.1f}" y="{y:.1f}" font-family="{family}" '
                 f'font-size="{size}" fill="{fill}" text-anchor="{anchor}" '
                 f'font-weight="{weight}"{tr}>{esc(s)}</text>')

    def save(self, path):
        body = "\n".join(self.parts)
        path.write_text(
            f'<svg xmlns="http://www.w3.org/2000/svg" width="{self.w}" '
            f'height="{self.h}" viewBox="0 0 {self.w} {self.h}">\n'
            f'<rect width="{self.w}" height="{self.h}" fill="#ffffff"/>\n'
            f'{body}\n</svg>\n')


# viridis-ish colormap
_CMAP = [
    (0.00, (68, 1, 84)),
    (0.25, (59, 82, 139)),
    (0.50, (33, 145, 140)),
    (0.75, (94, 201, 98)),
    (1.00, (253, 231, 37)),
]


def color(v):
    v = 0.0 if v < 0 else (1.0 if v > 1 else v)
    for i in range(len(_CMAP) - 1):
        p0, c0 = _CMAP[i]
        p1, c1 = _CMAP[i + 1]
        if v <= p1:
            t = (v - p0) / (p1 - p0) if p1 > p0 else 0.0
            rgb = tuple(int(round(c0[k] + (c1[k] - c0[k]) * t))
                        for k in range(3))
            return "#%02x%02x%02x" % rgb
    return "#fde725"


# ---------------------------------------------------------------------------
# data
# ---------------------------------------------------------------------------
def read_iq(path):
    return R.read_iq(path)


def write_iq(path, values):
    with path.open("w") as stream:
        for v in values:
            stream.write(f"{int(v.real)} {int(v.imag)}\n")


def active_blocks():
    return [int(v) for v in (WORK / "active_blocks.txt").read_text().split()]


def golden_map():
    """Float model: ADC -> range FFT -> Doppler FFT for the active bins."""
    adc = read_iq(WORK / "adc.txt")
    win_r = R.load_window(N_RANGE)
    win_d = R.load_window(N_DOPPLER)
    blocks = active_blocks()
    bins = [b * BLOCK + i for b in blocks for i in range(BLOCK)]

    # range FFT once per chirp; keep only the active bins
    cube = {r: [] for r in bins}
    for c in range(N_DOPPLER):
        frame = adc[c * N_RANGE:(c + 1) * N_RANGE]
        x = [complex(int(v.real) * win_r[n] / 32768.0,
                     int(v.imag) * win_r[n] / 32768.0)
             for n, v in enumerate(frame)]
        spec = R.fft(x)
        for r in bins:
            cube[r].append(spec[r] / float(1 << R.SHIFT_RANGE))

    out = {}
    for r in bins:
        y = [cube[r][c] * (win_d[c] / 32768.0) for c in range(N_DOPPLER)]
        out[r] = [v / float(1 << R.SHIFT_DOPPLER) for v in R.fft(y)]
    return bins, out


def fpga_map():
    """Real AIE 256-point FFT on the HLS Doppler-window output."""
    even = read_iq(WORK / "dop_win0.txt")
    odd = read_iq(WORK / "dop_win1.txt")
    blocks = active_blocks()
    frames = len(even) // (N_DOPPLER // 2)
    if frames != len(blocks) * BLOCK:
        raise SystemExit(f"expected {len(blocks) * BLOCK} frames, got {frames}")

    bins = [b * BLOCK + i for b in blocks for i in range(BLOCK)]
    out = {}
    for f in range(frames):
        base = f * (N_DOPPLER // 2)
        x = []
        for i in range(N_DOPPLER // 2):
            x.extend((even[base + i], odd[base + i]))

        write_iq(AIE / "data/temp_input0.txt", [0j] * 1024)
        write_iq(AIE / "data/temp_input1.txt", [0j] * 1024)
        write_iq(AIE / "data/temp_input2.txt", x[0::2])
        write_iq(AIE / "data/temp_input3.txt", x[1::2])
        write_iq(AIE / "data/temp_input4.txt", [0j] * 64)
        write_iq(AIE / "data/temp_input5.txt", [0j] * 64)

        cmd = (f"source '{SETTINGS}' >/dev/null 2>&1; cd '{BUILD}' && "
               f"x86simulator --pkg-dir=./Work --i=../../")
        res = subprocess.run(["bash", "-lc", cmd], text=True,
                             stdout=subprocess.PIPE,
                             stderr=subprocess.STDOUT)
        if res.returncode:
            print(res.stdout[-2000:], file=sys.stderr)
            raise SystemExit(f"x86sim failed on frame {f}")

        g0 = read_iq(SIMOUT / "temp_output2.txt")
        g1 = read_iq(SIMOUT / "temp_output3.txt")
        spec = []
        for i in range(N_DOPPLER // 2):
            spec.extend((g0[i], g1[i]))
        out[bins[f]] = spec
        print(f"  AIE Doppler frame {f + 1}/{frames} (range bin {bins[f]})")
    return bins, out


def power_db(spec_map, bins, ref):
    """10*log10(|X|^2 / ref), ref = reference peak power."""
    rows = []
    for r in bins:
        row = []
        for v in spec_map[r]:
            p = v.real * v.real + v.imag * v.imag
            row.append(10.0 * math.log10(p / ref) if p > 0 else -200.0)
        rows.append(row)
    return rows


# ---------------------------------------------------------------------------
# drawing
# ---------------------------------------------------------------------------
def draw_map(svg, x0, y0, w, h, data, bins, title, subtitle, vmin, vmax,
             target):
    left, bottom = 92, 58
    pw, ph = w - left - 24, h - bottom - 12
    rows, cols = len(data), len(data[0])
    cw, ch = pw / cols, ph / rows

    svg.text(x0, y0 - 22, title, 17, weight="bold")
    svg.text(x0, y0 - 4, subtitle, 11, fill="#444")

    for yi, row in enumerate(data):
        for xi, db in enumerate(row):
            t = (db - vmin) / (vmax - vmin)
            svg.rect(x0 + left + xi * cw, y0 + yi * ch,
                     cw + 0.25, ch + 0.25, color(t))

    # frame
    svg.add(f'<rect x="{x0 + left:.1f}" y="{y0:.1f}" width="{pw:.1f}" '
            f'height="{ph:.1f}" fill="none" stroke="#222" stroke-width="1"/>')

    # y ticks: range in metres
    for yi in range(0, rows, 4):
        yy = y0 + yi * ch
        r_bin = bins[yi]
        svg.line(x0 + left - 5, yy, x0 + left, yy, "#333", 1)
        svg.text(x0 + left - 8, yy + 4,
                 f"{r_bin * R.RANGE_RES_M:.1f}", 10, fill="#555",
                 anchor="end")
    svg.text(x0 + 8, y0 + ph / 2, "range (m)", 11, fill="#555",
             anchor="middle", rotate=-90)

    # x ticks: Doppler velocity (columns are fftshifted)
    for col in (0, 64, 128, 192, 255):
        xx = x0 + left + (col + 0.5) * cw
        vel = (col - N_DOPPLER // 2) * R.VEL_RES_MPS
        svg.line(xx, y0 + ph, xx, y0 + ph + 5, "#333", 1)
        svg.text(xx, y0 + ph + 18, f"{vel:+.3f}", 10, fill="#555",
                 anchor="middle")
    svg.text(x0 + left + pw / 2, y0 + ph + 40, "radial velocity (m/s)", 11,
             fill="#555", anchor="middle")

    # target marker
    if target is not None:
        tr, td = target
        if tr in bins:
            yy = y0 + bins.index(tr) * ch + ch / 2
            xx = x0 + left + ((td + N_DOPPLER // 2) % N_DOPPLER + 0.5) * cw
            svg.circle(xx, yy, 9, "#ffffff", 1.6)
            svg.text(xx + 13, yy + 4, "target", 10, fill="#ffffff")

    # colorbar
    cbx = x0 + left + pw + 8
    cbh = ph
    steps = 64
    for i in range(steps):
        t = 1.0 - i / (steps - 1)
        svg.rect(cbx, y0 + i * cbh / steps, 16, cbh / steps + 0.3,
                 color(t))
    svg.add(f'<rect x="{cbx:.1f}" y="{y0:.1f}" width="16" '
            f'height="{cbh:.1f}" fill="none" stroke="#222"/>')
    for frac, db in ((0.0, vmin), (0.5, (vmin + vmax) / 2), (1.0, vmax)):
        yy = y0 + cbh * (1 - frac)
        svg.text(cbx + 22, yy + 4, f"{db:.0f}", 10, fill="#555")
    svg.text(cbx + 22, y0 + cbh / 2 + 20, "dB", 10, fill="#555")


def header(svg, w, scene):
    svg.text(30, 30, "Moving lidar target - range/Doppler, golden vs FPGA",
             20, weight="bold")
    svg.text(30, 50,
             f"scene '{scene}': lambda {R.WAVELENGTH_M * 1e9:.0f} nm, "
             f"R {R.MOVING_RANGE_M:.2f} m, v {R.MOVING_VEL_MPS * 100:+.2f} cm/s "
             f"(bin {R.MOVING_RANGE_BIN},{R.MOVING_DOPPLER_BIN}); "
             f"range res {R.RANGE_RES_M * 100:.1f} cm, "
             f"vel res {R.VEL_RES_MPS * 1e3:.2f} mm/s, "
             f"CPI {R.CPI_S * 1e3:.3f} ms",
             11, fill="#555")


def save(svg, name):
    PLOTS.mkdir(parents=True, exist_ok=True)
    sp = PLOTS / f"{name}.svg"
    svg.save(sp)
    subprocess.run(["convert", str(sp), str(sp.with_suffix(".png"))],
                   check=True, stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL)
    print(f"wrote {sp.with_suffix('.png')}")


# ---------------------------------------------------------------------------
def main() -> int:
    scene = (WORK / "scene.txt").read_text().strip()
    bins, gold = golden_map()
    gbins, fpga = fpga_map()

    ref = max(v.real * v.real + v.imag * v.imag
              for spec in gold.values() for v in spec)
    gdb = power_db(gold, bins, ref)
    fdb = power_db(fpga, gbins, ref)

    shift = N_DOPPLER // 2
    gdb = [row[shift:] + row[:shift] for row in gdb]
    fdb = [row[shift:] + row[:shift] for row in fdb]
    med = sorted(v for row in gdb for v in row)[len(gdb) * len(gdb[0]) // 2]
    vmin = max(med - 6.0, -85.0)
    vmax = 0.0
    print(f"golden peak {10 * math.log10(ref):.1f} dB, "
          f"median noise {med:.1f} dB, colour floor {vmin:.0f} dB")

    # agreement
    gp = max(((gdb[y][x], bins[y], (x - shift) % N_DOPPLER)
              for y in range(len(bins)) for x in range(N_DOPPLER)))
    fp = max(((fdb[y][x], gbins[y], (x - shift) % N_DOPPLER)
              for y in range(len(gbins)) for x in range(N_DOPPLER)))
    print(f"golden peak at (range bin {gp[1]}, Doppler {gp[2]}) "
          f"{gp[0]:.2f} dB")
    print(f"fpga   peak at (range bin {fp[1]}, Doppler {fp[2]}) "
          f"{fp[0]:.2f} dB")
    lin = lambda db: 10.0 ** (db / 10.0)
    gv = [lin(v) for row in gdb for v in row]
    fv = [lin(v) for row in fdb for v in row]
    corr = (sum(a * b for a, b in zip(gv, fv)) /
            math.sqrt(sum(a * a for a in gv) * sum(b * b for b in fv)))
    diffs = [abs(gdb[y][x] - fdb[y][x])
             for y in range(len(bins)) for x in range(N_DOPPLER)
             if gdb[y][x] > med + 10]
    print(f"all-cell power correlation: {corr:.9f}")
    print(f"cells above noise+10 dB: max |golden-fpga| "
          f"{max(diffs):.2f} dB, mean {sum(diffs) / len(diffs):.2f} dB")

    target = (R.MOVING_RANGE_BIN, R.MOVING_DOPPLER_BIN)

    for name, data, label in (("moving_golden", gdb, "Golden (float model)"),
                              ("moving_fpga", fdb,
                               "FPGA (HLS window + AIE 256-pt FFT)")):
        svg = Svg(980, 470)
        header(svg, 980, scene)
        draw_map(svg, 30, 90, 880, 340, data, bins, label,
                 f"{len(bins)} active range bins x {N_DOPPLER} Doppler bins, "
                 f"dB relative to golden peak", vmin, vmax, target)
        save(svg, name)

    # side by side
    svg = Svg(1900, 470)
    header(svg, 1900, scene)
    draw_map(svg, 30, 90, 880, 340, gdb, bins, "Golden (float model)",
             "float FFT reference", vmin, vmax, target)
    draw_map(svg, 970, 90, 880, 340, fdb, bins,
             "FPGA (HLS window + AIE 256-pt FFT)", "real AIE output",
             vmin, vmax, target)
    save(svg, "moving_compare")
    return 0


if __name__ == "__main__":
    sys.exit(main())

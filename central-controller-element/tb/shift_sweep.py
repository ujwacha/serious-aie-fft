#!/usr/bin/env python3
"""Sweep the Doppler FFT output shift (TP_SHIFT) over 4..8.

Reads the range cube produced by the last csim run (tb/work), applies the
256-point Doppler window + FFT in Python, quantises the result with each
shift, and scores it:

    targets missed, blocks written (DRAM traffic), frames with threshold 0,
    cint16 clipping, max |cint16|, threshold min/median/max

It also renders the threshold histogram and the raw power histogram for a
representative noise-only range bin and a target range bin, plus a metrics
chart.  No third-party Python modules are used: the SVG is hand-written and
rasterised with ImageMagick's `convert`.
"""

from __future__ import annotations

import argparse
import math
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import rd_test as R  # noqa: E402

WORK = HERE / "work"
PLOTS = WORK / "plots"
SHIFTS = list(range(4, 9))
N = R.N_DOPPLER
BLOCK = R.BLOCK


# ---------------------------------------------------------------------------
# model
# ---------------------------------------------------------------------------
def powers(spec):
    return [min(int(v.real) * int(v.real) + int(v.imag) * int(v.imag),
                R.INT32_MAX) for v in spec]


def threshold_hist(spec):
    """The 64-bin histogram aie_consume_doppler() actually builds."""
    pw = powers(spec)
    mean = sum(pw) >> 8
    scale = ((16 << 24) // mean) if mean > 0 else 0
    hist = [0] * 64
    for p in pw:
        b = (p * scale) >> 24
        hist[63 if b > 63 else b] += 1
    total = 0
    median = 0
    for i, c in enumerate(hist):
        total += c
        if total > N // 2:
            median = i
            break
    return hist, mean, median


def power_hist(spec):
    """Raw power counts; the last bar is 63+."""
    hist = [0] * 64
    for p in powers(spec):
        hist[63 if p > 63 else p] += 1
    return hist


def clip_words(raw, shift):
    scale = 1.0 / float(1 << shift)
    n = 0
    for v in raw:
        if abs(round(v.real * scale)) > 32767:
            n += 1
        if abs(round(v.imag * scale)) > 32767:
            n += 1
    return n


def choose_bins(cube, frames, targets):
    """A target bin and a median-energy noise-only active bin."""
    target_r = max(targets, key=lambda r: targets[r][1])  # strongest target
    means = {}
    for r in frames:
        pw = [int(abs(cube[c][r])) ** 2 for c in range(R.N_DOPPLER)]
        means[r] = sum(pw) >> 8
    noise = [r for r in frames
             if all(abs(r - tr) > 4 for tr in targets)]
    noise.sort(key=lambda r: means[r])
    noise_r = noise[len(noise) // 2]
    return noise_r, target_r


def sweep(cube, frames, targets, noise_r, target_r):
    win = R.load_window(N)
    rows = []
    for shift in SHIFTS:
        kept = set()
        thresholds = []
        zeros = 0
        missing = 0
        clips = 0
        max_amp = 0.0
        picked = {}

        for r in frames:
            y = [R.cmul_i16(cube[c][r], complex(win[c], 0))
                 for c in range(R.N_DOPPLER)]
            raw = R.fft(y)
            scale = 1.0 / float(1 << shift)
            max_amp = max(max_amp,
                          max(max(abs(v.real), abs(v.imag)) * scale
                              for v in raw))
            clips += clip_words(raw, shift)

            spec = R.quantize_fft(raw, shift)
            t = R.frame_threshold(spec)
            thresholds.append(t)
            zeros += (t == 0)

            pw = powers(spec)
            for b in range(N // BLOCK):
                if any(p > t for p in pw[b * BLOCK:(b + 1) * BLOCK]):
                    kept.add((r, b))

            if r in (noise_r, target_r):
                picked[r] = (spec, t, pw)

        for r, (d, _amp) in targets.items():
            if (r, d // BLOCK) not in kept:
                missing += 1

        target_blocks = set()
        for r, (d, _amp) in targets.items():
            for dd in range(d - 2, d + 3):
                target_blocks.add((r, (dd % N) // BLOCK))
        false = len(kept - target_blocks)

        rows.append({
            "shift": shift,
            "kept": len(kept),
            "false": false,
            "targets": len(target_blocks),
            "missing": missing,
            "zeros": zeros,
            "clips": clips,
            "max_amp": max_amp,
            "thr_min": min(thresholds),
            "thr_med": sorted(thresholds)[len(thresholds) // 2],
            "thr_max": max(thresholds),
            "noise": picked[noise_r],
            "target": picked[target_r],
        })
    return rows


# ---------------------------------------------------------------------------
# tiny SVG writer
# ---------------------------------------------------------------------------
def esc(s):
    return (str(s).replace("&", "&amp;").replace("<", "&lt;")
            .replace(">", "&gt;"))


class Svg:
    def __init__(self, w, h):
        self.w = w
        self.h = h
        self.parts = []

    def add(self, s):
        self.parts.append(s)

    def rect(self, x, y, w, h, fill, stroke="none", sw=1, rx=0):
        self.add(f'<rect x="{x:.1f}" y="{y:.1f}" width="{w:.1f}" '
                 f'height="{h:.1f}" fill="{fill}" stroke="{stroke}" '
                 f'stroke-width="{sw}" rx="{rx}"/>')

    def line(self, x1, y1, x2, y2, stroke="#333", sw=1, dash=None):
        d = f' stroke-dasharray="{dash}"' if dash else ""
        self.add(f'<line x1="{x1:.1f}" y1="{y1:.1f}" x2="{x2:.1f}" '
                 f'y2="{y2:.1f}" stroke="{stroke}" stroke-width="{sw}"{d}/>')

    def text(self, x, y, s, size=12, fill="#111", anchor="start",
             weight="normal", family="sans-serif"):
        self.add(f'<text x="{x:.1f}" y="{y:.1f}" font-family="{family}" '
                 f'font-size="{size}" fill="{fill}" '
                 f'text-anchor="{anchor}" font-weight="{weight}">{esc(s)}</text>')

    def save(self, path):
        body = "\n".join(self.parts)
        path.write_text(
            f'<svg xmlns="http://www.w3.org/2000/svg" width="{self.w}" '
            f'height="{self.h}" viewBox="0 0 {self.w} {self.h}">\n'
            f'<rect width="{self.w}" height="{self.h}" fill="#ffffff"/>\n'
            f'{body}\n</svg>\n')


def draw_hist(svg, x, y, w, h, hist, title, subtitle, color,
              median_bin=None, last_label="63+", note="", xlabel=None):
    """Draw one histogram panel.  (x, y) is the top-left of the plot box."""
    axis_l, axis_b = 48, 38
    px, py = x + axis_l, y
    pw, ph = w - axis_l - 12, h - axis_b
    ymax = max(1, max(hist))
    if ymax < 8:
        ymax = 8
    else:
        ymax = int(math.ceil(ymax / 32.0) * 32)

    svg.text(x, y - 34, title, 15, weight="bold")
    svg.text(x, y - 16, subtitle, 11, fill="#444")

    # grid + y ticks
    for frac in (0.0, 0.5, 1.0):
        yy = py + ph * (1 - frac)
        svg.line(px, yy, px + pw, yy, "#e5e7eb", 1)
        svg.text(px - 8, yy + 4, str(int(ymax * frac)), 11,
                 fill="#555", anchor="end")

    n = len(hist)
    bw = pw / n
    for i, count in enumerate(hist):
        bh = (count / ymax) * ph
        if bh <= 0:
            continue
        svg.rect(px + i * bw + 0.4, py + ph - bh, max(1.0, bw - 0.8),
                 max(0.5, bh), color)

    # axes
    svg.line(px, py, px, py + ph, "#333", 1.2)
    svg.line(px, py + ph, px + pw, py + ph, "#333", 1.2)

    # x ticks
    if n == 64:
        ticks = [0, 16, 32, 48, 63]
    else:
        ticks = [0, 16, 32, 48, n - 1]
    for t in ticks:
        tx = px + (t + 0.5) * bw
        svg.line(tx, py + ph, tx, py + ph + 5, "#333", 1)
        label = last_label if t == n - 1 else str(t)
        svg.text(tx, py + ph + 18, label, 10, fill="#555", anchor="middle")

    if xlabel is None:
        xlabel = "power bin" if last_label == "63+" else "histogram bin"
    svg.text(px + pw / 2, py + ph + 34, xlabel, 11, fill="#555",
             anchor="middle")

    if median_bin is not None:
        mx = px + (median_bin + 0.5) * bw
        svg.line(mx, py, mx, py + ph, "#dc2626", 1.5, dash="4,3")
        svg.text(min(mx + 5, px + pw - 4), py + 12, f"median {median_bin}",
                 10, fill="#dc2626")

    if note:
        svg.text(px + pw, py + 12, note, 10, fill="#dc2626", anchor="end")


def render_histograms(rows, noise_r, target_r, path, mode):
    row_h = 305
    width = 1500
    height = 70 + row_h * len(rows) + 20
    svg = Svg(width, height)
    svg.text(35, 30, f"Doppler FFT shift sweep - {mode} histogram",
             20, weight="bold")
    svg.text(35, 50, f"range cube from tb/work, scene "
             f"'{WORK.joinpath('scene.txt').read_text().strip()}', "
             f"noise bin {noise_r}, target bin {target_r}",
             11, fill="#555")

    for i, row in enumerate(rows):
        top = 70 + i * row_h + 55
        for col, (label, key, color) in enumerate((
                (f"noise-only range bin {noise_r}", "noise", "#3b82f6"),
                (f"target range bin {target_r}", "target", "#f59e0b"))):
            spec, thr, pw = row[key]
            if mode == "threshold":
                hist, mean, median = threshold_hist(spec)
                zeros = sum(1 for p in pw if p == 0)
                title = f"SHIFT {row['shift']} - {label}"
                bw = (4.0 * mean) / 64.0
                sub = (f"mean power {mean}, bin width {bw:.1f}, "
                       f"median bin {median}, threshold {thr}, "
                       f"zero powers {zeros}/256")
                draw_hist(svg, 70 + col * 740, top, 650, 210, hist,
                          title, sub, color, median_bin=median,
                          last_label="63", xlabel="threshold histogram bin")
            else:
                hist = power_hist(spec)
                zeros = sum(1 for p in pw if p == 0)
                title = f"SHIFT {row['shift']} - {label}"
                sub = (f"zero powers {zeros}/256, max power {max(pw)}, "
                       f"threshold {thr}")
                draw_hist(svg, 70 + col * 740, top, 650, 210, hist,
                          title, sub, color, last_label="63+",
                          note=f"{zeros} zeros", xlabel="power bin")
    svg.save(path)


def render_metrics(rows, best, path):
    width, height = 1500, 760
    svg = Svg(width, height)
    svg.text(35, 30, "Doppler FFT shift sweep - traffic, threshold, headroom",
             20, weight="bold")
    svg.text(35, 50, f"best shift = {best}  "
             f"(fewest blocks written with no target missed, no clipping, "
             f"and no zero thresholds)", 12, fill="#166534")

    panels = [
        ("blocks written to DRAM", "stacked target / noise", 0, 430),
        ("frames with threshold == 0", "out of 256 range bins", 500, 430),
        ("max |cint16| after shift", "clip limit 32767", 1000, 430),
    ]
    base_y, ph = 110, 280
    for title, sub, x, w in panels:
        svg.text(x, base_y - 38, title, 14, weight="bold")
        svg.text(x, base_y - 20, sub, 11, fill="#555")
        svg.line(x, base_y, x, base_y + ph, "#333", 1.2)
        svg.line(x, base_y + ph, x + w, base_y + ph, "#333", 1.2)

    shifts = [r["shift"] for r in rows]
    bar_w = 56
    gap = 30
    # panel 1: stacked traffic
    ymax1 = 4200
    for i, r in enumerate(rows):
        x = 40 + i * (bar_w + gap) + 30
        th = (r["targets"] / ymax1) * ph
        fh = (r["false"] / ymax1) * ph
        svg.rect(x, base_y + ph - th, bar_w, th, "#22c55e")
        svg.rect(x, base_y + ph - th - fh, bar_w, fh, "#ef4444")
        svg.text(x + bar_w / 2, base_y + ph - th - fh - 6,
                 str(r["kept"]), 11, anchor="middle")
        svg.text(x + bar_w / 2, base_y + ph + 18, str(r["shift"]), 12,
                 anchor="middle")
    svg.text(40 + 30, base_y - 4, "target", 10, fill="#22c55e")
    svg.text(40 + 90, base_y - 4, "noise", 10, fill="#ef4444")
    for v in (0, 2100, 4200):
        yy = base_y + ph - (v / ymax1) * ph
        svg.line(40, yy, 40 + 430, yy, "#e5e7eb", 1)
        svg.text(32, yy + 4, str(v), 10, fill="#555", anchor="end")

    for v in (0, 128, 256):
        yy = base_y + ph - (v / 256) * ph
        svg.line(500, yy, 930, yy, "#e5e7eb", 1)
        svg.text(492, yy + 4, str(v), 10, fill="#555", anchor="end")

    # panel 2: zero-threshold frames
    for i, r in enumerate(rows):
        x = 540 + i * (bar_w + gap) + 30
        bh = (r["zeros"] / 256) * ph
        svg.rect(x, base_y + ph - bh, bar_w, max(bh, 0.5),
                 "#ef4444" if r["zeros"] else "#22c55e")
        svg.text(x + bar_w / 2, base_y + ph - bh - 6, str(r["zeros"]),
                 11, anchor="middle")
        svg.text(x + bar_w / 2, base_y + ph + 18, str(r["shift"]), 12,
                 anchor="middle")

    # panel 3: headroom
    ymax3 = 34000
    for v in (0, 17000, 34000):
        yy = base_y + ph - (v / ymax3) * ph
        svg.line(1000, yy, 1430, yy, "#e5e7eb", 1)
        svg.text(992, yy + 4, str(v), 10, fill="#555", anchor="end")
    for i, r in enumerate(rows):
        x = 1040 + i * (bar_w + gap) + 30
        bh = (r["max_amp"] / ymax3) * ph
        svg.rect(x, base_y + ph - bh, bar_w, max(bh, 0.5), "#3b82f6")
        svg.text(x + bar_w / 2, base_y + ph - bh - 6,
                 f"{r['max_amp']:.0f}", 10, anchor="middle")
        svg.text(x + bar_w / 2, base_y + ph + 18, str(r["shift"]), 12,
                 anchor="middle")
    clip_y = base_y + ph - (32767 / ymax3) * ph
    svg.line(1000, clip_y, 1480, clip_y, "#dc2626", 1.2, dash="5,3")
    svg.text(1478, clip_y - 5, "32767", 10, fill="#dc2626", anchor="end")

    # table
    ty = 480
    svg.text(35, ty, "shift   kept   noise   targets missed   clip   "
             "threshold min / median / max", 13, weight="bold",
             family="monospace")
    for i, r in enumerate(rows):
        line_y = ty + 22 + i * 20
        text = (f"{r['shift']:5d} {r['kept']:6d} {r['false']:7d} "
                f"{r['missing']:14d} {r['clips']:6d}   "
                f"{r['thr_min']:6d} / {r['thr_med']:6d} / {r['thr_max']:6d}")
        color = "#166534" if r["shift"] == best else "#111"
        svg.text(35, line_y, text, 12, fill=color, family="monospace")
    svg.save(path)


# ---------------------------------------------------------------------------
def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--chirps", type=int, default=R.N_DOPPLER)
    args = ap.parse_args()

    scene = (WORK / "scene.txt").read_text().strip()
    cube, masks = R.load_aie_range(args.chirps)
    blocks = R.active_blocks(masks)
    frames = [b * BLOCK + i for b in blocks for i in range(BLOCK)]
    targets = {r: (d, amp) for r, d, amp, _ in R.SCENES[scene]}

    noise_r, target_r = choose_bins(cube, frames, targets)
    rows = sweep(cube, frames, targets, noise_r, target_r)

    eligible = [r for r in rows if r["missing"] == 0 and r["clips"] == 0]
    best = min(eligible,
               key=lambda r: (r["zeros"] > 0, r["kept"]))["shift"]

    print(f"scene {scene}: {len(frames)} active range bins, "
          f"{len(targets)} targets; noise bin {noise_r}, "
          f"target bin {target_r}")
    print(f"{'shift':>5} {'thr==0':>6} {'kept':>6} {'noise':>6} "
          f"{'miss':>4} {'clip':>5} {'maxamp':>8} "
          f"{'thr min/med/max':>22}")
    for r in rows:
        print(f"{r['shift']:5d} {r['zeros']:6d} {r['kept']:6d} "
              f"{r['false']:6d} {r['missing']:4d} {r['clips']:5d} "
              f"{r['max_amp']:8.0f} {r['thr_min']:7d}/{r['thr_med']:7d}/"
              f"{r['thr_max']:7d}")
    print(f"best shift: {best}")

    PLOTS.mkdir(parents=True, exist_ok=True)
    p1 = PLOTS / "doppler_shift_threshold_hist.svg"
    p2 = PLOTS / "doppler_shift_power_hist.svg"
    p3 = PLOTS / "doppler_shift_metrics.svg"
    render_histograms(rows, noise_r, target_r, p1, "threshold")
    render_histograms(rows, noise_r, target_r, p2, "power")
    render_metrics(rows, best, p3)
    for svg in (p1, p2, p3):
        png = svg.with_suffix(".png")
        subprocess.run(["convert", str(svg), str(png)], check=True,
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        print(f"wrote {png}")
    return 0


if __name__ == "__main__":
    sys.exit(main())

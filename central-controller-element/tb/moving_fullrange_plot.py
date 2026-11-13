#!/usr/bin/env python3
"""Full-range view (0 m .. max unambiguous range) of the moving scene.

Same data as moving_plot.py, but the y axis is the whole 2048-bin range axis
instead of only the kept block.  Everything outside the surviving range block
is black, because the range/Doppler gates never wrote it.

Golden panel: float model with the hardware shifts and the same per-row
16-bin chunk threshold as aie_consume_doppler().
FPGA panel:   the cube the HLS kernel actually left in DRAM.

    ./moving_fullrange_plot.py
"""

from __future__ import annotations

import math
import sys
from pathlib import Path

TB = Path(__file__).resolve().parent
sys.path.insert(0, str(TB))
import moving_plot as M  # noqa: E402
import rd_test as R  # noqa: E402

WORK = TB / "work"
N_RANGE = R.N_RANGE
N_DOPPLER = R.N_DOPPLER
MAX_RANGE_M = N_RANGE * R.RANGE_RES_M


def q16(v):
    return complex(R.clamp16(R.round_away(v.real)),
                   R.clamp16(R.round_away(v.imag)))


def chunk_keep(spec):
    """aie_consume_doppler's 16-bin keep rule, on an already-scaled spectrum."""
    q = [q16(v) for v in spec]
    thr = R.frame_threshold(q)
    out = []
    for b in range(N_DOPPLER // R.BLOCK):
        chunk = q[b * R.BLOCK:(b + 1) * R.BLOCK]
        keep = any(int(v.real) * int(v.real) + int(v.imag) * int(v.imag) > thr
                   for v in chunk)
        out.extend(chunk if keep else [0j] * R.BLOCK)
    return out


def to_db(spec, ref):
    db = []
    for v in spec:
        p = v.real * v.real + v.imag * v.imag
        db.append(10.0 * math.log10(p / ref) if p > 0 else -200.0)
    return db


def draw_inset(svg, x, y, w, h, rows, bins, vmin, vmax, target):
    """Magnified view of the kept range block, for the full-range main plot."""
    cw, ch = w / N_DOPPLER, h / len(rows)
    svg.rect(x, y, w, h, "#000000")
    for yi, db_row in enumerate(rows):
        for xi, db in enumerate(db_row):
            svg.rect(x + xi * cw, y + yi * ch, cw + 0.3, ch + 0.3,
                     M.color((db - vmin) / (vmax - vmin)))
    svg.add(f'<rect x="{x:.1f}" y="{y:.1f}" width="{w:.1f}" '
            f'height="{h:.1f}" fill="none" stroke="#dddddd" stroke-width="1.5"/>')
    tr, td = target
    if tr in bins:
        yy = y + bins.index(tr) * ch + ch / 2
        xx = x + ((td + N_DOPPLER // 2) % N_DOPPLER + 0.5) * cw
        svg.circle(xx, yy, 8, "#ffffff", 1.4)
    svg.text(x, y - 6, f"zoom: kept block {bins[0] * R.RANGE_RES_M:.1f}-"
             f"{bins[-1] * R.RANGE_RES_M:.1f} m", 10, fill="#bbbbbb")
    for yi in (0, len(rows) - 1):
        svg.text(x - 5, y + yi * ch + 4,
                 f"{bins[yi] * R.RANGE_RES_M:.0f}", 9, fill="#bbbbbb",
                 anchor="end")


def draw_full(svg, x0, y0, w, h, rows, bins, title, subtitle, vmin, vmax,
              target):
    left, bottom = 92, 58
    pw, ph = w - left - 24, h - bottom - 12
    cw = pw / N_DOPPLER
    rh = ph / N_RANGE                      # one range bin

    svg.text(x0, y0 - 22, title, 17, weight="bold")
    svg.text(x0, y0 - 4, subtitle, 11, fill="#444")

    # everything the gates rejected stays black
    svg.rect(x0 + left, y0, pw, ph, "#000000")

    for db_row, r in zip(rows, bins):
        for xi, db in enumerate(db_row):
            svg.rect(x0 + left + xi * cw, y0 + r * rh,
                     cw + 0.4, rh + 0.4, M.color((db - vmin) / (vmax - vmin)))

    svg.add(f'<rect x="{x0 + left:.1f}" y="{y0:.1f}" width="{pw:.1f}" '
            f'height="{ph:.1f}" fill="none" stroke="#222" stroke-width="1"/>')

    # range ticks every 50 m
    for r_m in range(0, int(MAX_RANGE_M) + 1, 50):
        yy = y0 + (r_m / R.RANGE_RES_M) * rh
        if yy > y0 + ph:
            continue
        svg.line(x0 + left - 5, yy, x0 + left, yy, "#333", 1)
        svg.line(x0 + left, yy, x0 + left + pw, yy, "#333", 1, dash="1,6")
        svg.text(x0 + left - 8, yy + 4, f"{r_m}", 10, fill="#555",
                 anchor="end")
    svg.text(x0 + 10, y0 + ph / 2, "range (m)", 11, fill="#555",
             anchor="middle", rotate=-90)

    for col in (0, 64, 128, 192, 255):
        xx = x0 + left + (col + 0.5) * cw
        vel = (col - N_DOPPLER // 2) * R.VEL_RES_MPS
        svg.line(xx, y0 + ph, xx, y0 + ph + 5, "#333", 1)
        svg.text(xx, y0 + ph + 18, f"{vel:+.3f}", 10, fill="#555",
                 anchor="middle")
    svg.text(x0 + left + pw / 2, y0 + ph + 40, "radial velocity (m/s)", 11,
             fill="#555", anchor="middle")

    if target is not None:
        tr, td = target
        yy = y0 + (tr + 0.5) * rh
        xx = x0 + left + ((td + N_DOPPLER // 2) % N_DOPPLER + 0.5) * cw
        svg.circle(xx, yy, 9, "#ffffff", 1.6)
        svg.text(xx + 13, yy + 4, "target", 10, fill="#ffffff")

    # magnified detail of the only occupied band (bottom-right corner)
    draw_inset(svg, x0 + left + pw - 250 - 10, y0 + ph - 110 - 10,
               250, 110, rows, bins, vmin, vmax, target)

    cbx = x0 + left + pw + 8
    steps = 64
    for i in range(steps):
        t = 1.0 - i / (steps - 1)
        svg.rect(cbx, y0 + i * ph / steps, 16, ph / steps + 0.3, M.color(t))
    svg.add(f'<rect x="{cbx:.1f}" y="{y0:.1f}" width="16" '
            f'height="{ph:.1f}" fill="none" stroke="#222"/>')
    for frac, db in ((0.0, vmin), (0.5, (vmin + vmax) / 2), (1.0, vmax)):
        svg.text(cbx + 22, y0 + ph * (1 - frac) + 4, f"{db:.0f}", 10,
                 fill="#555")
    svg.text(cbx + 22, y0 + ph / 2 + 20, "dB", 10, fill="#555")


def main():
    scene = (WORK / "scene.txt").read_text().strip()
    blocks = [int(v) for v in (WORK / "active_blocks.txt").read_text().split()]
    bins = [b * R.BLOCK + i for b in blocks for i in range(R.BLOCK)]
    cube = R.read_iq(WORK / "mm_doppler.txt")

    _, gold = M.golden_map()
    gold_rows = [chunk_keep(gold[r]) for r in bins]
    fpga_rows = [cube[r * N_DOPPLER:(r + 1) * N_DOPPLER] for r in bins]

    ref = max(v.real * v.real + v.imag * v.imag
              for row in gold_rows for v in row)
    gdb = [to_db(row, ref) for row in gold_rows]
    fdb = [to_db(row, ref) for row in fpga_rows]

    shift = N_DOPPLER // 2
    gdb = [row[shift:] + row[:shift] for row in gdb]
    fdb = [row[shift:] + row[:shift] for row in fdb]

    vmin, vmax = -68.0, 0.0
    target = (R.MOVING_RANGE_BIN, R.MOVING_DOPPLER_BIN)
    sub = (f"full range 0-{MAX_RANGE_M:.0f} m, {N_RANGE} bins x "
           f"{N_DOPPLER} Doppler; only block {blocks[0]} "
           f"({bins[0] * R.RANGE_RES_M:.1f}-{bins[-1] * R.RANGE_RES_M:.1f} m) "
           f"survived the gates")

    for name, rows, label in (
            ("moving_fullrange_golden", gdb,
             "Golden (float model + hardware threshold)"),
            ("moving_fullrange_fpga", fdb,
             "FPGA (cube left in DRAM by the HLS kernel)")):
        svg = M.Svg(980, 470)
        M.header(svg, 980, scene)
        draw_full(svg, 30, 90, 880, 340, rows, bins, label, sub,
                  vmin, vmax, target)
        M.save(svg, name)

    svg = M.Svg(1900, 470)
    M.header(svg, 1900, scene)
    draw_full(svg, 30, 90, 880, 340, gdb, bins,
              "Golden (float model + hardware threshold)", sub,
              vmin, vmax, target)
    draw_full(svg, 970, 90, 880, 340, fdb, bins,
              "FPGA (cube left in DRAM by the HLS kernel)", sub,
              vmin, vmax, target)
    M.save(svg, "moving_fullrange_compare")

    gv = [10.0 ** (v / 10.0) for row in gdb for v in row]
    fv = [10.0 ** (v / 10.0) for row in fdb for v in row]
    corr = (sum(a * b for a, b in zip(gv, fv)) /
            math.sqrt(sum(a * a for a in gv) * sum(b * b for b in fv)))
    print(f"full-range thresholded maps: correlation {corr:.9f}")
    print(f"non-zero cells: golden {sum(1 for row in gdb for v in row if v > -100)}, "
          f"fpga {sum(1 for row in fdb for v in row if v > -100)} "
          f"of {N_RANGE * N_DOPPLER} full-map cells")
    print(f"max range {MAX_RANGE_M:.1f} m, kept band "
          f"{bins[0] * R.RANGE_RES_M:.2f}-{bins[-1] * R.RANGE_RES_M:.2f} m")


if __name__ == "__main__":
    main()

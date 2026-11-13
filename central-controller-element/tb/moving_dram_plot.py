#!/usr/bin/env python3
"""Plot the Doppler cube as it actually sits in DRAM after the threshold.

Rejected 16-bin chunks are never written, so they read back as 0 -> black.
This is the post-threshold counterpart of moving_{golden,fpga}.png.

    ./moving_dram_plot.py
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


def main():
    bins = [int(v) for v in (WORK / "active_blocks.txt").read_text().split()]
    bins = [b * R.BLOCK + i for b in bins for i in range(R.BLOCK)]
    cube = R.read_iq(WORK / "mm_doppler.txt")

    peak = max(v.real * v.real + v.imag * v.imag for v in cube)
    rows = []
    kept_chunks = kept_cells = 0
    for r in bins:
        row = cube[r * R.N_DOPPLER:(r + 1) * R.N_DOPPLER]
        db = []
        for v in row:
            p = v.real * v.real + v.imag * v.imag
            db.append(10.0 * math.log10(p / peak) if p > 0 else -200.0)
        rows.append(db)
        for k in range(R.N_DOPPLER // R.BLOCK):
            if any(int(v.real) != 0 or int(v.imag) != 0
                   for v in row[k * R.BLOCK:(k + 1) * R.BLOCK]):
                kept_chunks += 1
                kept_cells += sum(1 for v in row[k * R.BLOCK:(k + 1) * R.BLOCK]
                                  if int(v.real) != 0 or int(v.imag) != 0)

    shift = R.N_DOPPLER // 2
    rows = [row[shift:] + row[:shift] for row in rows]
    zero = [[v <= -100 for v in row] for row in rows]
    rows = [[0.0 if v <= -100 else v for v in row] for row in rows]

    vmin, vmax = -68.0, 0.0
    svg = M.Svg(980, 470)
    M.header(svg, 980, (WORK / "scene.txt").read_text().strip())
    M.draw_map(
        svg, 30, 90, 880, 340, rows, bins,
        "FPGA DRAM after the Doppler threshold (black = not written)",
        f"{len(bins)} active range bins x {R.N_DOPPLER} Doppler bins; "
        f"{kept_chunks}/{len(bins) * 16} 16-bin chunks kept, "
        f"{kept_cells}/{len(bins) * R.N_DOPPLER} cells "
        f"({100 * kept_cells / (len(bins) * R.N_DOPPLER):.1f}%), rest = 0",
        vmin, vmax, (R.MOVING_RANGE_BIN, R.MOVING_DOPPLER_BIN))

    # paint the untouched cells black so rejection is unmistakable
    x0, y0, w, h = 30, 90, 880, 340
    left, bottom = 92, 58
    pw, ph = w - left - 24, h - bottom - 12
    cw, ch = pw / len(rows[0]), ph / len(rows)
    for yi, row in enumerate(zero):
        for xi, z in enumerate(row):
            if z:
                svg.rect(x0 + left + xi * cw, y0 + yi * ch,
                         cw + 0.25, ch + 0.25, "#000000")
    M.save(svg, "moving_dram")


if __name__ == "__main__":
    main()

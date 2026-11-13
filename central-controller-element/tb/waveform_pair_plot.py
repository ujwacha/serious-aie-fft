#!/usr/bin/env python3
"""The dual-slope pair: one up-chirp plus one down-chirp, frequency vs time.

A single chirp only gives one beat tone, and range and Doppler are mixed into
it.  Alternating the slope sign reverses the Doppler term, so two tones from
the same target separate cleanly:

    f_up   = f_R - f_D
    f_down = f_R + f_D
    f_R    = (f_up + f_down) / 2      -> range
    f_D    = (f_down - f_up) / 2      -> velocity

    ./waveform_pair_plot.py
"""

from __future__ import annotations

import subprocess
from pathlib import Path

from waveform_chirp_plot import (B, C, F_BEAT, F_DOP, N_CHIRPS, R_REF, T, TAU,
                                 V_REF, Svg)

OUT = Path(__file__).resolve().parent / "work" / "plots"

F_UP = F_BEAT - F_DOP
F_DOWN = F_BEAT + F_DOP


def main():
    svg = Svg(1220, 660)

    svg.text(60, 34, "Dual-slope pair: one up-chirp and one down-chirp",
             19, weight="bold")
    svg.text(60, 56,
             f"same target at {R_REF:.0f} m approaching at {V_REF:.0f} m/s; "
             f"B {B / 1e9:.2f} GHz, T {T:.0f} ns per chirp, "
             f"fs {0.98:.2f} GS/s", 11, c="#555")

    x0, y0, pw, ph = 110, 100, 980, 360
    t_max = 2.0 * T

    def X(t_ns):
        return x0 + t_ns / t_max * pw

    def Y(f_hz):
        return y0 + ph - f_hz / B * ph

    svg.rect(x0, y0, pw, ph, "#fbfbfd", stroke="#dcdcdc")

    for i in range(5):
        t = t_max * i / 4
        svg.line(X(t), y0, X(t), y0 + ph, "#ececf2")
        svg.text(X(t), y0 + ph + 20, f"{t:.0f}", 10, c="#555",
                 anchor="middle")
    for i in range(7):
        f = B * i / 6
        svg.line(x0, Y(f), x0 + pw, Y(f), "#ececf2")
        svg.text(x0 - 8, Y(f) + 4, f"{f / 1e9:.2f}", 10, c="#555", anchor="end")

    svg.line(x0, y0 + ph, x0 + pw, y0 + ph, "#333", 1.4)
    svg.line(x0, y0, x0, y0 + ph, "#333", 1.4)
    svg.text(x0, y0 - 12, "beat frequency offset from f0 (GHz)", 12, c="#333")
    svg.text(x0 + pw / 2, y0 + ph + 40, "time (ns)", 12, anchor="middle",
             c="#333")

    # chirp boundaries
    svg.line(X(T), y0, X(T), y0 + ph, "#9a9a9a", 1.2, dash="5,4")
    for t, name in ((0.0, "chirp 0: up"), (T, "chirp 1: down")):
        svg.text(X(t) + 10, y0 + 20, name, 11, c="#666", weight="bold")

    # transmit: up then down
    svg.poly([(X(0), Y(0)), (X(T), Y(B)), (X(t_max), Y(0))], "#1f77b4", 2.6)

    # echoes: delayed, and shifted by -f_D (up) / +f_D (down)
    svg.poly([(X(TAU), Y(0)), (X(T), Y(B * (T - TAU) / T - F_DOP * 1e6))],
             "#e07b00", 2.2, dash="7,4")
    svg.poly([(X(T + TAU), Y(B)),
              (X(t_max), Y(B * TAU / T + F_DOP * 1e6))],
             "#2ca02c", 2.2, dash="7,4")

    # beat gaps
    for t_a, gap, col, dy in ((0.55 * T, F_UP, "#d62728", 0),
                              (1.45 * T, F_DOWN, "#1b7f3b", -18)):
        f_tx = B * (t_a / T) if t_a < T else B * (2.0 - t_a / T)
        f_rx = f_tx - gap * 1e6 if t_a < T else f_tx + gap * 1e6
        svg.arrow(X(t_a), Y(f_tx), Y(f_rx), col)
        ym = (Y(f_tx) + Y(f_rx)) / 2 + dy
        svg.add(f'<rect x="{X(t_a) + 8:.1f}" y="{ym - 11:.1f}" width="74" '
                f'height="21" rx="3" fill="#ffffff" fill-opacity="0.92" '
                f'stroke="{col}"/>')
        svg.text(X(t_a) + 45, ym + 4, f"{gap:.0f} MHz", 11, c=col,
                 anchor="middle", weight="bold")

    # legend
    lx, ly = x0 + 760, y0 + 26
    svg.line(lx, ly, lx + 30, ly, "#1f77b4", 2.6)
    svg.text(lx + 38, ly + 4, "transmit", 10)
    svg.line(lx, ly + 18, lx + 30, ly + 18, "#e07b00", 2.2, dash="7,4")
    svg.text(lx + 38, ly + 22, "echo, up-chirp", 10)
    svg.line(lx, ly + 36, lx + 30, ly + 36, "#2ca02c", 2.2, dash="7,4")
    svg.text(lx + 38, ly + 40, "echo, down-chirp", 10)

    # ------------------------------------------------------------ summary
    bx, by, bw, bh = 110, 500, 980, 118
    svg.rect(bx, by, bw, bh, "#f7f9fc", stroke="#d7dfea", radius=6)
    svg.text(bx + 20, by + 28,
             "Two tones from one target, separated by the slope sign:", 13,
             weight="bold")
    svg.text(bx + 20, by + 56,
             f"f_up = f_R - f_D = {F_UP:.0f} MHz      "
             f"f_down = f_R + f_D = {F_DOWN:.0f} MHz", 12, c="#333")
    svg.text(bx + 20, by + 82,
             f"range   (f_up + f_down)/2 = {F_BEAT:.0f} MHz  ->  "
             f"{R_REF:.0f} m", 12, c="#1f4e79")
    svg.text(bx + 20, by + 104,
             f"velocity (f_down - f_up)/2 = {F_DOP:.0f} MHz  ->  "
             f"{V_REF:.0f} m/s", 12, c="#1b7f3b")
    svg.text(bx + 560, by + 56,
             "One chirp alone cannot separate them:", 11, c="#a33")
    svg.text(bx + 560, by + 74,
             "928 MHz is 100 m at 0 m/s, or 94 m at 30 m/s.", 11, c="#a33")
    svg.text(bx + 560, by + 96,
             f"A {N_CHIRPS}-chirp CPI repeats this pair {N_CHIRPS // 2} times.",
             11, c="#666")

    out = OUT / "waveform_pair.svg"
    svg.save(out)
    subprocess.run(["convert", str(out), str(out.with_suffix(".png"))],
                   check=False, stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL)

    print(f"f_up {F_UP:.1f} MHz, f_down {F_DOWN:.1f} MHz")
    print(f"f_R from the sum {(F_UP + F_DOWN) / 2:.1f} MHz  (100 m)")
    print(f"f_D from the difference {(F_DOWN - F_UP) / 2:.1f} MHz  (30 m/s)")
    print(f"wrote {out.with_suffix('.png')}")


if __name__ == "__main__":
    main()

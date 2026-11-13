#!/usr/bin/env python3
"""Frequency vs time for one chirp of the recommended automotive waveform.

Transmit ramp plus the delayed echo, so the beat frequency is visible as the
vertical gap between the two lines.  The lower strip places that beat against
the 0..fs beat band, together with the Doppler shift that the dual-slope
estimator uses.

    ./waveform_chirp_plot.py
"""

from __future__ import annotations

import math
import subprocess
from pathlib import Path

C = 299792458.0
LAM = 1153e-9
N_RANGE = 2048
N_CHIRPS = 256

# recommended design from waveform_optimizer.py (100 m, 30 m/s, ~5 cm)
B = 2.907e9
FS = 0.98e9
T = N_RANGE / FS * 1e9                     # ns
SLOPE = B / (T * 1e-9)                     # Hz/s

R_REF = 100.0
V_REF = 30.0
TAU = 2.0 * R_REF / C * 1e9                # ns
F_BEAT = SLOPE * TAU * 1e-15               # MHz
F_DOP = 2.0 * V_REF / LAM * 1e-6           # MHz
R_NYQ = N_RANGE * C / (2.0 * B)

OUT = Path(__file__).resolve().parent / "work" / "plots"


def esc(s):
    return str(s).replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


class Svg:
    def __init__(self, w, h):
        self.w, self.h, self.p = w, h, []

    def add(self, s):
        self.p.append(s)

    def line(self, x1, y1, x2, y2, c="#333", w=1, dash=None):
        d = f' stroke-dasharray="{dash}"' if dash else ""
        self.add(f'<line x1="{x1:.1f}" y1="{y1:.1f}" x2="{x2:.1f}" y2="{y2:.1f}" '
                 f'stroke="{c}" stroke-width="{w}"{d}/>')

    def arrow(self, x, y1, y2, c="#d62728", w=2.2, head=7.0):
        """Vertical double-headed arrow; drawn explicitly (no SVG markers)."""
        self.line(x, y1, x, y2, c, w)
        for yy, sgn in ((y1, 1.0), (y2, -1.0)):
            self.add(f'<path d="M {x - head / 2:.1f} {yy + sgn * head:.1f} '
                     f'L {x:.1f} {yy:.1f} L {x + head / 2:.1f} '
                     f'{yy + sgn * head:.1f} z" fill="{c}" stroke="none"/>')

    def poly(self, pts, c="#1f77b4", w=2, fill="none", dash=None, opacity=1.0):
        d = " ".join(("M" if i == 0 else "L") + f" {x:.1f} {y:.1f}"
                     for i, (x, y) in enumerate(pts)) + " Z"
        ds = f' stroke-dasharray="{dash}"' if dash else ""
        self.add(f'<path d="{d}" fill="{fill}" stroke="{c}" '
                 f'stroke-width="{w}"{ds} opacity="{opacity}"/>')

    def rect(self, x, y, w, h, c="#000", stroke=None, radius=0):
        s = f' stroke="{stroke}" stroke-width="1"' if stroke else ""
        self.add(f'<rect x="{x:.1f}" y="{y:.1f}" width="{w:.1f}" height="{h:.1f}" '
                 f'rx="{radius}" fill="{c}"{s}/>')

    def circle(self, cx, cy, r, c="#d62728", stroke=None, sw=1):
        s = f' stroke="{stroke}" stroke-width="{sw}"' if stroke else ""
        self.add(f'<circle cx="{cx:.1f}" cy="{cy:.1f}" r="{r}" fill="{c}"{s}/>')

    def text(self, x, y, s, size=11, c="#222", anchor="start",
             weight="normal", rotate=None):
        r = f' transform="rotate({rotate} {x:.1f} {y:.1f})"' if rotate else ""
        self.add(f'<text x="{x:.1f}" y="{y:.1f}" font-family="sans-serif" '
                 f'font-size="{size}" fill="{c}" text-anchor="{anchor}" '
                 f'font-weight="{weight}"{r}>{esc(s)}</text>')

    def save(self, path):
        path.parent.mkdir(parents=True, exist_ok=True)
        defs = ""
        path.write_text(
            f'<svg xmlns="http://www.w3.org/2000/svg" width="{self.w}" '
            f'height="{self.h}" viewBox="0 0 {self.w} {self.h}">\n'
            f'<rect width="{self.w}" height="{self.h}" fill="#fff"/>\n{defs}\n'
            + "\n".join(self.p) + "\n</svg>\n")


def main():
    svg = Svg(1220, 700)

    svg.text(60, 34, "One chirp of the automotive waveform: frequency vs time",
             19, weight="bold")
    svg.text(60, 56,
             f"B {B / 1e9:.2f} GHz, T {T:.0f} ns, fs {FS / 1e9:.2f} GS/s "
             f"({N_RANGE} samples), slope {SLOPE / 1e12:.2f} MHz/us, "
             f"R_nyq {R_NYQ:.1f} m  -  one up-chirp; the next chirp "
             f"mirrors the slope", 11, c="#555")

    # ---------------------------------------------------------------- main
    x0, y0, pw, ph = 110, 100, 760, 400
    active = T - TAU                       # time the echo is actually mixed

    svg.rect(x0, y0, pw, ph, "#fbfbfd", stroke="#dcdcdc")

    def X(t_ns):
        return x0 + t_ns / T * pw

    def Y(f_hz):
        return y0 + ph - f_hz / B * ph

    # grid + ticks
    for i in range(5):
        t = T * i / 4
        svg.line(X(t), y0, X(t), y0 + ph, "#ececf2")
        svg.text(X(t), y0 + ph + 20, f"{t:.0f}", 10, c="#555", anchor="middle")
    for i in range(7):
        f = B * i / 6
        svg.line(x0, Y(f), x0 + pw, Y(f), "#ececf2")
        svg.text(x0 - 8, Y(f) + 4, f"{f / 1e9:.2f}", 10, c="#555", anchor="end")

    svg.line(x0, y0 + ph, x0 + pw, y0 + ph, "#333", 1.4)
    svg.line(x0, y0, x0, y0 + ph, "#333", 1.4)
    svg.text(x0 + pw / 2, y0 + ph + 44, "time within the chirp (ns)", 12,
             anchor="middle", c="#333")
    svg.text(x0, y0 - 12, "beat frequency offset from f0 (GHz)", 12, c="#333")

    # sampled transmit ramp
    svg.poly([(X(0), Y(0)), (X(T), Y(B))], "#1f77b4", 2.6)
    for k in range(0, N_RANGE + 1, 128):
        t = k / N_RANGE * T
        svg.circle(X(t), Y(B * t / T), 2.4, "#1f77b4")

    # delayed echo: f_tx(t - tau)
    svg.poly([(X(TAU), Y(0)), (X(T), Y(B * active / T))], "#e07b00", 2.4,
             dash="7,4")

    # beat region
    svg.poly([(X(TAU), Y(0)), (X(T), Y(B * active / T)),
              (X(T), Y(B)), (X(TAU), Y(B * TAU / T))],
             "#e07b00", 0, fill="#fff1d6", opacity=0.75)

    # beat arrow and delay marker
    t_a = 0.78 * T
    svg.arrow(X(t_a), Y(B * t_a / T), Y(B * (t_a - TAU) / T))
    mid = Y(B * (t_a - TAU / 2) / T)
    svg.add(f'<rect x="{X(t_a) + 10:.1f}" y="{mid - 26:.1f}" width="212" '
            f'height="48" rx="4" fill="#ffffff" fill-opacity="0.9" '
            f'stroke="#f0c9c9"/>')
    svg.text(X(t_a) + 20, mid - 6,
             f"beat f_b = {F_BEAT:.0f} MHz", 12, c="#d62728",
             weight="bold")
    svg.text(X(t_a) + 20, mid + 11,
             f"= slope x 2R/c at R = {R_REF:.0f} m", 10, c="#a33")

    ya = y0 + ph - 34
    svg.line(X(0), ya, X(TAU), ya, "#e07b00", 2)
    svg.line(X(0), ya - 5, X(0), ya + 5, "#e07b00", 1.4)
    svg.line(X(TAU), ya - 5, X(TAU), ya + 5, "#e07b00", 1.4)
    svg.text(X(TAU) - 8, ya + 22,
             f"echo delay 2R/c = {TAU:.0f} ns", 10, c="#b35f00",
             anchor="end")

    # legend
    lx, ly = x0 + 24, y0 + 30
    svg.line(lx, ly, lx + 34, ly, "#1f77b4", 2.6)
    svg.text(lx + 42, ly + 4, "transmit ramp", 11)
    svg.line(lx, ly + 22, lx + 34, ly + 22, "#e07b00", 2.4, dash="7,4")
    svg.text(lx + 42, ly + 26, "received echo (delayed)", 11)
    svg.rect(lx, ly + 36, 34, 10, "#fff1d6", stroke="#e07b00")
    svg.text(lx + 42, ly + 45, "mixed beat tone", 11)

    # ------------------------------------------------------- beat spectrum
    sx, sy, sw, sh = 110, 582, 760, 56
    svg.text(sx, sy - 24,
             "Where that beat lands in the 0..fs beat band (complex sampling)",
             13, weight="bold")
    svg.rect(sx, sy, sw, sh, "#f7f7fa", stroke="#dcdcdc")
    for i in range(6):
        f = FS * i / 5
        svg.line(sx + sw * i / 5, sy, sx + sw * i / 5, sy + sh, "#e6e6ee")
        svg.text(sx + sw * i / 5, sy + sh + 16, f"{f / 1e6:.0f}", 10,
                 c="#555", anchor="middle")
    svg.text(sx + sw / 2, sy + sh + 34, "beat frequency (MHz)", 11,
             anchor="middle", c="#333")

    # Doppler spread around the 100 m beat
    def FX(f_mhz):
        return sx + sw * f_mhz / (FS * 1e-6)

    svg.rect(FX(F_BEAT - F_DOP), sy, FX(F_BEAT + F_DOP) - FX(F_BEAT - F_DOP),
             sh, "#ffe0e0", stroke="#d62728")

    for r_m in (20.0, 50.0):
        fb = SLOPE * (2.0 * r_m / C) * 1e-6
        svg.line(FX(fb), sy - 4, FX(fb), sy + sh + 4, "#1f77b4", 2)
        svg.text(FX(fb), sy - 8, f"{r_m:.0f} m", 10, c="#1f77b4",
                 anchor="middle")

    # the 100 m beat, and the +/- f_D spread of a 30 m/s target around it
    svg.line(FX(F_BEAT), sy + 4, FX(F_BEAT), sy + sh - 4, "#d62728", 1.2,
             dash="3,3")
    svg.text(FX(F_BEAT - F_DOP) - 8, sy + sh / 2 + 4,
             f"100 m, {V_REF:.0f} m/s: {F_BEAT - F_DOP:.0f}-{F_BEAT + F_DOP:.0f}"
             f" MHz", 10, c="#a33", anchor="end", weight="bold")

    svg.line(FX(FS * 1e-6), sy - 4, FX(FS * 1e-6), sy + sh + 4, "#888", 1.4,
             dash="3,3")
    svg.text(FX(FS * 1e-6) - 4, sy - 8, "fs", 10, c="#888", anchor="end")

    out = OUT / "waveform_chirp.svg"
    svg.save(out)
    subprocess.run(["convert", str(out), str(out.with_suffix(".png"))],
                   check=False, stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL)

    print(f"B {B / 1e9:.3f} GHz  T {T:.1f} ns  slope {SLOPE / 1e12:.3f} MHz/us")
    print(f"fs {FS / 1e9:.3f} GS/s  band 0..{FS / 1e6:.0f} MHz  "
          f"R_nyq {R_NYQ:.1f} m")
    print(f"tau(100 m) {TAU:.1f} ns  f_beat {F_BEAT:.1f} MHz  "
          f"f_doppler(30 m/s) {F_DOP:.1f} MHz")
    print(f"up-chirp beat {F_BEAT - F_DOP:.1f} MHz, "
          f"down-chirp beat {F_BEAT + F_DOP:.1f} MHz")
    print(f"wrote {out.with_suffix('.png')}")


if __name__ == "__main__":
    main()

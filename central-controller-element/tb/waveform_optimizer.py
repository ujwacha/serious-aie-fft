#!/usr/bin/env python3
"""Waveform optimiser for the 1153 nm FMCW lidar.

The range FFT is fixed at N_RANGE = 2048 points and the Doppler FFT at
N_CHIRPS = 256, so the free waveform parameters are the sweep bandwidth B and
the sample rate fs (which fixes the chirp time T = N_RANGE / fs).

Two velocity estimators are compared:

  slow   the current chain: Doppler phase from chirp to chirp.
         v_unamb = lambda / (4 T) = lambda fs / (4 N_RANGE)

  dual   automotive FMCW: alternate up/down chirps and take the Doppler shift
         of the beat itself.
         f_up = f_R - f_D,  f_down = f_R + f_D
         v_unamb(R) = lambda/4 * min(f_R, fs - f_R)
                    = lambda fs/4 * min(r, 1 - r),  r = R / R_nyq

`hybrid` uses the dual estimate to unwrap the fine slow-time phase, so the
velocity *span* is the dual envelope while the resolution stays
lambda / (2 CPI).

Constraints: R_nyq >= 100 m, v(R_ref) >= 30 m/s, bandwidth <= B_laser,
fs <= fs_max.  The script prints the Pareto front, the best design, and the
bandwidth / chirp time that the current chain would need for 30 m/s.

    ./waveform_optimizer.py
    ./waveform_optimizer.py --max-range 100 --target-v 30 --range-res 0.06
"""

from __future__ import annotations

import argparse
import math
from pathlib import Path

C = 299792458.0
LAM = 1153e-9
N_RANGE = 2048
N_CHIRPS = 256
G = 1e9
PLOTS = Path(__file__).resolve().parent / "work" / "plots"


# ---------------------------------------------------------------------------
# waveform equations
# ---------------------------------------------------------------------------
def r_nyq(bw):
    """Max unambiguous range: the beat fills all N_RANGE bins at fs."""
    return N_RANGE * C / (2.0 * bw)


def range_res(bw):
    return C / (2.0 * bw)


def chirp_time(fs):
    return N_RANGE / fs


def v_slow(fs):
    """Chirp-to-chirp unambiguous velocity (the current chain)."""
    return LAM * fs / (4.0 * N_RANGE)


def dv_slow(fs):
    """Slow-time velocity resolution, CPI = N_CHIRPS * T."""
    return LAM / (2.0 * N_CHIRPS * chirp_time(fs))


def v_dual_peak(fs):
    """Dual-slope peak velocity, reached at half the Nyquist range."""
    return LAM * fs / 4.0


def v_dual_at(fs, r):
    """Dual-slope velocity envelope at range r = R / R_nyq."""
    return LAM * fs / 2.0 * min(r, 1.0 - r)


def b_for_dual(fs, r_ref, v_target, r_min):
    """Largest B such that v_dual(R_ref) >= v_target and R_nyq >= R_min.

    x = R_ref / R_nyq must satisfy q <= x <= 1-q with q = 4 v / (lambda fs).
    The largest bandwidth uses x = 1-q.
    """
    q = 2.0 * v_target / (LAM * fs)
    if q >= 0.5:
        return None
    b_cap = N_RANGE * C / (2.0 * r_min)
    b_v = N_RANGE * C * (1.0 - q) / (2.0 * r_ref)
    return min(b_cap, b_v)


def dv_hybrid(fs):
    """Fine resolution from the slow-time phase, unwrapped by dual."""
    return dv_slow(fs)


def dv_dual_cpi(fs):
    """Coarse velocity resolution of the dual estimate over one CPI."""
    return LAM / (2.0 * chirp_time(fs)) / math.sqrt(N_CHIRPS / 2.0)


# ---------------------------------------------------------------------------
def optimise(args):
    r_ref = args.max_range
    rows = []

    # ---- dual / hybrid: for each fs, the largest B that meets v(R_ref) ----
    fs = args.fs_min
    while fs <= args.fs_max + 1.0:
        b = b_for_dual(fs, r_ref, args.target_v, args.max_range)
        if b is not None:
            b = min(b, args.max_bw)
            rn = r_nyq(b)
            if rn >= args.max_range:
                rows.append({
                    "fs": fs,
                    "B": b,
                    "T": chirp_time(fs),
                    "Rnyq": rn,
                    "dR": range_res(b),
                    "v_ref": v_dual_at(fs, r_ref / rn),
                    "v_peak": v_dual_peak(fs),
                    "dv_hybrid": dv_hybrid(fs),
                })
        fs *= 1.05

    # ---- slow mode: B is chosen for the range resolution, v is fs only ----
    slow_b = C / (2.0 * args.range_res) if args.range_res else N_RANGE * C / (
        2.0 * args.max_range)
    slow_b = min(slow_b, args.max_bw)

    return rows, slow_b


def print_report(args, rows, slow_b):
    print("=" * 78)
    print("1153 nm FMCW lidar waveform design")
    print("=" * 78)
    print(f"  N_range {N_RANGE}, N_chirps {N_CHIRPS}, "
          f"lambda {LAM * 1e9:.0f} nm")
    print(f"  constraints: R_nyq >= {args.max_range:.0f} m, "
          f"v({args.max_range:.0f} m) >= {args.target_v:.0f} m/s, "
          f"B <= {args.max_bw / G:.2f} GHz, fs <= {args.fs_max / G:.1f} GS/s")

    print("\n-- current chain (slow-time phase) -------------------------------")
    fs_need = 4.0 * N_RANGE * args.target_v / LAM
    t_need = chirp_time(fs_need)
    print(f"  v_unamb = lambda fs / (4 N)     -> fs = {fs_need / G:.1f} GS/s "
          f"(T = {t_need * 1e9:.2f} ns) for {args.target_v:.0f} m/s")
    print(f"  at the {args.fs_max / G:.1f} GS/s ADC limit: "
          f"T = {chirp_time(args.fs_max) * 1e9:.1f} ns, "
          f"v_unamb = {v_slow(args.fs_max):.3f} m/s")
    print(f"  bandwidth has no effect on this number; raising B from 1.0 to "
          f"{slow_b / G:.2f} GHz only improves dR "
          f"({range_res(1 * G) * 100:.2f} -> {range_res(slow_b) * 100:.2f} cm)")
    for fs in (1 * G, 2 * G, 5 * G, 10 * G):
        print(f"    fs {fs / G:5.1f} GS/s  T {chirp_time(fs) * 1e9:7.1f} ns  "
              f"v_unamb {v_slow(fs):6.3f} m/s  dv {dv_slow(fs) * 1e3:6.2f} mm/s")
    print("  verdict: not automotive, and lengthening T makes it worse.")

    print("\n-- dual-slope / hybrid -------------------------------------------")
    print("  the beat shift carries f_D = 2v/lambda, so the span is not set")
    print("  by T.  Table: largest B that still allows the target velocity")
    print("  at R_ref, for each ADC rate.")
    print()
    print(f"  {'fs GS/s':>8} {'B GHz':>7} {'T ns':>8} {'Rnyq m':>7} "
          f"{'dR cm':>6} {'v_ref':>7} {'v_peak':>7} {'dv mm/s':>8}")
    for want in (0.25, 0.5, 1.0, 2.0, 4.0, 8.0, 10.0):
        cand = [r for r in rows if r["fs"] <= want * G + 1e-9]
        if not cand:
            continue
        r = cand[-1]
        print(f"  {r['fs'] / G:8.2f} {r['B'] / G:7.2f} {r['T'] * 1e9:8.1f} "
              f"{r['Rnyq']:7.1f} {r['dR'] * 100:6.2f} {r['v_ref']:7.1f} "
              f"{r['v_peak']:7.1f} {r['dv_hybrid'] * 1e3:8.2f}")

    # smallest fs that meets the range-resolution target
    feasible = [r for r in rows if r["dR"] <= args.range_res + 1e-12]
    best_min = feasible[0] if feasible else (rows[-1] if rows else None)
    # practical point: closest to the preferred ADC rate
    best = min(feasible or rows,
               key=lambda r: abs(r["fs"] / G - args.prefer_fs)) if rows else None
    if best_min:
        print(f"\n  minimum ADC for dR <= {args.range_res * 100:.1f} cm: "
              f"{best_min['fs'] / G:.2f} GS/s, B {best_min['B'] / G:.2f} GHz, "
              f"T {best_min['T'] * 1e9:.0f} ns")

    if best:
        print("\n-- recommended design --------------------------------------------")
        print(f"  bandwidth B      : {best['B'] / G:.3f} GHz  "
              f"(range resolution {best['dR'] * 100:.2f} cm)")
        print(f"  sample rate fs   : {best['fs'] / G:.3f} GS/s")
        print(f"  chirp time T     : {best['T'] * 1e9:.1f} ns")
        print(f"  Nyquist range    : {best['Rnyq']:.1f} m")
        print(f"  v at {args.max_range:.0f} m        : {best['v_ref']:.1f} m/s")
        print(f"  peak v (Rnyq/2)  : {best['v_peak']:.1f} m/s")
        print(f"  fine dv (hybrid) : {best['dv_hybrid'] * 1e3:.3f} mm/s")
        print(f"  coarse dv / pair : {LAM / (2.0 * best['T']) * 1e3:.1f} mm/s")
        print(f"  coarse dv / CPI  : {dv_dual_cpi(best['fs']) * 1e3:.2f} mm/s")
        print(f"  slow-time span   : +/-{v_slow(best['fs']):.3f} m/s "
              f"(ambiguous, only used for fine dv)")
        print(f"  range-Doppler coupling at {args.target_v:.0f} m/s: "
              f"{args.target_v * best['T'] * C / (best['B'] * LAM):.2f} m")
    return best


# ---------------------------------------------------------------------------
# tiny SVG plotter (no matplotlib in this environment)
# ---------------------------------------------------------------------------
def esc(s):
    return str(s).replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


class Svg:
    def __init__(self, w, h):
        self.w, self.h, self.p = w, h, []

    def add(self, s):
        self.p.append(s)

    def line(self, x1, y1, x2, y2, c="#333", w=1, dash=None):
        d = f' stroke-dasharray="{dash}"' if dash else ""
        self.add(f'<line x1="{x1:.1f}" y1="{y1:.1f}" x2="{x2:.1f}" '
                 f'y2="{y2:.1f}" stroke="{c}" stroke-width="{w}"{d}/>')

    def poly(self, pts, c="#1f77b4", w=2):
        d = " ".join(f"{x:.1f},{y:.1f}" for x, y in pts)
        self.add(f'<polyline points="{d}" fill="none" stroke="{c}" '
                 f'stroke-width="{w}"/>')

    def circle(self, cx, cy, r, c="#d62728"):
        self.add(f'<circle cx="{cx:.1f}" cy="{cy:.1f}" r="{r}" fill="{c}"/>')

    def text(self, x, y, s, size=11, c="#222", anchor="start", weight="normal"):
        self.add(f'<text x="{x:.1f}" y="{y:.1f}" font-family="sans-serif" '
                 f'font-size="{size}" fill="{c}" text-anchor="{anchor}" '
                 f'font-weight="{weight}">{esc(s)}</text>')

    def save(self, path):
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(
            f'<svg xmlns="http://www.w3.org/2000/svg" width="{self.w}" '
            f'height="{self.h}" viewBox="0 0 {self.w} {self.h}">\n'
            f'<rect width="{self.w}" height="{self.h}" fill="#fff"/>\n'
            + "\n".join(self.p) + "\n</svg>\n")


def axes(svg, x, y, w, h, xr, yr, xlabel, ylabel, title):
    svg.text(x, y - 26, title, 14, weight="bold")
    svg.line(x, y + h, x + w, y + h)
    svg.line(x, y, x, y + h)
    for i in range(5):
        fx = i / 4
        px = x + fx * w
        svg.line(px, y + h, px, y + h + 4)
        vx = xr[0] + fx * (xr[1] - xr[0])
        svg.text(px, y + h + 16, f"{vx:.1f}", 10, anchor="middle")
        fy = i / 4
        py = y + h - fy * h
        svg.line(x - 4, py, x, py)
        vy = yr[0] + fy * (yr[1] - yr[0])
        svg.text(x - 7, py + 4, f"{vy:.1f}", 10, anchor="end")
    svg.text(x + w / 2, y + h + 34, xlabel, 11, anchor="middle")
    svg.text(x - 44, y + h / 2, ylabel, 11, anchor="middle")
    # rotate ylabel
    last = svg.p[-1]
    svg.p[-1] = last.replace(
        f'x="{x - 44:.1f}" y="{y + h / 2:.1f}"',
        f'x="{x - 44:.1f}" y="{y + h / 2:.1f}" '
        f'transform="rotate(-90 {x - 44:.1f} {y + h / 2:.1f})"')


def plot(args, rows, slow_b, best):
    if not rows:
        return
    W, H = 1560, 520
    svg = Svg(W, H)
    svg.text(28, 28, "1153 nm FMCW lidar: waveform trade-offs", 18,
             weight="bold")
    svg.text(28, 48, f"N_range {N_RANGE}, N_chirps {N_CHIRPS}, "
             f"target {args.target_v:.0f} m/s at {args.max_range:.0f} m, "
             f"R_nyq >= {args.max_range:.0f} m", 11, c="#555")

    # ---- panel 1: dR vs fs ----
    x0, y0, pw, ph = 70, 90, 420, 340
    fs_pts = [(r["fs"] / G, r["dR"] * 100) for r in rows]
    max_dr = max(p[1] for p in fs_pts)
    axes(svg, x0, y0, pw, ph, (0, args.fs_max / G), (0, math.ceil(max_dr)),
         "ADC rate fs (GS/s)", "range resolution dR (cm)",
         "Pareto: bandwidth vs ADC rate")
    pts = [(x0 + (fs - 0) / (args.fs_max / G) * pw,
            y0 + ph - (dr - 0) / (math.ceil(max_dr)) * ph)
           for fs, dr in fs_pts]
    svg.poly(pts)
    if best:
        bx = x0 + best["fs"] / G / (args.fs_max / G) * pw
        by = y0 + ph - best["dR"] * 100 / math.ceil(max_dr) * ph
        svg.circle(bx, by, 5)
        svg.text(bx + 9, by - 8,
                 f"{best['fs'] / G:.2f} GS/s, {best['dR'] * 100:.2f} cm",
                 10)
    # 5 cm reference
    y5 = y0 + ph - 5.0 / math.ceil(max_dr) * ph
    if 0 <= y5 <= y0 + ph:
        svg.line(x0, y5, x0 + pw, y5, "#999", 1, "4,4")
        svg.text(x0 + pw - 4, y5 - 4, "5 cm", 10, c="#777", anchor="end")

    # ---- panel 2: velocity envelope vs range ----
    x0, y0, pw, ph = 570, 90, 420, 340
    vmax_plot = max(best["v_peak"] if best else 600, 60)
    axes(svg, x0, y0, pw, ph, (0, args.max_range),
         (0, math.ceil(vmax_plot / 50) * 50),
         "range (m)", "|v| unamb (m/s)",
         "Range-velocity envelope (hybrid)")
    if best:
        env = []
        for i in range(101):
            r = args.max_range * i / 100
            x = r / best["Rnyq"]
            v = 2.0 * best["v_peak"] * min(x, 1 - x)
            env.append((x0 + r / args.max_range * pw,
                        y0 + ph - v / (math.ceil(vmax_plot / 50) * 50) * ph))
        svg.poly(env, "#1f77b4", 2)
        # slow-time rectangle
        vs = v_slow(best["fs"])
        ys = y0 + ph - vs / (math.ceil(vmax_plot / 50) * 50) * ph
        svg.line(x0, ys, x0 + pw, ys, "#d62728", 1.5, "5,3")
        svg.text(x0 + 6, ys - 6, f"slow-time +/-{vs:.3f} m/s", 10,
                 c="#d62728")
        svg.text(x0 + pw - 6, y0 + 14,
                 f"B {best['B'] / G:.2f} GHz, fs {best['fs'] / G:.2f} GS/s",
                 10, c="#555", anchor="end")

    # ---- panel 3: ADC rate needed by the current chain ----
    x0, y0, pw, ph = 1070, 90, 420, 340
    axes(svg, x0, y0, pw, ph, (0, args.target_v),
         (0, 40), "target unamb velocity (m/s)", "ADC rate (GS/s)",
         "Slow-time chain: ADC rate for a given span")
    pts = []
    for i in range(101):
        v = args.target_v * i / 100
        fsr = 4.0 * N_RANGE * v / LAM / G
        pts.append((x0 + v / args.target_v * pw,
                    y0 + ph - min(fsr, 40) / 40 * ph))
    svg.poly(pts, "#d62728", 2)
    ylim = y0 + ph - args.fs_max / G / 40 * ph
    svg.line(x0, ylim, x0 + pw, ylim, "#999", 1, "4,4")
    svg.text(x0 + 6, ylim - 5, f"{args.fs_max / G:.1f} GS/s cap", 10, c="#777")
    svg.text(x0 + pw - 6, y0 + 14,
             f"needs {4 * N_RANGE * args.target_v / LAM / G:.0f} GS/s "
             f"for {args.target_v:.0f} m/s", 10, c="#d62728", anchor="end")

    PLOTS.mkdir(parents=True, exist_ok=True)
    sp = PLOTS / "waveform_tradeoffs.svg"
    svg.save(sp)
    import subprocess
    subprocess.run(["convert", str(sp), str(sp.with_suffix(".png"))],
                   check=False, stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL)
    print(f"\nwrote {sp.with_suffix('.png')}")


# ---------------------------------------------------------------------------
def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--max-range", type=float, default=100.0,
                    help="required unambiguous range (m)")
    ap.add_argument("--target-v", type=float, default=30.0,
                    help="required unambiguous velocity at max range (m/s)")
    ap.add_argument("--range-res", type=float, default=0.06,
                    help="target range resolution (m)")
    ap.add_argument("--max-bw", type=float, default=4.0 * G,
                    help="laser bandwidth limit (Hz)")
    ap.add_argument("--fs-min", type=float, default=0.25 * G)
    ap.add_argument("--fs-max", type=float, default=10.0 * G)
    ap.add_argument("--prefer-fs", type=float, default=1.0,
                    help="practical ADC rate for the recommended point (GS/s)")
    args = ap.parse_args()

    rows, slow_b = optimise(args)
    best = print_report(args, rows, slow_b)
    plot(args, rows, slow_b, best)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

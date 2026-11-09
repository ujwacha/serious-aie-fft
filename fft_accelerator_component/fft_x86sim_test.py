#!/usr/bin/env python3
"""Generate IQ test vectors, run the AIE FFT in x86sim, and compare.

The FFT size and shift are read from src/graph.h, so changing
TP_POINT_SIZE / TP_SHIFT there is enough. The current test supports
TP_PARALLEL_POWER=0 and TP_WINDOW_VSIZE=TP_POINT_SIZE.

It writes:

    data/temp_input0.txt   (two ints per line: I Q)
    data/input.txt          (copy, only to satisfy x86sim.sh)

and reads:

    build/x86sim/x86simulator_output/data/temp_output0.txt

Only the Python standard library is used.
"""

from __future__ import annotations

import argparse
import cmath
import math
import os
import re
import shutil
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parent
COMPONENT = ROOT
DATA = COMPONENT / "data"
GRAPH = COMPONENT / "src/graph.h"
OUTPUT = COMPONENT / "build/x86sim/x86simulator_output/data/temp_output0.txt"


def read_graph_params() -> tuple[int, int]:
    """Read TP_POINT_SIZE and TP_SHIFT from graph.h."""
    text = GRAPH.read_text()
    # Strip C/C++ comments so the template arguments can be parsed simply.
    text = re.sub(r"//[^\n]*", "", text)
    text = re.sub(r"/\*.*?\*/", "", text, flags=re.S)
    pattern = (
        r"dsp::fft_ifft_dit_1ch_graph<\s*cint16\s*,\s*cint16\s*,\s*"
        r"(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)"
    )
    match = re.search(pattern, text, re.S)
    if not match:
        raise SystemExit(f"could not parse FFT parameters from {GRAPH}")
    point, _nifft, shift, _casc, _dyn, window, _api, parallel = map(int, match.groups())
    if parallel != 0:
        raise SystemExit(
            f"this test only supports TP_PARALLEL_POWER=0, found {parallel}"
        )
    if window != point:
        raise SystemExit(
            f"this test expects TP_WINDOW_VSIZE == TP_POINT_SIZE, found {window} != {point}"
        )
    return point, shift


N, FFT_SHIFT = read_graph_params()


def fft(a: list[complex]) -> list[complex]:
    """Iterative radix-2 FFT, natural-order input and output."""
    a = [complex(v) for v in a]
    n = len(a)
    j = 0
    for i in range(1, n):
        bit = n >> 1
        while j & bit:
            j ^= bit
            bit >>= 1
        j ^= bit
        if i < j:
            a[i], a[j] = a[j], a[i]

    length = 2
    while length <= n:
        ang = -2.0 * math.pi / length
        wlen = complex(math.cos(ang), math.sin(ang))
        half = length // 2
        for start in range(0, n, length):
            w = 1.0 + 0.0j
            for k in range(start, start + half):
                u = a[k]
                v = a[k + half] * w
                a[k] = u + v
                a[k + half] = u - v
                w *= wlen
        length <<= 1
    return a


def make_case(name: str) -> tuple[list[complex], list[int]]:
    """Return quantized cint16 IQ samples and expected peak bins."""
    n_range = range(N)
    if name == "tones":
        # Three complex tones at exact FFT bins, scaled to the FFT size.
        bins = [max(1, min(N - 1, int(round(f * N)))) for f in (0.036, 0.195, 0.685)]
        tones = [(bins[0], 12000.0, 0.0), (bins[1], 8000.0, math.pi / 3), (bins[2], 5000.0, -math.pi / 4)]
        x = [
            sum(amp * cmath.exp(1j * (2.0 * math.pi * k * i / N + phase)) for k, amp, phase in tones)
            for i in n_range
        ]
        peaks = bins
    elif name == "real_tone":
        # Real cosine: conjugate peaks at bin k and N-k.
        amp, k, phase = 10000.0, max(1, N * 300 // 1024), 0.3
        x = [amp * cmath.exp(1j * (2.0 * math.pi * k * i / N + phase)) for i in n_range]
        x = [(v + v.conjugate()).real / 2.0 for v in x]
        peaks = [k, N - k]
    elif name == "chirp":
        # Complex baseband chirp sweeping bin 20 -> 400 for N=1024.
        amp = 12000.0
        f0, f1 = N * 20.0 / 1024.0, N * 400.0 / 1024.0
        x = []
        for i in n_range:
            phase = 2.0 * math.pi / N * (f0 * i + 0.5 * (f1 - f0) * i * i / (N - 1))
            x.append(amp * cmath.exp(1j * phase))
        peaks = []
    else:
        raise ValueError(f"unknown case {name!r}")

    # Quantize exactly as the cint16 PLIO input.
    xq = []
    for v in x:
        re = max(-32768, min(32767, int(round(v.real))))
        im = max(-32768, min(32767, int(round(v.imag))))
        xq.append(complex(re, im))
    return xq, peaks


def write_input(x: list[complex]) -> None:
    DATA.mkdir(parents=True, exist_ok=True)
    path = DATA / "temp_input0.txt"
    with path.open("w") as f:
        for v in x:
            f.write(f"{int(v.real)} {int(v.imag)}\n")
    # x86sim.sh's run mode checks for data/input.txt; the graph uses
    # temp_input0.txt.
    shutil.copyfile(path, DATA / "input.txt")
    print(f"wrote {path} ({len(x)} cint16 samples)")


def read_input() -> list[complex]:
    path = DATA / "temp_input0.txt"
    if not path.exists():
        raise SystemExit(f"missing input: {path}")
    x = []
    for line in path.read_text().splitlines():
        fields = line.split()
        if fields:
            x.append(complex(int(fields[0]), int(fields[1])))
    if len(x) != N:
        raise SystemExit(f"expected {N} input samples, got {len(x)}; regenerate the test input")
    return x


def read_output() -> list[complex]:
    if not OUTPUT.exists():
        raise SystemExit(f"missing output: {OUTPUT}\nrun the simulation first")
    y = []
    for line in OUTPUT.read_text().splitlines():
        fields = line.split()
        if fields:
            y.append(complex(int(fields[0]), int(fields[1])))
    return y


def run_sim() -> None:
    print("running x86sim...")
    env = os.environ.copy()
    # Let x86sim.sh run the simulator but not its own FFT test; this script
    # performs the comparison below.
    env["FFT_TEST"] = "0"
    subprocess.run([str(ROOT / "x86sim.sh"), "run"], cwd=ROOT, env=env, check=True)


def report(name: str, x: list[complex], y: list[complex], peaks: list[int]) -> bool:
    expected = [v / (1 << FFT_SHIFT) for v in fft(x)]
    errors = [abs(y[k] - expected[k]) for k in range(N)]
    max_err = max(errors)
    rms_err = math.sqrt(sum(e * e for e in errors) / N)
    corr_num = sum(y[k] * expected[k].conjugate() for k in range(N))
    corr_den = math.sqrt(
        sum(abs(y[k]) ** 2 for k in range(N)) * sum(abs(expected[k]) ** 2 for k in range(N))
    )
    corr = abs(corr_num) / corr_den if corr_den else 0.0

    print(f"\ncase: {name}  (N={N}, shift={FFT_SHIFT})")
    print(f"  max |error| : {max_err:.3f}")
    print(f"  rms |error| : {rms_err:.3f}")
    print(f"  correlation : {corr:.9f}")

    if peaks:
        print("  expected peaks:")
        for k in peaks:
            got = y[k]
            exp = expected[k]
            print(
                f"    bin {k:5d}: got {abs(got):9.3f} @ {math.degrees(cmath.phase(got)):8.2f} deg, "
                f"expected {abs(exp):9.3f} @ {math.degrees(cmath.phase(exp)):8.2f} deg"
            )

    top = sorted(range(N), key=lambda k: abs(y[k]), reverse=True)[:5]
    print("  top output bins:")
    for k in top:
        print(f"    {k:5d}: {abs(y[k]):9.3f}")

    ok = corr > 0.999 and max_err < 5.0
    print("  result:", "PASS" if ok else "FAIL")
    return ok


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--case", choices=["tones", "real_tone", "chirp"], default="tones"
    )
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--generate-only", "--no-run", action="store_true", help="only generate the input")
    mode.add_argument("--check-only", action="store_true", help="compare the existing output")
    args = parser.parse_args()

    if args.check_only:
        _, peaks = make_case(args.case)
        x = read_input()
        y = read_output()
        if len(y) != N:
            raise SystemExit(f"expected {N} output samples, got {len(y)}")
        return 0 if report(args.case, x, y, peaks) else 1

    x, peaks = make_case(args.case)
    write_input(x)
    if args.generate_only:
        return 0

    run_sim()
    y = read_output()
    if len(y) != N:
        raise SystemExit(f"expected {N} output samples, got {len(y)}")
    return 0 if report(args.case, x, y, peaks) else 1


if __name__ == "__main__":
    raise SystemExit(main())

#!/usr/bin/env python3
"""Optional cross-check of the AIE 256-point Doppler FFT.

The main csim test models the 256-point FFT in Python (float FFT, then cint16
quantisation) because an HLS C simulation cannot run an AIE graph in the middle
of a kernel call.  This script closes that gap: it takes one frame of the
already Doppler-windowed data, runs it through the real AIE 256-point FFT
graph in fft_accelerator_component, and compares the cint16 output with the
same Python model.

    ./doppler_aie_check.py              # strongest Doppler frame
    ./doppler_aie_check.py --frame 16   # a specific frame
"""

from __future__ import annotations

import argparse
import cmath
import math
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import rd_test as _rd  # noqa: E402

ROOT = HERE.parent.parent
WORK = HERE / "work"
AIE = ROOT / "fft_accelerator_component"
BUILD = AIE / "build" / "x86sim"
SIMOUT = BUILD / "x86simulator_output" / "data"
SETTINGS = Path.home() / "FPGA/2026.1/Vitis/settings64.sh"

N = 256
SHIFT = _rd.SHIFT_DOPPLER


def read_iq(path: Path) -> list[complex]:
    if not path.exists():
        raise SystemExit(f"missing {path}; run tb/run_test.sh first")
    out = []
    for line in path.read_text().splitlines():
        f = line.split()
        if f:
            out.append(complex(int(f[0]), int(f[1])))
    return out


def write_iq(path: Path, values: list[complex]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w") as stream:
        for v in values:
            stream.write(f"{int(v.real)} {int(v.imag)}\n")


def fft(values: list[complex]) -> list[complex]:
    a = [complex(v) for v in values]
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
        half = length // 2
        wlen = cmath.exp(-2j * math.pi / length)
        for start in range(0, n, length):
            w = 1 + 0j
            for k in range(start, start + half):
                u = a[k]
                v = a[k + half] * w
                a[k] = u + v
                a[k + half] = u - v
                w *= wlen
        length *= 2
    return a


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--frame", type=int, default=None,
                    help="Doppler frame index (16 per active range block); "
                         "default: the frame with the most energy")
    args = ap.parse_args()

    even = read_iq(WORK / "dop_win0.txt")
    odd = read_iq(WORK / "dop_win1.txt")
    frames = len(even) // (N // 2)
    if frames == 0:
        raise SystemExit("no Doppler frames: run tb/run_test.sh first")
    if args.frame is None:
        # Low-energy frames quantise to a handful of counts and their FFT is
        # dominated by integer rounding, which makes a correlation check
        # meaningless.  Pick the frame with the most energy by default.
        energy = []
        for fr in range(frames):
            b = fr * (N // 2)
            energy.append(sum(abs(v) ** 2 for v in even[b:b + N // 2]) +
                          sum(abs(v) ** 2 for v in odd[b:b + N // 2]))
        args.frame = max(range(frames), key=lambda f: energy[f])
    if args.frame < 0 or args.frame >= frames:
        raise SystemExit(f"--frame must be in 0..{frames - 1}")
    base = args.frame * (N // 2)
    win_even = even[base:base + N // 2]
    win_odd = odd[base:base + N // 2]
    x = []
    for i in range(N // 2):
        x.extend((win_even[i], win_odd[i]))

    if not BUILD.exists():
        raise SystemExit(f"missing AIE build: {BUILD}")

    # The graph has three FFTs.  Feed zeros to the 2048- and 128-point ones so
    # the simulator can run the 256-point FFT in the same graph.
    write_iq(AIE / "data/temp_input0.txt", [0j] * 1024)
    write_iq(AIE / "data/temp_input1.txt", [0j] * 1024)
    write_iq(AIE / "data/temp_input2.txt", win_even)
    write_iq(AIE / "data/temp_input3.txt", win_odd)
    write_iq(AIE / "data/temp_input4.txt", [0j] * 64)
    write_iq(AIE / "data/temp_input5.txt", [0j] * 64)

    cmd = (f"source '{SETTINGS}' >/dev/null 2>&1; cd '{BUILD}' && "
           f"x86simulator --pkg-dir=./Work --i=../../")
    print(f"running AIE 256-point FFT (frame {args.frame}, "
          f"peak |x| = {max(abs(v) for v in x):.0f}) ...")
    result = subprocess.run(["bash", "-lc", cmd], text=True,
                            stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    if result.returncode:
        print(result.stdout[-4000:], file=sys.stderr)
        raise SystemExit(f"x86simulator exited with {result.returncode}")

    got0 = read_iq(SIMOUT / "temp_output2.txt")
    got1 = read_iq(SIMOUT / "temp_output3.txt")
    if len(got0) != N // 2 or len(got1) != N // 2:
        raise SystemExit(f"bad AIE output length {len(got0)}/{len(got1)}")
    got = []
    for i in range(N // 2):
        got.extend((got0[i], got1[i]))

    exp = [v / float(1 << SHIFT) for v in fft(x)]
    errors = [abs(got[k] - exp[k]) for k in range(N)]
    max_err = max(errors)
    rms_err = math.sqrt(sum(e * e for e in errors) / N)
    corr_num = sum(got[k] * exp[k].conjugate() for k in range(N))
    corr_den = math.sqrt(sum(abs(v) ** 2 for v in got) *
                         sum(abs(v) ** 2 for v in exp))
    corr = abs(corr_num) / corr_den if corr_den else 0.0

    print(f"  max |error| : {max_err:.3f}")
    print(f"  rms |error| : {rms_err:.3f}")
    print(f"  correlation : {corr:.9f}")
    ok = corr > 0.999 and max_err < 5.0
    print(f"  RESULT: {'PASS' if ok else 'FAIL'}")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())

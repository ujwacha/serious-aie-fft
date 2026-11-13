#!/usr/bin/env python3
"""Measure how much raw ADC data the range AIE threshold masks out.

Feeds the exact HLS-windowed ADC frame (Python model, verified to match the
HLS window pass bit for bit) into the real 2048-point AIE range graph, then
reads the per-chirp 128-bit keep mask out of the AIE output stream.

No project source is modified: only tb/work/*.txt is written.

    ./range_mask.py                 # rd, sparse, dense
    ./range_mask.py moving          # one scene
"""

from __future__ import annotations

import subprocess
import sys
from pathlib import Path

TB = Path(__file__).resolve().parent
ROOT = TB.parent.parent
WORK = TB / "work"
sys.path.insert(0, str(TB))
import rd_test as R  # noqa: E402

N_RANGE = 2048
BLOCK = 16
CHIRPS = 256


def write_iq(path: Path, values):
    with path.open("w") as stream:
        for v in values:
            stream.write(f"{int(v.real)} {int(v.imag)}\n")


def build_windowed(scene: str):
    subprocess.run(
        [sys.executable, str(TB / "rd_test.py"), "--generate",
         "--scene", scene, "--chirps", str(CHIRPS)],
        check=True, cwd=str(TB))
    adc = R.read_iq(WORK / "adc.txt")
    win = R.load_window(N_RANGE)
    out = {0: [], 1: []}
    for c in range(CHIRPS):
        frame = adc[c * N_RANGE:(c + 1) * N_RANGE]
        w = R.apply_window(frame, win)
        out[0].extend(w[0::2])
        out[1].extend(w[1::2])
    write_iq(WORK / "windowed0.txt", out[0])
    write_iq(WORK / "windowed1.txt", out[1])


def run_aie():
    subprocess.run(["bash", str(TB / "run_aie.sh"), str(CHIRPS)],
                   check=True, cwd=str(TB))


def read_masks():
    """Per-chirp keep flags, parsed the same way the HLS TB parses them."""
    out0 = R.read_iq(WORK / "aie0.txt")
    masks = []
    o0 = 0
    for c in range(CHIRPS):
        if o0 + 64 > len(out0):
            raise SystemExit(f"aie0 truncated at chirp {c}")
        flags = []
        for word in out0[o0:o0 + 64]:
            flags.append(word.real != 0)
            flags.append(word.imag != 0)
        masks.append(flags)
        kept = sum(flags)
        o0 += 64 + ((kept + 1) // 2) * BLOCK
    return masks


def pct(a, b):
    return 100.0 * a / b


def report(scene: str, masks):
    per_chirp = [sum(m) for m in masks]
    anded = [True] * 128
    orred = [False] * 128
    for m in masks:
        anded = [a and b for a, b in zip(anded, m)]
        orred = [a or b for a, b in zip(orred, m)]
    n_and = sum(anded)

    raw_samples = N_RANGE * CHIRPS
    kept_chirp_samples = [b * BLOCK for b in per_chirp]

    s = sorted(per_chirp)
    print(f"\n=== scene {scene} ===")
    print(f"  raw ADC: {CHIRPS} chirps x {N_RANGE} = {raw_samples:,} complex "
          f"samples ({raw_samples * 4 / 1024:.0f} KiB)")
    print("  per chirp, threshold applied independently:")
    print(f"    blocks kept   min {s[0]:3d}   median {s[len(s)//2]:3d}   "
          f"max {s[-1]:3d}   mean {sum(s)/len(s):6.1f} of 128")
    print(f"    samples kept  mean {sum(kept_chirp_samples)/CHIRPS:7.1f} of "
          f"{N_RANGE}  ({pct(sum(kept_chirp_samples)/CHIRPS, N_RANGE):5.2f}%)")
    print(f"    filtered out  {100 - pct(sum(kept_chirp_samples)/CHIRPS, N_RANGE):5.2f}%")
    print("  after the 256-chirp AND (what reach DRAM):")
    print(f"    blocks kept   {n_and} of 128")
    print(f"    samples kept  {n_and * BLOCK} of {N_RANGE}  "
          f"({pct(n_and * BLOCK, N_RANGE):5.2f}%)")
    print(f"    filtered out  {100 - pct(n_and * BLOCK, N_RANGE):5.2f}%")
    print(f"    volume: {n_and * BLOCK * CHIRPS * 4 / 1024:.0f} KiB of "
          f"{raw_samples * 4 / 1024:.0f} KiB "
          f"({pct(n_and * BLOCK, N_RANGE):.2f}%)")
    print(f"  union over chirps: {sum(orred)} blocks "
          f"({pct(sum(orred) * BLOCK, N_RANGE):.1f}% of bins appear at least once)")
    print(f"  ANDed blocks: {[i for i, k in enumerate(anded) if k]}")


def main():
    scenes = sys.argv[1:] or ["rd", "sparse", "dense"]
    for scene in scenes:
        build_windowed(scene)
        run_aie()
        report(scene, read_masks())


if __name__ == "__main__":
    main()

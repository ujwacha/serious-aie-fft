#!/usr/bin/env python3
"""Golden model and checker for the central-controller-element chain test.

    ./golden.py --generate [--chirps N]   write tb/work/adc.txt (N frames)
    ./golden.py --check    [--chirps N]   compare every stage against the model

The chain under test:

    adc.txt --[HLS: Hamming, Q15]--> windowed{0,1}.txt
            --[AIE: 2048-pt FFT, shift 11 + log_kernel_better]--> aie{0,1}.txt
            --[HLS: mask walk, DRAM writes]--> mm.txt

Every chirp is an independent 2048-sample frame.  The HLS kernel processes all
N chirps in one call, writing chirp c's kept blocks to mm[c*2048 + 16*b + j].
The model reproduces each stage.

Only the standard library is used.
"""

from __future__ import annotations

import argparse
import cmath
import math
import random
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent.parent
COMP = ROOT / "central-controller-element"
WORK = COMP / "tb" / "work"
HAMMING = COMP / "src" / "hamming.h"

N = 2048
BLOCK = 16
N_BLOCKS = N // BLOCK
SHIFT = 11
HIST_BINS = 64
THR_DB = 8.393
INPUT_SCALE = 1024
MAX_CHIRPS = 256

SPARSE = [
    (300.0, 24, 0.3),
    (301.6, 20, 1.1),
    (303.2, 17, 2.0),
    (700.0, 21, 0.0),
    (702.2, 18, 0.7),
    (512.4, 9, 1.9),
    (1280.3, 12, 2.4),
    (1500.7, 14, 0.5),
]


def round_away(x: float) -> int:
    return math.floor(x + 0.5) if x >= 0 else math.ceil(x - 0.5)


# --------------------------------------------------------------------------
# window, straight out of hamming.h so the model follows the header
# --------------------------------------------------------------------------
def load_window() -> list[int]:
    text = HAMMING.read_text()
    return [int(v) for v in re.findall(r"\{\s*(-?\d+),\s*0\}", text)]


def load_iq(path: Path) -> list[complex]:
    if not path.exists():
        raise SystemExit(f"missing {path}")
    out = []
    for line in path.read_text().splitlines():
        f = line.split()
        if f:
            out.append(complex(int(f[0]), int(f[1])))
    return out


# --------------------------------------------------------------------------
# input frames
# --------------------------------------------------------------------------
def dense_targets(count: int, seed: int) -> list[tuple[float, float, float]]:
    rng = random.Random(seed)
    out = []
    for _ in range(count):
        b = 650 + rng.random() * 600
        envelope = math.exp(-0.5 * ((b - 950) / 200) ** 2)
        out.append((b, 6 + 20 * envelope + 3 * (rng.random() - 0.5),
                    2 * math.pi * rng.random()))
    return out


SCENES = {
    "noise":  ([], 31),
    "sparse": (SPARSE, 11),
    "dense":  (SPARSE + dense_targets(50, 551), 61),
}


def make_adc(scene: str, chirp: int = 0) -> list[complex]:
    """Unwindowed complex noise + tones for one chirp, scaled to cint16.

    The HLS kernel applies the Hamming window, so this frame is deliberately
    NOT windowed.  Each chirp gets its own noise realisation via the seed.
    """
    targets, seed = SCENES[scene]
    rng = random.Random(seed + 100003 * chirp)
    window = [w / 32767.0 for w in load_window()]
    sum_w = sum(window)
    sum_w2 = sum(w * w for w in window)
    tones = [
        (b, math.sqrt(10 ** (snr / 10) * sum_w2 / (sum_w * sum_w)), ph)
        for b, snr, ph in targets
    ]

    raw = []
    for n in range(N):
        s = complex(rng.gauss(0, 1 / math.sqrt(2)), rng.gauss(0, 1 / math.sqrt(2)))
        for b, amp, ph in tones:
            s += amp * cmath.exp(1j * (2 * math.pi * b * n / N + ph))
        raw.append(s)

    scale = float(INPUT_SCALE)
    while True:
        q = []
        clipped = False
        for s in raw:
            re = round_away(s.real * scale)
            im = round_away(s.imag * scale)
            if not (-32768 <= re <= 32767 and -32768 <= im <= 32767):
                clipped = True
            q.append(complex(max(-32768, min(32767, re)), max(-32768, min(32767, im))))
        if not clipped:
            return q
        scale /= 2.0


# --------------------------------------------------------------------------
# HLS stage: Q15 Hamming, (x * w) >> 15 per half
# --------------------------------------------------------------------------
def apply_window(adc: list[complex], win: list[int]) -> list[complex]:
    out = []
    for n, s in enumerate(adc):
        w = win[n]
        out.append(complex((int(s.real) * w) >> 15, (int(s.imag) * w) >> 15))
    return out


# --------------------------------------------------------------------------
# AIE stage: FFT / 2^shift, then log_kernel_better's detector
# --------------------------------------------------------------------------
def radix2_fft(values: list[complex]) -> list[complex]:
    a = [complex(x) for x in values]
    j = 0
    for i in range(1, len(a)):
        bit = len(a) >> 1
        while j & bit:
            j ^= bit
            bit >>= 1
        j ^= bit
        if i < j:
            a[i], a[j] = a[j], a[i]
    length = 2
    while length <= len(a):
        half = length // 2
        wlen = cmath.exp(-2j * math.pi / length)
        for start in range(0, len(a), length):
            w = 1 + 0j
            for k in range(start, start + half):
                u = a[k]
                v = a[k + half] * w
                a[k] = u + v
                a[k + half] = u - v
                w *= wlen
        length *= 2
    return a


def percentile_histogram(values, span, nearest, truncate_after_quantile=False):
    if not span > 0:
        span = 1.0
    counts = [0] * HIST_BINS
    for value in values:
        scaled = max(0.0, value) * HIST_BINS / span
        index = math.floor(scaled + 0.5) if nearest else math.floor(scaled)
        counts[min(HIST_BINS - 1, max(0, index))] += 1
    target = (len(values) * 50 + 50) // 100
    cumulative = 0
    for index, count in enumerate(counts):
        previous = cumulative
        cumulative += count
        if cumulative >= target:
            fraction = (target - previous) / count
            if truncate_after_quantile:
                counts[index + 1:] = [0] * (HIST_BINS - index - 1)
            return (index + fraction) * span / HIST_BINS, counts
    return (HIST_BINS - 1) * span / HIST_BINS, counts


def aie_detector(fft_values):
    powers = [round_away(v.real) ** 2 + round_away(v.imag) ** 2 for v in fft_values]
    block_means = [sum(powers[i:i + BLOCK]) / BLOCK for i in range(0, N, BLOCK)]
    mean = sum(block_means) / N_BLOCKS
    median0, _ = percentile_histogram(block_means, 4 * mean, nearest=True)
    span = 4 * median0
    _, counts = percentile_histogram(block_means, span, nearest=True,
                                     truncate_after_quantile=True)
    maximum = max(counts)
    tied = [i for i, c in enumerate(counts) if c == maximum]
    mode = ((tied[0] + tied[-1]) / 2 + 0.5) * span / HIST_BINS
    noise_floor = mode * 16 / 15
    threshold = noise_floor * 10 ** (THR_DB / 10)
    keep = [any(p > threshold for p in powers[i:i + BLOCK])
            for i in range(0, N, BLOCK)]
    return noise_floor, threshold, keep


# --------------------------------------------------------------------------
# helpers
# --------------------------------------------------------------------------
def first_diff_iq(got, exp):
    """Index of the first differing sample, or -1 when identical."""
    n = min(len(got), len(exp))
    for i in range(n):
        if int(got[i].real) != int(exp[i].real) or int(got[i].imag) != int(exp[i].imag):
            return i
    return n if len(got) != len(exp) else -1


def model_chirps(adc, win):
    frames = []
    for c in range(len(adc) // N):
        frame = adc[c * N:(c + 1) * N]
        win_frame = apply_window(frame, win)
        fft = [v / (1 << SHIFT) for v in radix2_fft(win_frame)]
        floor, threshold, keep = aie_detector(fft)
        frames.append({"win": win_frame, "fft": fft, "keep": keep,
                       "floor": floor, "threshold": threshold})
    return frames


# --------------------------------------------------------------------------
# checks
# --------------------------------------------------------------------------
def check_windowed(frames):
    ok = True
    for port, parity in ((0, 0), (1, 1)):
        got = load_iq(WORK / f"windowed{port}.txt")
        exp = []
        for fr in frames:
            exp.extend(fr["win"][parity::2])
        if len(got) != len(exp):
            print(f"  windowed{port}: length {len(got)} != {len(exp)}")
            ok = False
            continue
        i = first_diff_iq(got, exp)
        if i >= 0:
            print(f"  windowed{port}: {len(got)} samples, first mismatch at {i}: "
                  f"got {int(got[i].real)},{int(got[i].imag)} "
                  f"expected {int(exp[i].real)},{int(exp[i].imag)}")
            ok = False
        else:
            print(f"  windowed{port}: {len(got)} samples match exactly")
    return ok


def check_aie(frames):
    """Validate each chirp's AIE segment and return the expected DRAM image.

    The AIE detector's threshold comes from a coarse histogram mode, so it can
    sit a few percent away from the float model's threshold and a handful of
    borderline blocks may flip.  That agreement is reported, but only a gross
    per-chirp disagreement is a failure (it would mean the wrong frame reached
    the AIE).  The strong checks are the payload tolerance plus the DRAM and
    mask-packet consistency in check_dram()/check_masks().  Returns the actual
    per-chirp mask (what the AIE emitted) so the kernel's mask packet can be
    checked against it.
    """
    MASK_TOL = 16  # max blocks (of 128) allowed to differ from the float model
    out0 = load_iq(WORK / "aie0.txt")
    out1 = load_iq(WORK / "aie1.txt")
    exp_mm = [complex(0, 0)] * (N * len(frames))
    errors = []
    actual = []
    mask_diff = []  # (chirp, count)
    bad_zero, bad_size = [], []
    o0 = o1 = 0

    for c, fr in enumerate(frames):
        keep = fr["keep"]
        fft = fr["fft"]

        if o0 + 64 > len(out0) or o1 + 64 > len(out1):
            bad_size.append(c)
            break

        flags = []
        for word in out0[o0:o0 + 64]:
            flags.extend((word.real != 0, word.imag != 0))
        actual.append(flags)
        diff = sum(a != b for a, b in zip(flags, keep))
        if diff:
            mask_diff.append((c, diff))
        if any(v != 0 for v in out1[o1:o1 + 64]):
            bad_zero.append(c)

        k = sum(flags)
        n0 = 64 + ((k + 1) // 2) * BLOCK
        n1 = 64 + (k // 2) * BLOCK
        seg0 = out0[o0:o0 + n0]
        seg1 = out1[o1:o1 + n1]
        if len(seg0) != n0 or len(seg1) != n1:
            bad_size.append(c)
            break

        cur0 = cur1 = 64
        turn = 0
        base = c * N
        for block, kept in enumerate(flags):
            if not kept:
                continue
            if turn == 0:
                got = seg0[cur0:cur0 + BLOCK]
                cur0 += BLOCK
            else:
                got = seg1[cur1:cur1 + BLOCK]
                cur1 += BLOCK
            turn ^= 1
            exp = fft[block * BLOCK:(block + 1) * BLOCK]
            if len(got) != BLOCK:
                errors.append(float("inf"))
                continue
            errors.extend(abs(a - b) for a, b in zip(got, exp))
            for j, v in enumerate(got):
                exp_mm[base + block * BLOCK + j] = v

        o0 += n0
        o1 += n1

    if bad_size:
        print(f"  AIE stream sizes: WRONG (chirp {bad_size[0]} truncated or "
              f"misaligned; got {len(out0)}/{len(out1)} words)")
    else:
        print(f"  AIE stream sizes: ok ({len(out0)}/{len(out1)} words, "
              f"{len(frames)} chirps)")
    total = sum(sum(fr["keep"]) for fr in frames)
    total_blocks = N_BLOCKS * len(frames)
    worst_c, worst_n = max(mask_diff, default=(-1, 0), key=lambda x: x[1])
    if worst_n > MASK_TOL:
        print(f"  AIE mask        : MISMATCH (chirp {worst_c}: {worst_n}/128 "
              f"blocks differ from the float model)")
    elif mask_diff:
        nd = sum(n for _, n in mask_diff)
        print(f"  AIE mask        : {total} kept; {nd}/{total_blocks} block(s) "
              f"differ from the float model ({100.0 * nd / total_blocks:.3f}%, "
              f"worst chirp {worst_c}: {worst_n}/128)")
    else:
        print(f"  AIE mask        : match ({total} kept blocks over "
              f"{len(frames)} chirps)")
    print(f"  AIE mask stream1: "
          f"{'all zero' if not bad_zero else f'NOT zero in {len(bad_zero)} chirp(s)'}")

    max_err = max(errors, default=0.0)
    rms_err = math.sqrt(sum(e * e for e in errors) / len(errors)) if errors else 0.0
    print(f"  AIE payload     : max {max_err:.3f} / rms {rms_err:.3f} cint16 units")

    ok = (not bad_size and worst_n <= MASK_TOL and not bad_zero
          and max_err < 3.0)
    return ok, exp_mm, actual


def check_dram(frames, exp_mm):
    mm = load_iq(WORK / "mm.txt")
    total = N * len(frames)
    if len(mm) != total:
        print(f"  DRAM            : mm.txt has {len(mm)} words, expected {total}")
        return False
    i = first_diff_iq(mm, exp_mm)
    if i >= 0:
        print(f"  DRAM            : first mismatch at {i} (chirp {i // N}, "
              f"word {i % N}): got {int(mm[i].real)},{int(mm[i].imag)} "
              f"expected {int(exp_mm[i].real)},{int(exp_mm[i].imag)}")
        return False
    kept = sum(sum(fr["keep"]) for fr in frames)
    print(f"  DRAM            : {total} words match the AIE payload exactly "
          f"({kept} blocks x {BLOCK} over {len(frames)} chirps)")
    return True


def check_masks(frames, actual):
    """The kernel condenses the AIE mask words it received, so compare the
    packets against the AIE's actual per-chirp mask (not the float model).

    The mask is now consumed inside the kernel (seq_generator), so there is no
    mask_out.txt unless the testbench is given a debug tap."""
    path = WORK / "mask_out.txt"
    if not path.exists():
        print("  mask packets    : skipped (mask is internal to the kernel)")
        return True
    lines = [ln for ln in path.read_text().splitlines() if ln.strip()]
    if len(lines) != len(frames):
        print(f"  mask packets    : {len(lines)} lines, expected {len(frames)}")
        return False
    if len(actual) != len(frames):
        print(f"  mask packets    : AIE mask missing for {len(frames) - len(actual)} chirp(s)")
        return False
    for c, (line, flags) in enumerate(zip(lines, actual)):
        parts = line.split()
        seq, chirp, bits = int(parts[0]), int(parts[1]), parts[2]
        exp_bits = "".join("1" if k else "0" for k in flags)
        if bits != exp_bits:
            diff = sum(a != b for a, b in zip(bits, exp_bits))
            print(f"  mask packets    : chirp {c}: {diff}/128 bits differ")
            return False
        if seq != 0 or chirp != (c & 0xFF):
            print(f"  mask packets    : chirp {c}: seq/chirp {seq}/{chirp}, "
                  f"expected 0/{c & 0xFF}")
            return False
    print(f"  mask packets    : {len(frames)} packets, seq=0, chirp=c, 128 bits match")
    return True


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--generate", action="store_true")
    ap.add_argument("--check", action="store_true")
    ap.add_argument("--scene", choices=sorted(SCENES), default=None,
                    help="test scene (default: value in tb/work/scene.txt, else 'sparse')")
    ap.add_argument("--chirps", type=int, default=None,
                    help="number of chirps (default: 1 for --generate, "
                         "derived from adc.txt for --check)")
    args = ap.parse_args()

    WORK.mkdir(parents=True, exist_ok=True)
    win = load_window()
    if len(win) != N:
        raise SystemExit(f"hamming.h has {len(win)} taps, expected {N}")

    scene = args.scene
    if scene is None and (WORK / "scene.txt").exists():
        scene = (WORK / "scene.txt").read_text().strip()
    scene = scene or "sparse"

    if args.generate:
        chirps = args.chirps or 1
        if not 1 <= chirps <= MAX_CHIRPS:
            raise SystemExit(f"--chirps must be in 1..{MAX_CHIRPS}")
        peak = 0
        with (WORK / "adc.txt").open("w") as f:
            for c in range(chirps):
                adc = make_adc(scene, c)
                for v in adc:
                    f.write(f"{int(v.real)} {int(v.imag)}\n")
                peak = max(peak, max(max(abs(v.real), abs(v.imag)) for v in adc))
        (WORK / "scene.txt").write_text(scene + "\n")
        print(f"wrote {WORK / 'adc.txt'} ({chirps} chirps x {N} samples, "
              f"scene '{scene}', peak |x| = {peak:.0f})")
        return 0

    if not args.check:
        ap.error("pass --generate or --check")

    adc = load_iq(WORK / "adc.txt")
    if len(adc) % N != 0:
        raise SystemExit(f"adc.txt has {len(adc)} samples, expected a multiple of {N}")
    chirps = args.chirps if args.chirps is not None else len(adc) // N
    if len(adc) != chirps * N:
        raise SystemExit(f"adc.txt has {len(adc)} samples, expected {chirps} x {N}")
    if not 1 <= chirps <= MAX_CHIRPS:
        raise SystemExit(f"chirps must be in 1..{MAX_CHIRPS}")

    print("== chain check ==")
    print(f"  scene           : {scene}")
    print(f"  chirps          : {chirps}")

    frames = model_chirps(adc, win)
    kept = [sum(fr["keep"]) for fr in frames]
    floors = [fr["floor"] for fr in frames]
    thresholds = [fr["threshold"] for fr in frames]
    print(f"  noise floor     : {min(floors):.3f}..{max(floors):.3f}  "
          f"threshold: {min(thresholds):.3f}..{max(thresholds):.3f}")
    print(f"  model keeps     : {sum(kept)}/{chirps * N_BLOCKS} blocks "
          f"(per chirp {min(kept)}..{max(kept)})")

    ok_w = check_windowed(frames)
    ok_a, exp_mm, actual = check_aie(frames)
    ok_d = check_dram(frames, exp_mm)
    ok_m = check_masks(frames, actual)

    ok = ok_w and ok_a and ok_d and ok_m
    print(f"\n  RESULT: {'PASS' if ok else 'FAIL'}")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())

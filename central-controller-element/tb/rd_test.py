#!/usr/bin/env python3
"""Range-Doppler chain test for the central-controller-element kernel.

    ./rd_test.py --generate --scene rd --chirps 256
    ./rd_test.py --prepare  --chirps 256
    ./rd_test.py --check    --chirps 256

The generator works in floating point and quantises only at the points where
the hardware is fixed point:

    ADC cube             float targets + noise -> int16 cint16
    range FFT output     AIE float FFT / 2^11 -> int16 cint16
    Doppler-window out   Q15 integer multiply (same as the HLS stage)
    Doppler FFT output   float FFT / 2^4      -> int16 cint16

The file layout matches the testbench:

    adc.txt              one chirp per 2048 lines, 256 chirps
    windowed{0,1}.txt    HLS range-window output, even/odd samples
    aie{0,1}.txt         AIE 2048-point range FFT output, even/odd samples
    dop_win{0,1}.txt     HLS Doppler-window output, even/odd samples
    dop_win_exp{0,1}.txt expected Doppler-window output
    doppler{0,1}.txt     256-point Doppler FFT input, even/odd samples
    mm_range.txt         range cube, seq 0: [chirp][range]
    mm_doppler.txt       Doppler cube, seq 0: [range][Doppler]

The 256-point Doppler FFT is modelled here (float FFT, then cint16
quantisation) because csim cannot run an AIE graph mid-kernel.
tb/doppler_aie_check.py cross-checks that model against the real AIE graph.

Only the Python standard library is used.
"""

from __future__ import annotations

import argparse
import cmath
import math
import random
import re
import struct
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent.parent
COMP = ROOT / "central-controller-element"
WORK = COMP / "tb" / "work"
HAMMING = COMP / "src" / "hamming.h"

N_RANGE = 2048
N_DOPPLER = 256
BLOCK = 16
N_BLOCKS = N_RANGE // BLOCK
SHIFT_RANGE = 11
SHIFT_DOPPLER = 4
INPUT_SCALE = 1024
# 10^(8.393/10): the AIE threshold kernel's 8.393 dB margin, applied to the
# median noise power.  Same constant as kThrMagMult in doppler_part.cpp.
THRESHOLD_MARGIN = 6.9072
INT32_MAX = 0x7FFFFFFF

# Targets are (range_bin, Doppler_bin, amplitude, phase).  Amplitude is in
# units of the unit-variance noise before INPUT_SCALE is applied.
SCENES = {
    "rd": [
        (192, 0, 2.2, 0.2),
        (512, 32, 1.8, 1.1),
        (900, 200, 1.5, 2.0),
        (1500, 128, 1.0, 0.7),
    ],
    "sparse": [
        (300, 8, 2.0, 0.3),
        (700, 48, 1.5, 1.4),
        (1280, 224, 1.2, 2.1),
        (1800, 96, 1.0, 0.5),
    ],
    "dense": [
        (256, 0, 2.0, 0.0),
        (320, 16, 1.8, 0.4),
        (384, 32, 1.6, 0.8),
        (448, 48, 1.5, 1.2),
        (512, 64, 1.4, 1.6),
        (576, 80, 1.3, 2.0),
        (640, 96, 1.2, 2.4),
        (704, 112, 1.1, 2.8),
    ],
}


def round_away(x: float) -> int:
    return math.floor(x + 0.5) if x >= 0 else math.ceil(x - 0.5)


def wrap16(x: int) -> int:
    x &= 0xFFFF
    return x - 0x10000 if x >= 0x8000 else x


def wrap32(x: int) -> int:
    x &= 0xFFFFFFFF
    return x - 0x100000000 if x >= 0x80000000 else x


def clamp16(x: int) -> int:
    return max(-32768, min(32767, x))


def load_window(length: int) -> list[int]:
    """Read one Hamming table from hamming.h, without mixing the two tables."""
    text = HAMMING.read_text()
    begin = f"/* BEGIN hamming_window_{length} */"
    end = f"/* END hamming_window_{length} */"
    match = re.search(re.escape(begin) + r"(.*?)" + re.escape(end), text, re.S)
    if not match:
        raise SystemExit(f"hamming_window_{length} not found in {HAMMING}")
    return [int(v) for v in re.findall(r"\{\s*(-?\d+),\s*0\}", match.group(1))]


def f32(x: float) -> float:
    """Round to IEEE-754 binary32, matching C++ float arithmetic."""
    return struct.unpack("<f", struct.pack("<f", float(x)))[0]


def frame_threshold(spec: list[complex]) -> int:
    """Reproduce aie_consume_doppler()'s per-frame threshold exactly.

    The kernel computes mean power, a 64-bin histogram over [0, 4*mean], the
    median bin, and the median power at the bin centre, then scales it by the
    8.393 dB power margin.  The C++ code mixes int, double and float, so the
    rounding/truncation is reproduced step by step.
    """
    powers = [min(int(v.real) * int(v.real) + int(v.imag) * int(v.imag),
                  INT32_MAX) for v in spec]
    mean = sum(powers) >> 8                 # int64 mean_acc -> int32, /256

    scale_q24 = ((16 << 24) // mean) if mean > 0 else 0
    hist = [0] * 64
    for p in powers:
        b = (p * scale_q24) >> 24
        hist[63 if b > 63 else b] += 1

    total = 0
    median_bin = 0
    for i, count in enumerate(hist):
        total += count
        if total > N_DOPPLER // 2:
            median_bin = i
            break

    # int32_t bin_width  = (4.0 * mean) / 64.0;          // double -> int32
    # int32_t median_mag = (median_bin + 0.5f) * bin_width; // float -> int32
    # int32_t threshold  = median_mag * kThrMagMult;       // float -> int32
    bin_width = int((4.0 * mean) / 64.0)
    median_power = int(f32(f32(median_bin + 0.5) * f32(bin_width)))
    return int(f32(f32(median_power) * f32(THRESHOLD_MARGIN)))


def apply_window(frame: list[complex], win: list[int]) -> list[complex]:
    """Q15 Hamming, same integer arithmetic as adc_forward()."""
    return [complex((int(v.real) * win[n]) >> 15,
                    (int(v.imag) * win[n]) >> 15)
            for n, v in enumerate(frame)]


def cmul_i16(a: complex, b: complex) -> complex:
    """Q15 complex multiply with the kernel's 32-bit intermediate."""
    real = wrap32(int(a.real) * int(b.real) - int(a.imag) * int(b.imag)) >> 15
    imag = wrap32(int(a.real) * int(b.imag) + int(a.imag) * int(b.real)) >> 15
    return complex(wrap16(real), wrap16(imag))


def fft(values: list[complex]) -> list[complex]:
    """Double-precision, radix-2 forward FFT, natural order in/out."""
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


def quantize_fft(values: list[complex], shift: int) -> list[complex]:
    """Float FFT -> the cint16 values the AIE emits after its output shift."""
    scale = 1.0 / float(1 << shift)
    out = []
    for v in values:
        out.append(complex(clamp16(round_away(v.real * scale)),
                           clamp16(round_away(v.imag * scale))))
    return out


def read_iq(path: Path) -> list[complex]:
    if not path.exists():
        raise SystemExit(f"missing {path}")
    out = []
    for line in path.read_text().splitlines():
        f = line.split()
        if f:
            out.append(complex(int(f[0]), int(f[1])))
    return out


def write_iq(path: Path, values: list[complex]) -> None:
    with path.open("w") as stream:
        for v in values:
            stream.write(f"{int(v.real)} {int(v.imag)}\n")


# ---------------------------------------------------------------------------
# generation
# ---------------------------------------------------------------------------
def generate(scene: str, chirps: int) -> None:
    targets = SCENES[scene]
    rng = random.Random(0x5EED + 100003 * 0 + len(targets))
    sigma = 1.0 / math.sqrt(2.0)

    fast = []
    slow = []
    for r, d, amp, phase in targets:
        fast.append((amp, [cmath.exp(1j * (2.0 * math.pi * r * n / N_RANGE))
                           for n in range(N_RANGE)]))
        slow.append([cmath.exp(1j * (2.0 * math.pi * d * c / N_DOPPLER + phase))
                     for c in range(chirps)])

    peeled = []
    peak = 0
    for c in range(chirps):
        frame = []
        for n in range(N_RANGE):
            s = complex(rng.gauss(0.0, sigma), rng.gauss(0.0, sigma))
            for k, (amp, tone) in enumerate(fast):
                s += amp * tone[n] * slow[k][c]
            frame.append(s)
        peeled.append(frame)
        peak = max(peak, max(max(abs(v.real), abs(v.imag)) for v in frame))

    scale = float(INPUT_SCALE)
    if peak * scale > 32000.0:
        scale = 32000.0 / peak
        print(f"  reducing ADC scale to {scale:.1f} to avoid clipping")

    WORK.mkdir(parents=True, exist_ok=True)
    with (WORK / "adc.txt").open("w") as stream:
        for frame in peeled:
            for v in frame:
                stream.write(f"{clamp16(round_away(v.real * scale))} "
                             f"{clamp16(round_away(v.imag * scale))}\n")
    (WORK / "scene.txt").write_text(scene + "\n")
    print(f"wrote {WORK / 'adc.txt'} ({chirps} chirps x {N_RANGE} samples, "
          f"scene '{scene}', peak |x| = {peak * scale:.0f})")


# ---------------------------------------------------------------------------
# AIE range output -> range cube
# ---------------------------------------------------------------------------
def load_aie_range(chirps: int):
    """Reconstruct what aie_range_consume() writes into the DRAM range cube.

    Returns cube[chirp][range] and the per-chirp 128-bit block masks.
    """
    out0 = read_iq(WORK / "aie0.txt")
    out1 = read_iq(WORK / "aie1.txt")
    cube = [[0j] * N_RANGE for _ in range(chirps)]
    masks: list[list[bool]] = []
    o0 = o1 = 0

    for c in range(chirps):
        if o0 + 64 > len(out0) or o1 + 64 > len(out1):
            raise SystemExit(f"AIE range output truncated at chirp {c}")
        flags = []
        for word in out0[o0:o0 + 64]:
            flags.append(word.real != 0)
            flags.append(word.imag != 0)
        masks.append(flags)

        kept = sum(flags)
        n0 = 64 + ((kept + 1) // 2) * BLOCK
        n1 = 64 + (kept // 2) * BLOCK
        seg0 = out0[o0:o0 + n0]
        seg1 = out1[o1:o1 + n1]
        if len(seg0) != n0 or len(seg1) != n1:
            raise SystemExit(f"AIE range stream misaligned at chirp {c}")

        cur0 = cur1 = 64
        turn = 0
        for block, keep in enumerate(flags):
            if not keep:
                continue
            got = seg0[cur0:cur0 + BLOCK] if turn == 0 else seg1[cur1:cur1 + BLOCK]
            if turn == 0:
                cur0 += BLOCK
            else:
                cur1 += BLOCK
            turn ^= 1
            base = block * BLOCK
            for j, value in enumerate(got):
                cube[c][base + j] = value
        o0 += n0
        o1 += n1

    return cube, masks


def active_blocks(masks: list[list[bool]]) -> list[int]:
    if not masks:
        return []
    active = [True] * N_BLOCKS
    for mask in masks:
        active = [a and b for a, b in zip(active, mask)]
    return [i for i, keep in enumerate(active) if keep]


def doppler_model(cube, chirps: int, blocks: list[int]):
    """Doppler-window and 256-point FFT every range bin in the active blocks.

    Returns (doppler_win0, doppler_win1, doppler0, doppler1, expected).
    The expected map is keyed by range bin and holds the 256 cint16 values the
    kernel should write (zero where its power threshold rejects the bin).
    """
    win = load_window(N_DOPPLER)
    win0: list[complex] = []
    win1: list[complex] = []
    dop0: list[complex] = []
    dop1: list[complex] = []
    expected: dict[int, list[complex]] = {}

    for block in blocks:
        for b in range(BLOCK):
            r = block * BLOCK + b
            x = [cube[c][r] for c in range(chirps)]
            y = [cmul_i16(x[c], complex(win[c], 0)) for c in range(chirps)]
            win0.extend(y[0::2])
            win1.extend(y[1::2])

            spec = quantize_fft(fft(y), SHIFT_DOPPLER)
            dop0.extend(spec[0::2])
            dop1.extend(spec[1::2])

            # aie_consume_doppler keeps a whole 16-bin block if any lane in
            # that block crosses the per-frame adaptive power threshold.
            threshold = frame_threshold(spec)
            out = []
            for bb in range(N_DOPPLER // BLOCK):
                chunk = spec[bb * BLOCK:(bb + 1) * BLOCK]
                keep = any(
                    int(v.real) * int(v.real) + int(v.imag) * int(v.imag)
                    > threshold for v in chunk)
                out.extend(chunk if keep else [0j] * BLOCK)
            expected[r] = out

    return win0, win1, dop0, dop1, expected


def prepare(chirps: int) -> None:
    cube, masks = load_aie_range(chirps)
    blocks = active_blocks(masks)
    print(f"  AIE range: {len(cube)} chirps, {len(blocks)} active range block(s)")
    if not blocks:
        raise SystemExit("no active range blocks: the AIE mask intersection is empty")

    win0, win1, dop0, dop1, _ = doppler_model(cube, chirps, blocks)
    write_iq(WORK / "dop_win_exp0.txt", win0)
    write_iq(WORK / "dop_win_exp1.txt", win1)
    write_iq(WORK / "doppler0.txt", dop0)
    write_iq(WORK / "doppler1.txt", dop1)
    (WORK / "active_blocks.txt").write_text(
        "\n".join(str(b) for b in blocks) + "\n")
    print(f"  prepared {len(blocks)} block(s) -> "
          f"{len(dop0)} / {len(dop1)} Doppler samples per stream")


# ---------------------------------------------------------------------------
# checking
# ---------------------------------------------------------------------------
def check_windowed(chirps: int) -> bool:
    adc = read_iq(WORK / "adc.txt")
    win = load_window(N_RANGE)
    ok = True
    for port, parity in ((0, 0), (1, 1)):
        got = read_iq(WORK / f"windowed{port}.txt")
        exp = []
        for c in range(chirps):
            frame = adc[c * N_RANGE:(c + 1) * N_RANGE]
            exp.extend(apply_window(frame, win)[parity::2])
        if len(got) != len(exp):
            print(f"  windowed{port}: length {len(got)} != {len(exp)}")
            ok = False
        elif any(int(a.real) != int(b.real) or int(a.imag) != int(b.imag)
                 for a, b in zip(got, exp)):
            first = next(i for i, (a, b) in enumerate(zip(got, exp))
                         if int(a.real) != int(b.real) or int(a.imag) != int(b.imag))
            print(f"  windowed{port}: first mismatch at {first}")
            ok = False
        else:
            print(f"  windowed{port}: {len(got)} samples match exactly")
    return ok


def check_range_cube(chirps: int) -> tuple[bool, list[list[bool]]]:
    cube, masks = load_aie_range(chirps)
    got = read_iq(WORK / "mm_range.txt")
    if len(got) != chirps * N_RANGE:
        print(f"  range cube: {len(got)} words, expected {chirps * N_RANGE}")
        return False, masks
    first = -1
    for c in range(chirps):
        base = c * N_RANGE
        for r in range(N_RANGE):
            a, b = got[base + r], cube[c][r]
            if int(a.real) != int(b.real) or int(a.imag) != int(b.imag):
                first = base + r
                break
        if first >= 0:
            break
    if first >= 0:
        c, r = divmod(first, N_RANGE)
        print(f"  range cube: first mismatch chirp {c}, range {r}")
        return False, masks
    print(f"  range cube: {len(got)} words match the AIE payload exactly")
    return True, masks


def check_doppler_cube(chirps: int, masks: list[list[bool]]) -> tuple[bool, list[int]]:
    blocks = active_blocks(masks)
    if not blocks:
        print("  Doppler cube: no active blocks")
        return False, blocks

    got = read_iq(WORK / "mm_doppler.txt")
    if len(got) != N_RANGE * N_DOPPLER:
        print(f"  Doppler cube: {len(got)} words, expected {N_RANGE * N_DOPPLER}")
        return False, blocks

    win_got0 = read_iq(WORK / "dop_win0.txt")
    win_got1 = read_iq(WORK / "dop_win1.txt")
    dop_got0 = read_iq(WORK / "doppler0.txt")
    dop_got1 = read_iq(WORK / "doppler1.txt")

    cube, _ = load_aie_range(chirps)
    win = load_window(N_DOPPLER)
    win0, win1, dop0, dop1, expected = doppler_model(cube, chirps, blocks)

    if len(win_got0) != len(win0) or len(win_got1) != len(win1):
        print(f"  Doppler window: length {len(win_got0)}/{len(win_got1)}, "
              f"expected {len(win0)}/{len(win1)}")
        return False, blocks
    if len(dop_got0) != len(dop0) or len(dop_got1) != len(dop1):
        print(f"  Doppler FFT: length {len(dop_got0)}/{len(dop_got1)}, "
              f"expected {len(dop0)}/{len(dop1)}")
        return False, blocks

    if any(int(a.real) != int(b.real) or int(a.imag) != int(b.imag)
           for a, b in zip(win_got0 + win_got1, win0 + win1)):
        print("  Doppler window: HLS output differs from the Python model")
        return False, blocks
    print(f"  Doppler window: {len(win0) + len(win1)} samples match exactly")

    if any(int(a.real) != int(b.real) or int(a.imag) != int(b.imag)
           for a, b in zip(dop_got0 + dop_got1, dop0 + dop1)):
        print("  Doppler FFT: testbench input differs from the Python model")
        return False, blocks
    print(f"  Doppler FFT: {len(dop0) + len(dop1)} samples match exactly")

    # The kernel writes only bins above its power threshold and leaves the
    # rest of the cube at zero.
    bad = 0
    for r in range(N_RANGE):
        exp = expected.get(r)
        for d in range(N_DOPPLER):
            a = got[r * N_DOPPLER + d]
            b = exp[d] if exp is not None else 0j
            if int(a.real) != int(b.real) or int(a.imag) != int(b.imag):
                if bad < 5:
                    print(f"  Doppler cube: mismatch range {r}, Doppler {d}: "
                          f"got {int(a.real)},{int(a.imag)} expected "
                          f"{int(b.real)},{int(b.imag)}")
                bad += 1
    if bad:
        print(f"  Doppler cube: {bad} word(s) differ")
        return False, blocks
    print(f"  Doppler cube: {N_RANGE * N_DOPPLER} words match the model "
          f"({len(blocks)} active block(s))")
    return True, blocks


def check_peaks(scene: str) -> bool:
    got = read_iq(WORK / "mm_doppler.txt")
    targets = SCENES[scene]
    ok = True
    print("  targets:")
    for r, d, amp, phase in targets:
        best = None
        for rr in range(max(0, r - 2), min(N_RANGE, r + 3)):
            for dd in range(d - 2, d + 3):
                v = got[rr * N_DOPPLER + (dd % N_DOPPLER)]
                p = v.real * v.real + v.imag * v.imag
                if best is None or p > best[0]:
                    best = (p, rr, dd % N_DOPPLER)
        assert best is not None
        peak_r, peak_d = best[1], best[2]
        hit = abs(peak_r - r) <= 1 and min((peak_d - d) % N_DOPPLER,
                                           (d - peak_d) % N_DOPPLER) <= 1
        print(f"    ({r:4d}, {d:3d}) amp {amp:4.1f}: peak at "
              f"({peak_r:4d}, {peak_d:3d}) power {best[0]:.0f} "
              f"{'ok' if hit else 'MISS'}")
        ok = ok and hit
    return ok


def check(scene: str, chirps: int) -> int:
    print("== range-Doppler chain check ==")
    print(f"  scene  : {scene}")
    print(f"  chirps : {chirps} ({N_RANGE} range x {N_DOPPLER} Doppler)")
    ok_w = check_windowed(chirps)
    ok_r, masks = check_range_cube(chirps)
    ok_d, blocks = check_doppler_cube(chirps, masks)
    ok_p = check_peaks(scene) if blocks else False
    ok = ok_w and ok_r and ok_d and ok_p
    print(f"\n  RESULT: {'PASS' if ok else 'FAIL'}")
    return 0 if ok else 1


def main() -> int:
    ap = argparse.ArgumentParser()
    mode = ap.add_mutually_exclusive_group(required=True)
    mode.add_argument("--generate", action="store_true")
    mode.add_argument("--prepare", action="store_true")
    mode.add_argument("--check", action="store_true")
    ap.add_argument("--scene", choices=sorted(SCENES), default="rd")
    ap.add_argument("--chirps", type=int, default=N_DOPPLER)
    args = ap.parse_args()

    if not 1 <= args.chirps <= N_DOPPLER:
        raise SystemExit(f"--chirps must be in 1..{N_DOPPLER}")
    if args.generate:
        generate(args.scene, args.chirps)
    elif args.prepare:
        prepare(args.chirps)
    else:
        scene = args.scene
        scene_file = WORK / "scene.txt"
        if scene_file.exists():
            scene = scene_file.read_text().strip() or scene
        return check(scene, args.chirps)
    return 0


if __name__ == "__main__":
    sys.exit(main())

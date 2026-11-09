#!/usr/bin/env python3
"""Generate MATLAB-style sparse/dense frames and validate the whole AIE graph.

Uses only Python's standard library. Inputs follow hist_sim.m's model, are
Hamming-windowed and quantized to cint16, then split into the FFT's two SSR
input streams. The script runs x86sim and checks its block mask and payload
against a Python FFT and a Python copy of the AIE kernel's detector.
"""

from __future__ import annotations

import cmath
import math
import os
import random
import subprocess
import sys
from pathlib import Path


COMPONENT = Path(__file__).resolve().parent
DATA = COMPONENT / "data"
N = 2048
SHIFT = 11
BLOCK = 16
N_BLOCKS = N // BLOCK
HIST_BINS = 64
THR_DB = 8.393
INPUT_SCALE = 1024
OUTPUT_DIR = COMPONENT / "build/x86sim/x86simulator_output/data"

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


def matlab_style_dense_targets(count: int, seed: int) -> list[tuple[float, float, float]]:
    rng = random.Random(seed)
    targets = []
    for _ in range(count):
        bin_number = 650 + rng.random() * 600
        envelope = math.exp(-0.5 * ((bin_number - 950) / 200) ** 2)
        snr_db = 6 + 20 * envelope + 3 * (rng.random() - 0.5)
        phase = 2 * math.pi * rng.random()
        targets.append((bin_number, snr_db, phase))
    return targets


def make_windowed_iq(targets: list[tuple[float, float, float]], seed: int) -> list[complex]:
    """Mirror hist_sim.m's complex noise, tones, Hamming window and cint16 input."""
    rng = random.Random(seed)
    window = [0.54 - 0.46 * math.cos(2 * math.pi * n / (N - 1)) for n in range(N)]
    sum_w = sum(window)
    sum_w2 = sum(w * w for w in window)
    tone_params = [
        (bin_number, math.sqrt(10 ** (snr_db / 10) * sum_w2 / (sum_w * sum_w)), phase)
        for bin_number, snr_db, phase in targets
    ]
    sigma = 1 / math.sqrt(2)
    samples = []
    clip_count = 0

    for n in range(N):
        sample = complex(rng.gauss(0, sigma), rng.gauss(0, sigma))
        for bin_number, amp, phase in tone_params:
            sample += amp * cmath.exp(1j * (2 * math.pi * bin_number * n / N + phase))

        sample *= window[n] * INPUT_SCALE
        real = round_away(sample.real)
        imag = round_away(sample.imag)
        if not (-32768 <= real <= 32767 and -32768 <= imag <= 32767):
            clip_count += 1
        real = max(-32768, min(32767, real))
        imag = max(-32768, min(32767, imag))
        samples.append(complex(real, imag))

    if clip_count:
        raise RuntimeError(f"input quantization clipped {clip_count} samples; reduce INPUT_SCALE")
    return samples


def round_away(x: float) -> int:
    return math.floor(x + 0.5) if x >= 0 else math.ceil(x - 0.5)


def radix2_fft(values: list[complex]) -> list[complex]:
    """Double-precision, radix-2 forward FFT, natural order in/out."""
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


def write_plio_inputs(samples: list[complex]) -> None:
    DATA.mkdir(parents=True, exist_ok=True)
    for port, parity in ((0, 0), (1, 1)):
        path = DATA / f"temp_input{port}.txt"
        with path.open("w") as stream:
            for value in samples[parity::2]:
                stream.write(f"{int(value.real)} {int(value.imag)}\n")


def run_x86sim() -> None:
    env = os.environ.copy()
    env["FFT_TEST"] = "0"  # The existing helper test exercises a different graph.
    result = subprocess.run(
        [str(COMPONENT / "x86sim.sh"), "run"],
        cwd=COMPONENT,
        env=env,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    if result.returncode:
        print(result.stdout[-12000:], file=sys.stderr)
        raise RuntimeError(f"x86sim exited with status {result.returncode}")
    print("x86sim: completed")


def read_plio_output(name: str) -> list[complex]:
    path = OUTPUT_DIR / name
    if not path.exists():
        raise RuntimeError(f"simulator output not found: {path}")
    values = []
    for line_number, line in enumerate(path.read_text().splitlines(), 1):
        fields = line.split()
        if not fields:
            continue
        if len(fields) != 2:
            raise RuntimeError(f"unexpected PLIO format at {path}:{line_number}: {line!r}")
        values.append(complex(int(fields[0]), int(fields[1])))
    return values


def percentile_histogram(
    values: list[float], span: float, nearest: bool, truncate_after_quantile: bool = False
) -> tuple[float, list[int]]:
    if not span > 0:
        span = 1.0
    counts = [0] * HIST_BINS
    for value in values:
        scaled = max(0.0, value) * HIST_BINS / span
        if nearest:
            index = math.floor(scaled + 0.5)
        else:
            index = math.floor(scaled)
        index = min(HIST_BINS - 1, max(0, index))
        counts[index] += 1

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


def aie_detector(fft_values: list[complex]) -> tuple[float, float, list[bool]]:
    # abs_square in the AIE kernel sees the rounded cint16 FFT output.
    powers = [
        round_away(value.real) ** 2 + round_away(value.imag) ** 2
        for value in fft_values
    ]
    block_means = [sum(powers[i:i + BLOCK]) / BLOCK for i in range(0, N, BLOCK)]
    mean = sum(block_means) / N_BLOCKS
    median0, _ = percentile_histogram(block_means, 4 * mean, nearest=True)
    span = 4 * median0
    _, counts = percentile_histogram(
        block_means, span, nearest=True, truncate_after_quantile=True
    )

    # threshold_kernel_better estimates the noise mean from the histogram mode,
    # correcting the Gamma(16) mode by 16/15.
    maximum = max(counts)
    tied = [i for i, count in enumerate(counts) if count == maximum]
    mode = ((tied[0] + tied[-1]) / 2 + 0.5) * span / HIST_BINS
    noise_floor = mode * 16 / 15
    threshold = noise_floor * 10 ** (THR_DB / 10)
    keep = [any(p > threshold for p in powers[i:i + BLOCK]) for i in range(0, N, BLOCK)]
    return noise_floor, threshold, keep


def gammainc_p_integer16(x: float) -> float:
    """Regularized lower incomplete gamma P(16,x), via its convergent series."""
    a = 16.0
    term = 1.0 / a
    total = term
    ap = a
    for _ in range(10000):
        ap += 1
        term *= x / ap
        total += term
        if abs(term) <= abs(total) * 1e-15:
            break
    return total * math.exp(-x + a * math.log(x) - math.lgamma(a))


def gamma_median16() -> float:
    lo, hi = 0.0, 64.0
    for _ in range(100):
        mid = (lo + hi) / 2
        if gammainc_p_integer16(mid) < 0.5:
            lo = mid
        else:
            hi = mid
    return (lo + hi) / 2


def matlab_detector(fft_values: list[complex]) -> tuple[float, float, list[bool]]:
    """Mirror hist_sim.m's floor-binned median estimator for comparison."""
    powers = [value.real * value.real + value.imag * value.imag for value in fft_values]
    block_means = [sum(powers[i:i + BLOCK]) / BLOCK for i in range(0, N, BLOCK)]
    mean = sum(block_means) / N_BLOCKS
    median0, _ = percentile_histogram(block_means, 4 * mean, nearest=False)
    span = 4 * median0
    median, _ = percentile_histogram(block_means, span, nearest=False)
    noise_floor = median * 16 / gamma_median16()
    threshold = noise_floor * 10 ** (THR_DB / 10)
    keep = [any(p > threshold for p in powers[i:i + BLOCK]) for i in range(0, N, BLOCK)]
    return noise_floor, threshold, keep


def compare_frame(scene: str, targets: list[tuple[float, float, float]], seed: int) -> bool:
    print(f"\n[{scene}] generating MATLAB-style frame")
    samples = make_windowed_iq(targets, seed)
    write_plio_inputs(samples)
    run_x86sim()

    out0 = read_plio_output("temp_output0.txt")
    out1 = read_plio_output("temp_output1.txt")
    if len(out0) < N_BLOCKS // 2 or len(out1) < N_BLOCKS // 2:
        raise RuntimeError(f"mask output too short: out0={len(out0)}, out1={len(out1)}")

    expected_fft = [v / (1 << SHIFT) for v in radix2_fft(samples)]
    floor, threshold, expected_keep = aie_detector(expected_fft)
    _, _, matlab_keep = matlab_detector(expected_fft)

    mask_flags = []
    for word in out0[:N_BLOCKS // 2]:
        mask_flags.extend((word.real != 0, word.imag != 0))
    mask_zero_ok = all(value == 0 for value in out1[:N_BLOCKS // 2])
    mismatches = sum(got != expected for got, expected in zip(mask_flags, expected_keep))
    matlab_mismatches = sum(a != b for a, b in zip(mask_flags, matlab_keep))

    payload_cursors = [N_BLOCKS // 2, N_BLOCKS // 2]
    output_streams = [out0, out1]
    turn = 0
    payload_errors = []
    payload_count = [0, 0]
    for block, keep in enumerate(mask_flags):
        if not keep:
            continue
        stream_index = turn
        start = payload_cursors[stream_index]
        got = output_streams[stream_index][start:start + BLOCK]
        payload_cursors[stream_index] += BLOCK
        payload_count[stream_index] += 1
        turn ^= 1
        if len(got) != BLOCK:
            payload_errors.append(float("inf"))
            continue
        expected = expected_fft[block * BLOCK:(block + 1) * BLOCK]
        payload_errors.extend(abs(a - b) for a, b in zip(got, expected))

    kept_sequence = [keep for keep in mask_flags if keep]
    expected_payload_count = [
        sum(1 for index in range(len(kept_sequence)) if index % 2 == stream_index)
        for stream_index in (0, 1)
    ]
    lengths_ok = payload_count == expected_payload_count
    stream_lengths_ok = (
        len(out0) == N_BLOCKS // 2 + payload_count[0] * BLOCK
        and len(out1) == N_BLOCKS // 2 + payload_count[1] * BLOCK
    )
    max_error = max(payload_errors, default=0.0)
    rms_error = math.sqrt(sum(e * e for e in payload_errors) / len(payload_errors)) if payload_errors else 0.0
    ok = mismatches == 0 and mask_zero_ok and lengths_ok and stream_lengths_ok and max_error < 3.0

    print(f"  noise estimate / threshold: {floor:.3f} / {threshold:.3f}")
    print(f"  AIE-model mask mismatches:  {mismatches}/{N_BLOCKS}")
    print(f"  MATLAB-model mask mismatch: {matlab_mismatches}/{N_BLOCKS}")
    print(f"  kept blocks:                {sum(expected_keep)}/{N_BLOCKS}")
    print(f"  output samples:             {len(out0)} / {len(out1)}")
    print(f"  payload max / RMS error:    {max_error:.3f} / {rms_error:.3f} cint16 units")
    print(f"  mask stream1 zero / lengths: {mask_zero_ok} / {stream_lengths_ok}")
    print(f"  result:                     {'PASS' if ok else 'FAIL'}")
    return ok


def main() -> int:
    scenes = [
        ("noise-only-hamming", [], 31),
        ("sparse-hamming", SPARSE, 11),
        ("sparse-alt-noise-hamming", SPARSE, 23),
        ("dense-50-hamming", SPARSE + matlab_style_dense_targets(50, 551), 61),
        ("dense-200-hamming", SPARSE + matlab_style_dense_targets(200, 552), 62),
        ("dense-400-hamming", SPARSE + matlab_style_dense_targets(400, 2), 12),
    ]
    print(f"Hamming window applied before cint16 quantization (input scale={INPUT_SCALE}).")
    results = [compare_frame(*scene) for scene in scenes]
    print(f"\nSuite: {sum(results)}/{len(results)} scenes passed")
    return 0 if all(results) else 1


if __name__ == "__main__":
    raise SystemExit(main())

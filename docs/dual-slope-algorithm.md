# Dual-slope range and velocity — the algorithm in plain steps

This is the pairing procedure I mean, written so it can be handed to whoever
writes the code. It is a *proposal*, not something that has been run on
hardware.

Working point used in all the numbers below: 1550 nm, 2048 range bins,
128 chirps per slope, `B = 2.880 GHz`, `fs = 0.98 GS/s`,
`T = 2.0898 us`, `R_nyq = 106.59 m`, `dR = 5.205 cm`.

---

## 0. Words and signs

* A **chirp** is one ramp. **Up** chirps have rising frequency, **down**
  chirps have falling frequency. We alternate: up, down, up, down, ...
* **Positive velocity = approaching** (range getting smaller).
* For an approaching target the Doppler shift `f_D = 2v/lambda` is positive.
  The beat tone is
  ```
  up chirp:    f_up = f_R - f_D      -> peak sits BELOW the true range bin
  down chirp:  f_dn = f_R + f_D      -> peak sits ABOVE the true range bin
  ```
* A **detection** is one peak after the range FFT, the threshold and the
  128-chirp AND. It has five numbers: range bin, Doppler bin, azimuth,
  amplitude, and which slope it came from.

---

## 1. What the hardware hands you

Two sparse maps, one per slope, each `2048 range x 128 Doppler`:

```
   up chirps  (128)  ->  range FFT  ->  threshold  ->  AND  ->  up map
   down chirps (128) ->  range FFT  ->  threshold  ->  AND  ->  down map
```

Each map has its own Doppler FFT. The Doppler axis is **the same in both
maps**, because the slow-time phase step `4 pi v T / lambda` does not depend
on the slope sign. That is the fact the whole algorithm rests on.

---

## 1a. Where this sits, and what it does NOT add

The algorithm adds **no new threshold**. It consumes the detections the chain
already produces. The existing chain has three detection stages:

| stage | what it is | where |
|---|---|---|
| range | 16-bin block mean, one mask bit per 16 bins, 8.393 dB margin, Gamma(16) statistics | AIE threshold kernel |
| persistence | AND of that mask across 128 chirps (per slope) | `doppler_part.cpp` |
| Doppler | 64-bin histogram per range bin, median, x 8.393 dB | `doppler_part.cpp` |

The range stage *is* a cell-averaging detector: the 16-bin block is the
reference window. It has no guard cells and it is coarse, but it is adaptive
to local noise, so "CFAR" in the loose sense, not a textbook two-parameter
CA-CFAR. The AND is what actually makes the gate selective.

Full order of operations, with the association marked:

```
for each of the 128 seq slots (array elements):
    ADC -> range FFT 2048 -> block threshold -> mask
        -> AND over 128 chirps of that slope
        -> Doppler FFT 128 (one per surviving range bin) -> median threshold

all 128 seqs -> angle FFT 128 (across the seq axis)

detections: (range bin, Doppler bin, azimuth bin, amplitude, slope)
        |
        +--> ASSOCIATE up <-> down on (Doppler, azimuth) cells, 2-bin comb
        |
        v
point cloud: (R, v, azimuth, amplitude)
```

Three things this makes explicit:

* You do **not** pick one receiver. The 128-point angle FFT sums all `seq`
  slots coherently and turns them into an azimuth, so a detection is a
  (range, Doppler, azimuth) triple. Association happens *after* that, so it is
  never a cross-receiver matching problem.
* You do **not** pick one range-Doppler cell. Every detection goes into a
  bucket; empty buckets cost nothing; the loop is over the sparse list.
* The bucket is `(Doppler cell, azimuth cell)`, not Doppler alone. That is a
  128 x 128 key space, which is why a bucket almost always holds one target.

Caveat on the current build: `angle_part.cpp` is still a dummy sink, the
128-point FFT graph is not wired into the testbench, and only `seq = 0` is
used. So today there is no azimuth and the bucket degenerates to Doppler
alone. The azimuth gate is one of the things that must be built.

## 2. The only three numbers you need

| Name | Value | Meaning |
|---|---:|---|
| `dR` | 5.205 cm | metres per range bin |
| `v_step` | 185.4 mm/s | one-sided slow-time velocity span, `lambda/(4T)` |
| `P` | 370.85 mm/s | the velocity alias period, `2 * v_step` |

Two one-line conversions, no trigonometry, no matrix:

```
v = (b_down - b_up) * v_step
R = ((b_up + b_down) / 2) * dR
```

where `b_up` and `b_down` are the two peak positions in range bins.

The `R` formula works because the Doppler shift adds on one slope and
subtracts on the other, so the average is exactly the true range. The `v`
formula works because the difference is twice the Doppler shift.

---

## 3. The key trick: the detection already knows the hard part

This is the part that makes it cheap. Read it twice.

`v = (b_down - b_up) * v_step`, so the separation is just `v` in different
units:

```
separation_in_bins = 2 * v / P
```

Now, every detection already carries a Doppler bin. That Doppler bin measures
`v` **modulo `P`** — it is an alias tag, not a speed. So it tells you the
separation **modulo 2 bins**.

Write `u` for the velocity modulo one period, `0 <= u < P`, taken from the
detection's own Doppler. Then

```
separation = 2u/P + 2m ,    m = any whole number
```

The first term is known exactly (it is in `[0, 2)`). Only the whole number
`m` is unknown. So:

> **The down-chirp partner of an up-chirp peak lies on a comb with spacing
> exactly 2 range bins, and the comb's offset is known from the up peak's own
> Doppler.**

You do not search for a shift. You do not cross-correlate. You look at the
handful of down peaks in the same Doppler cell and ask which one sits on the
comb.

---

## 4. The steps

**Step 1 — split.** Collect the up chirps into one sub-frame and the down
chirps into another. 128 chirps each.

**Step 2 — range.** For every chirp, 2048-point range FFT (the existing AIE
kernel). Threshold. AND across the 128 chirps of that sub-frame. Keep only
surviving cells. Result: two short lists of (range bin, amplitude).

**Step 3 — Doppler.** 128-point Doppler FFT per sub-frame (zero-padded to 256
in the existing IP). Threshold. Attach to each detection: Doppler bin,
azimuth bin from the angle FFT, amplitude, slope.

**Step 4 — bucket.** Sort all detections into 128 buckets by Doppler cell.
A bucket is `2.90 mm/s` wide. Detections of the *same physical target* always
land in the same bucket in both maps.

**Step 5 — comb test.** For each **up** detection in a bucket, and for each
**down** detection in the same bucket:
```
u    = its Doppler velocity, folded into [0, P)
f    = 2*u/P                       # known fractional part, in [0,2)
sep  = b_down - b_up
m    = round((sep - f) / 2)
resid= sep - f - 2*m               # should be ~0
```
Accept the candidate if `|resid| < 0.15` bins, `|v| <= v_design`, and the
azimuths agree to within one angle bin.

**Step 6 — pick.** Usually exactly one candidate passes. If two pass, take the
one with the smaller `|resid|` and the closer azimuth. If still tied, drop
both (see §7).

**Step 7 — solve.** With the pair found:
```
v = (b_down - b_up) * v_step        # already un-aliased
R = ((b_up + b_down) / 2) * dR
```
This `v` is correct to roughly a tenth of a bin, i.e. a few mm/s.

**Step 8 — refine (optional).** The Doppler value `u` is far more precise
(sub-millimetre/s) but wraps every `P`. Snap it:
```
v = u + P * round((v - u) / P)
```
Because the coarse `v` is good to a few mm/s and `P/2` is 185 mm/s, the
rounding cannot pick the wrong wrap.

**Step 9 — output.** Emit one point per pair: `(R, v, azimuth, amplitude)`.
Discard unpaired detections.

---

## 5. Worked example: one car, 100 m, 30 m/s

| quantity | value |
|---|---:|
| true range bin, `R / dR` | 1921.33 |
| separation, `2v/P` | 161.79 bins |
| up peak `b_up` | **1840.43** |
| down peak `b_dn` | **2002.22** |
| Doppler `u` | 332.0 mm/s |
| bucket | 114.6 |
| fractional part `f = 2u/P` | 1.7907 |

Check the comb: `(161.79 - 1.7907)/2 = 80.0` — a whole number. So `m = 80`.

Solve: `v = 161.79 * 185.4 mm/s = 30.00 m/s`,
`R = 1921.33 * 5.205 cm = 100.00 m`.

Refine: `u + P*round((30.000 - 0.332)/0.37085) = 0.332 + 80*0.37085 = 30.000`.

Nothing was searched. Two subtractions, one divide, one round.

---

## 6. Worked example: two cars in the same bucket

Car A: 100.0 m, 30.000 m/s. Car B: 60.0 m, 30.371 m/s — exactly one alias
period faster, so the Doppler cannot tell them apart.

| | A | B |
|---|---:|---:|
| up peak | 1840.43 | 1070.90 |
| down peak | 2002.22 | 1234.69 |
| Doppler `u` | 332.0 mm/s | 332.0 mm/s |
| bucket | 114.6 | 114.6 |

Test A's up peak (1840.43, `f = 1.7907`) against both down peaks:

* to A's down, 2002.22: `sep - f = 161.79 - 1.7907 = 160.00` → `m = 80`,
  residual **0.00 bins** → **MATCH**.
* to B's down, 1234.69: `sep - f = -605.74 - 1.7907 = -607.53` → nearest
  even number is -608, residual **0.47 bins** → **REJECT**.

So the pair is unique, and the second car is found the same way. The bucket
held two targets and still no combinatorial search: 2 comparisons.

For scale: 400 detections, 128 buckets, ~3 detections per bucket, about
**1 250 comparisons per frame**. Full M² pairing would be 160 000. The FFTs
in the same frame are about 5.8 million operations.

---

## 7. What the leftovers mean

* An **up peak with no acceptable down partner** is not a target. Either it
  faded on the other slope, or it is a threshold false alarm. Do not report
  it.
* A **down peak with no up partner** — same, do not report it.

This is a free bonus: the dual slope acts as a **coincidence filter**. A noise
spike has to appear at the right place, on the right comb, in both maps at
once. The false-alarm rate of the point cloud drops, even though each
individual map has the same false-alarm rate as today.

---

## 8. Where it can still fail

1. **Two objects at the same range, exactly one alias period apart in
   velocity.** Then both pairings land on the comb (the wrong one gives
   `R` off by half a bin) and the ranges are already the same, so range does
   not separate them. Only azimuth does. This is the one true degeneracy.
2. **Periodic scene.** Cars in a queue, evenly spaced, all at the same speed
   produce a comb that matches itself. Azimuth and amplitude resolve it;
   range alone cannot.
3. **Bucket boundary.** A target whose velocity is near a bucket edge may
   appear in bucket `j` or `j+1`. Harmless: the comb offset differs by 0.016
   bins between neighbouring buckets. Test both, or just use the continuous
   Doppler value `u` instead of the integer bucket.
4. **Down peak past Nyquist.** At 100 m the down-chirp beat reaches `fs`
   already at 30 m/s. Size the waveform for 35 m/s (`B = 2.880 GHz`, as used
   here) so the down peak stays inside bin 2048.
5. **Noise on the peak position.** `b_u` and `b_d` come from interpolating
   the range peak (parabolic or centroid). The comb test needs about 0.1 bin,
   which is what interpolation gives. Without interpolation, a 1-bin error
   makes the residual test meaningless.

---

## 9. Pseudocode

```python
dR     = 0.05205        # metres per range bin
v_step = 0.18543        # m/s per unit of separation
P      = 0.37085        # m/s, alias period

def fold(v):                      # velocity -> [0, P)
    return v - P * floor(v / P)

def associate(up, down):
    pairs = []
    buckets = {b: [] for b in range(128)}
    for d in up:   buckets[d.doppler_bin].append(d)
    for d in down: buckets[d.doppler_bin].append(d)   # tag each as up/down

    for b, items in buckets.items():
        ups   = [d for d in items if d.slope == "up"]
        downs = [d for d in items if d.slope == "down"]

        for a in ups:
            f = 2 * fold(a.v_doppler) / P             # known, in [0,2)
            best, best_resid = None, 0.15
            for c in downs:
                sep   = c.range_bin - a.range_bin
                m     = round((sep - f) / 2)
                resid = abs(sep - f - 2*m)
                if resid < best_resid and angle_ok(a, c):
                    best, best_resid = c, resid
            if best is not None:
                pairs.append((a, best))
    return pairs

def solve(a, c):
    sep = c.range_bin - a.range_bin
    v   = sep * v_step
    R   = 0.5 * (a.range_bin + c.range_bin) * dR
    v   = fold(a.v_doppler) + P * round((v - fold(a.v_doppler)) / P)   # refine
    return R, v
```

---

## Appendix: if you drop the Doppler axis

You can. Aggregate each sub-frame over its 128 chirps and you get two plain
2048-cell range profiles instead of two maps. But then the comb offset `f` is
unknown and you must search over it, which is exactly the expensive
"find the shift" you objected to.

**The Doppler axis is what makes the association cheap.** It is not a luxury;
it is the thing that hands you the fractional part of the separation for free.

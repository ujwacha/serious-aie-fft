# FMCW lidar waveform: 100 m range, automotive velocity, dense scenes

**Briefing for an external reviewer.** This is my current design position on the
waveform and the range/velocity processing for an FMCW lidar. I want you to
attack it. Everything below is analysis and simulation; nothing has been run on
hardware except where I say "measured".

I have written it in the order I actually arrived at it, including the wrong
turns, because two of my earlier conclusions were wrong and I would rather you
saw the corrections than rediscovered them.

---

## 0. Quick facts

| | |
|---|---|
| Sensor | FMCW lidar, coherent, I/Q, single static scene per CPI |
| Wavelength | **1550 nm** now; the existing repo and all earlier numbers are 1153 nm |
| Digital chain | **fixed**: 2048-pt range FFT, 256-pt Doppler FFT, 128-pt angle FFT |
| Cube | 128 seq (array) x 2048 range x 256 chirps, cint16, 256 MiB per cube, 3 cubes |
| Target | **100 m unambiguous range**, velocity "better than ±0.281 m/s", ideally 30 m/s at 100 m |
| Scene | dense: hundreds of targets, queue of cars, guardrails |
| Hard requirement | measured velocity must be good enough to **remove the Doppler-induced range-bin shift** |
| What I want from you | whether the association step is sound and cheap, and whether I should keep dual slope at all |

---

## 1. The sensor and the fixed digital chain

FMCW, sawtooth chirps, one chirp = 2048 samples, 256 chirps per CPI. The receive
array has 128 elements (or virtual elements; `kSeqs = 128` in the data layout).
Range and Doppler are processed per array element; a 128-point FFT runs across
the element axis to produce azimuth.

The chain is HLS on the PL plus AIE kernels, and I cannot change the FFT sizes:

```
ADC -> 11-port HLS kernel
    -> AIE 2048-pt range FFT               (TP_SHIFT = 11)
    -> range threshold (16-bin block mean, 8.393 dB)
    -> sparse range cube in DRAM
    -> persistence AND over chirps
    -> AIE 256-pt Doppler FFT              (TP_SHIFT = 4)
    -> Doppler threshold (64-bin histogram -> median -> 8.393 dB)
    -> sparse Doppler cube
    -> AIE 128-pt angle FFT                (TP_SHIFT = 7)   [not wired yet]
```

The three cubes are `[seq][chirp][range]`, `[seq][range][chirp]` and the angle
cube, each 2048 x 256 x 128 cint16.

Two details that matter later:

* The range threshold is a **cell-averaging detector**: the 16-bin block is the
  reference window, one mask bit per block, no guard cells, Gamma(16)
  statistics. Coarse, but it adapts to local noise.
* The **persistence AND** across all chirps is what actually makes the range
  gate selective. The block threshold alone lets about 21 % of cells through.

---

## 2. The current waveform, and what is actually measured

| Parameter | Value |
|---|---:|
| Wavelength | 1153 nm |
| Sweep bandwidth `B` | 1.0 GHz |
| Sample rate `fs` | 2 GS/s |
| Chirp time `T = 2048/fs` | 1.024 us |
| Chirps per CPI | 256 |
| CPI | 262.1 us |
| Range resolution `c/2B` | 14.99 cm |
| Max unambiguous range | 307.0 m |
| Velocity resolution `lambda/(2 CPI)` | 2.199 mm/s |
| **Unambiguous velocity `lambda/(4T)`** | **+-0.281 m/s** |

**Measured** (this is real, on the AIE simulator + golden fixed-point model):
one physical 1153 nm target at 44.97 m and +14.07 cm/s; all-cell power
correlation 0.999999998 against the golden model; 878 of 4096 Doppler cells
written (21.4 %).

So the chain is verified. The *waveform* is not, because the waveform only
supports +-0.281 m/s.

---

## 3. What I am trying to fix

Three requirements, in the order they arrived:

1. **100 m unambiguous range.** Currently 307 m, but I do not need that; I need
   range resolution around 5 cm.
2. **Velocity better than +-0.281 m/s.** In practice I want an automotive span,
   so 30 m/s at 100 m is the number I have been designing to.
3. **The velocity must be good enough to correct the range bias caused by
   Doppler.** This is the one that constrains everything.

For (3), at 1550 nm, a target at 30 m/s shifts the range peak by
`k*v` where `k = cT/(lambda*B)`. With a dual-slope design at 0.98 GS/s that is
about **4.1 m, or 81 range bins**. So the check is: how accurately do I need to
know `v`?

| residual range error | required velocity accuracy |
|---|---:|
| 1 bin (5.08 cm) | 0.371 m/s |
| 1/2 bin (2.54 cm) | 0.185 m/s |
| 1 cm | 0.073 m/s |
| 1 mm | 7.3 mm/s |

---

## 4. Why bandwidth cannot fix the velocity span

Per chirp, the beat of a target at range `R` is `f_R = 2BR/(cT)`, and motion adds
`f_D = 2v/lambda`. Chirp to chirp the phase of the range-compressed signal
advances by `4*pi*v*T/lambda`, so

```
v_unamb = lambda / (4T) = lambda * fs / (4 * N_range)
```

Bandwidth does not appear. With `N_range = 2048` fixed, the only lever is `fs`:

| fs | T | v_unamb (one-sided) | velocity resolution |
|---:|---:|---:|---:|
| 1 GS/s | 2.048 us | 0.141 m/s | 1.10 mm/s |
| 2 GS/s | 1.024 us | 0.281 m/s | 2.20 mm/s |
| 5 GS/s | 0.410 us | 0.704 m/s | 5.50 mm/s |
| 10 GS/s | 0.205 us | 1.407 m/s | 11.0 mm/s |

(those are 1153 nm numbers; at 1550 nm they are 1.34x larger).

Reaching 30 m/s this way needs **fs = 213 GS/s**. That is not a lidar front end.
And note it *degrades* velocity resolution, because the CPI gets shorter.

So the span has to come from the beat frequency itself, not from chirp-to-chirp
phase.

---

## 5. Things I have already ruled out (please tell me if I am wrong)

**5.1 A nonlinear / quadratic chirp.** Encode range in the beat's chirp rate and
Doppler in its offset, so one peak gives both. The information requirement kills
it: to get one bin of beat chirp you need a quadratic sweep of `c/(4R)`, which is
0.75 MHz at 100 m — about one bin. The range estimate would then rest on
resolving a one-bin curvature. Bad conditioning. Rejected.

**5.2 Two slopes with the same sign but different magnitudes.** Write
`f = 2sR/c - f_D` for slope `s`. Two slopes `s1, s2` with the same sign give
`R` from the difference, with no up/down pairing. But the range accuracy becomes
`dR ~ c*df/(2|s1-s2|)`, with `df` one range bin. To hold 5 cm you need
`|s1-s2| ~ s`, i.e. the slopes must differ by ~100 %, and then the two peaks sit
about a full range window apart (~1900 bins at 100 m), so the pairing problem is
back and worse. There is a trade between conditioning and peak separation, and
the anti-symmetric pair (`+s, -s`) is the optimum: it gives the best conditioning
and puts the peaks only `2*f_D` apart. So: rejected, and I think this is a
genuine no-free-lunch result.

**5.3 Staggered PRF / staggered chirp duration.** The classic radar trick: two
different chirp times give two different alias resolutions. It extends the span
by the ratio of the two PRFs. To get 30 m/s from 0.185 m/s you would need a ratio
of ~162. Rejected.

**5.4 Pairing peaks by searching for the shift between the up and down range
profiles.** This is what I originally assumed was needed and I do not want it:
for every up peak, search the down profile for the best translation. In a dense
scene that is O(M^2). This is the thing I am trying to avoid. See §9 for what
replaced it.

**5.5 Looking up the up/down offset per Doppler bin.** My first attempt. I
claimed the offset `d(v)` is known per Doppler bin, so association is a hash
lookup. **That was wrong.** The Doppler bin only tells you `v mod 0.371 m/s`, and
one alias step moves the offset by 2 range bins. The offset is *not* known; it is
what you are solving for. I now use a comb test instead, which is the subject of
§9. Please check that this one is right.

---

## 6. The structural identity I keep running into

Let `k = cT/(lambda*B)` (metres of apparent range shift per m/s) and
`v_step = lambda/(4T)` (the one-sided slow-time span). Then

```
k * v_step = c/(4B) = dR / 2
```

independent of wavelength and sample rate. One alias step of velocity equals
**exactly one range bin**. So range and velocity ambiguity are not independent
problems on a lattice; they are the *same* lattice. Consequences:

* To correct range to half a bin you need velocity to exactly `v_step`, which is
  precisely the thing the slow-time channel cannot resolve without help.
* You cannot bootstrap: the aliased Doppler cannot repair the bias it causes.
* Any second observable that gives you `v` un-aliased to better than `v_step`
  solves range correction at the same time.

That is the argument for having two slopes at all, and it is also why I am
suspicious of the "single slope + tracker" option (§8) — the tracker breaks the
bootstrap, but it does so by introducing an object-level assumption rather than a
waveform-level one.

---

## 7. Option A: dual slope (alternate up/down chirp)

### 7.1 The measurement

```
up chirp:    f_up = f_R - f_D
down chirp:  f_dn = f_R + f_D

R = cT(f_up + f_dn) / (4B)
v = lambda (f_dn - f_up) / 4
```

In range bins, with `b_up` and `b_dn` the two peak positions:

```
v = (b_dn - b_up) * lambda/(4T)
R = ((b_up + b_dn)/2) * dR
```

No trigonometry, no matrix. The average gives range because the Doppler adds on
one slope and subtracts on the other; the difference gives velocity.

### 7.2 The envelope is triangular (this is the price)

With complex sampling the beat must stay in `[0, fs]`:

```
f_D <= f_R     and     f_D <= fs - f_R
v_max(R) = (lambda*fs/2) * min(r, 1-r),    r = R/R_nyq
```

Peaks at `lambda*fs/4` at half the unambiguous range and collapses to zero at
both ends. **High velocity is only unambiguous in the middle of the range
window.** At 1 m the envelope is only 5.3 m/s. Near-range targets are slow in
practice, but a 30 m/s closing target at 3 m would alias.

### 7.3 Numbers at 1550 nm, fs = 0.98 GS/s, 30 m/s at 100 m

| | value |
|---|---:|
| Bandwidth | 2.949 GHz |
| Range resolution | 5.084 cm |
| Nyquist range | 104.11 m |
| Chirp time | 2089.8 ns |
| `v_max` at 100 m | 30.0 m/s |
| Peak `v_max` (52 m) | 379.8 m/s |
| Doppler shift at 30 m/s | 38.7 MHz (80.9 bins) |
| Coupling `k` | 0.1371 m per m/s |
| Bias at 30 m/s | 4.11 m (80.9 bins) |
| Slow-time span `v_step` | +-0.1854 m/s |
| Alias period `P = 2*v_step` | 0.3709 m/s |
| Fine `dv` (slow time) | 1.449 mm/s |

At 1153 nm the same design gives B = 2.907 GHz, dR = 5.156 cm, peak 282.5 m/s,
`k = 0.1869`, bias 5.61 m, span +-0.1379 m/s, fine dv 1.078 mm/s.

### 7.4 The cost

* Two sub-frames per CPI: 128 up chirps and 128 down chirps. The 256-chirp AND
  becomes 128, so it is less selective.
* Two Doppler passes instead of one (same total data, twice the FFT
  invocations). The graph already has a 128-point FFT, currently aimed at the
  angle stage — it is exactly the size a 128-chirp Doppler pass wants. That
  means either time-sharing it or zero-padding to the 256-point kernel.
* The up and down range peaks land up to 162 bins apart at 30 m/s, so a single
  256-chirp Doppler FFT would see the signal jumping between two range bins.
  Hence the sub-frames. (At 0.98 GS/s the two peaks are 4.1 m apart at 30 m/s —
  the same 81 bins each side.)
* The down-chirp beat hits `fs` at exactly 100 m / 30 m/s. I size for 35 m/s
  (`B = 2.880 GHz`, Nyquist 106.6 m) so it stays inside the window. Costs 0.5 %
  of range resolution.

---

## 8. Option B: single slope, fast ADC, tracker

If the ADC can go to 10 or 20 GS/s, one slope is enough for the *coupling*
because `k` is proportional to `T`: shorter chirps mean less range bias.

`B = 3.07 GHz` (Nyquist 100 m), 1550 nm:

| fs | T | v_unamb | alias period | k (m per m/s) | bias at 30 m/s | residual at dv = 1.5 m/s |
|---:|---:|---:|---:|---:|---:|---:|
| 2 GS/s | 1024 ns | 0.378 | 0.757 | 0.0645 | 1.94 m | 1.98 bin (9.7 cm) |
| 5 GS/s | 410 ns | 0.946 | 1.892 | 0.0258 | 0.77 m | 0.79 bin (3.9 cm) |
| 10 GS/s | 205 ns | 1.892 | 3.784 | 0.0129 | 0.39 m | 0.40 bin (1.9 cm) |
| 20 GS/s | 102 ns | 3.784 | 7.568 | 0.0065 | 0.19 m | 0.20 bin (1.0 cm) |

The idea: never unwrap, just correct range with the tracker's object velocity:

```
R = (b_measured * dR) + k * v_tracker
```

Residual is `k * dv_tracker`.

This deletes the second sub-frame, the second threshold pass, the halved
integration and the association entirely. It makes range accuracy depend on the
tracker's velocity accuracy (~1.5 m/s frame to frame at 30 ms, better with
smoothing).

**Where I am unsure:** at 10 GS/s the chirp is 15 GHz/us and the beat at 100 m
sits exactly at Nyquist. Both are aggressive. And the whole thing rests on the
tracker, which does not exist yet, and which fails at scene entry (a new object
has no history, so its first frame has no velocity, so its range is biased by up
to 6 bins).

That last point is why I have not simply chosen Option B.

---

## 9. The association algorithm (the part I want reviewed)

This replaces 5.4. The claim is that association is **O(M)**, not O(M^2), and
that it is a comb test rather than a shift search.

### 9.1 The key observation

`v = (b_dn - b_up) * v_step`, so the peak separation *is* the velocity:

```
separation_in_bins = 2 * v / P
```

Every detection already carries a Doppler bin. The slow-time phase step is
`4*pi*v*T/lambda`, which depends on the **carrier**, not the modulation — so the
same target lands in the **same Doppler bin in both the up and down maps**. That
is exact, not a heuristic. The Doppler measures `v mod P`.

Therefore it gives the separation **modulo 2 bins**:

```
separation = 2u/P + 2m,    u = own Doppler velocity folded into [0, P),  m integer
              ^^^^ known
```

The first term is known exactly and lies in `[0, 2)`. Only the whole number `m`
is unknown. So:

> The down-chirp partner of an up peak lies on a **comb with 2-bin spacing whose
> offset is known from the up peak's own Doppler**. You do not search for a
> shift; you resolve one integer.

### 9.2 Steps

1. Split chirps: 128 up, 128 down.
2. Range FFT per chirp, block threshold, AND across the 128 chirps of that slope.
3. Doppler FFT per sub-frame; attach Doppler bin, azimuth, amplitude, slope.
4. Bucket detections by `(Doppler cell, azimuth cell)`. Cells are 2.90 mm/s wide
   and 1 angle bin; the key space is 128 x 128 and sparsely filled.
5. For each up/down pair in a bucket:
   ```
   f     = 2u/P
   m     = round((sep - f)/2)
   resid = sep - f - 2m           accept if |resid| < ~0.15 bins
   ```
   plus `|v| <= v_design` and azimuth agreement.
6. Solve `v` and `R`, then refine `v` by snapping the fine Doppler:
   `v = u + P*round((v - u)/P)`. The coarse `v` is good to a few mm/s and `P/2`
   is 185 mm/s, so the snap cannot pick the wrong wrap.

### 9.3 Worked example (1550 nm, B = 2.880 GHz, dR = 5.205 cm)

One car at 100.0 m, 30.0 m/s:

| | value |
|---|---:|
| true range bin | 1921.33 |
| separation | 161.79 bins |
| up peak | **1840.43** |
| down peak | **2002.22** |
| Doppler `u` | 332.0 mm/s |
| `f = 2u/P` | 1.7907 |

`(161.79 - 1.7907)/2 = 80.0` -> whole number, `m = 80`.
`v = 161.79 * 185.4 mm/s = 30.00 m/s`, `R = 1921.33 * 5.205 cm = 100.00 m`.

Two cars in the *same* Doppler bucket (A at 100.0 m / 30.000 m/s, B at 60.0 m /
30.371 m/s — exactly one alias period apart):

| | A | B |
|---|---:|---:|
| up peak | 1840.43 | 1070.90 |
| down peak | 2002.22 | 1234.69 |

Testing A's up peak against both down peaks:

* to A's down: `sep - f = 160.00` -> `m = 80`, residual **0.00** -> match
* to B's down: `sep - f = -607.53` -> nearest even is -608, residual **0.47** ->
  reject

Unique pair, two comparisons.

### 9.4 Cost

400 detections, 128 Doppler buckets (x azimuth), ~3 detections per bucket:
about **1250 comparisons per frame**, versus 160 000 for M^2 pairing and about
5.8 M operations of FFT work in the same frame. So the association is ~0.02 % of
the frame.

### 9.5 Free side effect

An up peak with no acceptable partner is not reported. A noise spike has to
appear at the right range, on the right comb, in *both* maps to survive. So the
dual slope acts as a **coincidence filter** and the point-cloud false-alarm rate
drops, even though each map's own threshold is unchanged.

### 9.6 Failure modes I know about

1. **Two objects at the same range whose speeds differ by exactly one alias
   period (0.371 m/s).** Both pairings land on the comb, the wrong one gives `R`
   off by half a bin, and the ranges were already the same, so range cannot
   separate them. Only azimuth can. This is a genuine degeneracy, not hand-waving.
2. **Periodic scene.** A queue of cars evenly spaced at the same speed produces a
   comb that matches itself. Azimuth and amplitude are the disambiguators.
3. **Bucket boundary.** A target near a bucket edge may appear in `j` or `j+1`.
   Harmless: the comb offset differs by 0.016 bins between neighbours. Test both
   or use the continuous Doppler value rather than the integer bucket.
4. **Peak-position noise.** The comb test needs ~0.1 bin, which requires
   interpolating the range peak (parabolic or centroid). A raw integer bin makes
   the residual test meaningless.
5. **Angle stage not built.** Right now `angle_part.cpp` is a dummy sink, the
   128-point FFT graph is not wired, and only `seq = 0` is used. So today there
   is no azimuth, and the bucket degenerates to Doppler alone. That makes failure
   mode 1 worse, not better.

---

## 10. What I got wrong along the way (so you do not repeat it)

1. I claimed the up/down offset is known per Doppler bin and association is a
   lookup. Wrong: the bin only gives `v mod P`, and one alias step moves the
   offset by 2 bins. Replaced by the comb test in §9.
2. I described the two maps as 2D (2048 x 128). They are 3D: `seq x range x
   Doppler`, and the angle FFT collapses `seq` into azimuth. So the association
   key is `(Doppler, azimuth)`, and it is never a cross-receiver match.
3. I initially wrote that the alternating slopes move the peak between range
   bins "so the Doppler FFT breaks". That is right, but the fix is sub-frames
   (§7.4), not compensating the shift before the Doppler FFT.
4. I said 30 m/s at 100 m sits on the envelope. True, and it means the down-chirp
   beat is exactly at `fs`, so the waveform must be sized for 35 m/s.

---

## 11. Status of the repo, and known inconsistencies

* `docs/waveform-design.md` / `.tex` / `.pdf`: the long-form design note. Still
  **1153 nm** throughout.
* `docs/dual-slope-algorithm.md`: the algorithm in §9, with pseudocode.
* `tb/waveform_optimizer.py`: the design-space sweep. `LAM = 1153e-9` is
  hardcoded; it needs a `--wavelength` flag before any 1550 nm number is
  reproducible.
* The `b_for_dual()` docstring says `q = 4v/(lambda*fs)` but the code uses
  `q = 2v/(lambda*fs)`, which is the correct one. A docstring bug.
* `tb/rd_test.py`: scene generator and golden model, 1153 nm, 1 GHz, 2 GS/s.
  The `moving` scene passes on hardware-model correlation.
* The measured 21.4 % Doppler write fraction, the 8.393 dB constants and the
  `TP_SHIFT` values are all for the current 1 GHz / 2 GS/s waveform, not for any
  of the proposals here.

---

## 12. Validation plan (cheap to expensive)

1. Add `--wavelength` to the optimizer, re-run at 1550 nm, check the numbers in
   §7.3.
2. Build a Python dual-slope model: split chirps, two range FFTs, threshold,
   comb association, `R`/`v`. Compare with truth for 1, 2 and 4 targets.
3. Run the same scene through the fixed-point golden model and confirm the
   slow-time phase is really slope-independent.
4. Measure the ghost rate versus target density and SNR, especially failure mode
   9.6.1. This is the experiment that decides whether the dual slope survives.
5. Re-measure threshold selectivity and DRAM traffic for 128-chirp sub-frames.
6. Only then talk about the laser: 2.9 GHz of linear sweep in 2.09 us at 1550 nm,
   coherent over the CPI.

---

## 13. Questions I actually want answered

1. Is the comb test in §9.1 sound once you put realistic peak-interpolation noise
   on `b_up`, `b_dn` and `u`? What does the residual distribution look like, and
   is a 0.15-bin gate right, or should the gate scale with SNR?
2. Is the same-range / one-alias-period degeneracy (9.6.1) acceptable for an
   automotive product, or does it force a third slope? A third slope doubles the
   sub-frame count again.
3. Is 2 x 128-chirp sub-framing better than one 256-chirp CPI with slope-tagged
   chirps and a per-slope Doppler pass afterwards? The second keeps the AND at
   256 but complicates the sparse cube.
4. Does halving the AND length break the Gamma(16) / median threshold
   assumptions, and by how much does the false-alarm rate move?
5. Given a 1550 nm source and an unknown ADC ceiling, would you pick dual slope
   at 0.98 GS/s (association, small ADC) or single slope at 10 GS/s + tracker
   (no association, big ADC, no velocity at scene entry)? What is the decisive
   number?
6. Is a 2.9 GHz sweep in 2.09 us realistic at 1550 nm, and does the linearity
   support 5 cm range resolution without resampling?
7. What is the realistic CRLB for the dual-slope velocity estimate at, say,
   10 dB SNR over 128 pairs? My 24 mm/s figure is a `1/sqrt(N)` scaling guess,
   not a CRLB.
8. Should the angle FFT run before association (as I assume), or is it cheaper
   to associate per array element and only then form azimuth? The first needs the
   angle cube to be populated for every surviving cell; the second does 128x the
   pair tests but no angle cube.
9. The range correction needs `v` to about `v_step`. Is 0.4 bin (single-slope
   10 GS/s + tracker) actually good enough in practice, or does an automotive
   sensor need the 0.2 mm the dual-slope fine Doppler gives?
10. Is there a waveform I have missed that gets un-aliased velocity without
    either two slopes or a fast ADC? I have argued no (§5.2), but I would like
    that argument attacked specifically.

---

## Appendix A: formulas

```
f_R        = 2 B R / (c T)
f_D        = 2 v / lambda
R_nyq      = N_range c / (2 B)
dR         = c / (2 B)
T          = N_range / fs
v_step     = lambda fs / (4 N_range) = lambda / (4 T)
P          = 2 v_step                  (velocity alias period)
k          = c T / (lambda B)          (m of range bias per m/s)
v_slow     = v_step                    (one-sided)
dv_slow    = lambda / (2 N_chirps T)
v_dual(R)  = (lambda fs / 2) min(R/R_nyq, 1 - R/R_nyq)
separation = 2 v / P  (range bins)
k * v_step = dR / 2                    (the lattice identity)
```

## Appendix B: numbers used in §9

```
lambda      1550 nm
B           2.880 GHz        (sized for 35 m/s at 100 m)
fs          0.980 GS/s
T           2089.8 ns
N_range     2048
N_chirps    128 per slope
dR          5.205 cm
R_nyq       106.59 m
range bin   478.5 kHz
k           0.14035 m per m/s
v_step      185.425 mm/s
P           370.85 mm/s
Doppler cell 2.897 mm/s (128-point FFT)
```

Numbers for the exactly-30 m/s design (`B = 2.949 GHz`, Nyquist 104.11 m,
dR = 5.084 cm, k = 0.1371) differ by ~1 %; I use 2.880 GHz everywhere in the
algorithm because it keeps the down-chirp beat inside the window.

## Appendix C: files

| File | What it is |
|---|---|
| `docs/waveform-design.md` | long-form design note, 1153 nm |
| `docs/dual-slope-algorithm.md` | the association algorithm with pseudocode |
| `tb/waveform_optimizer.py` | design-space sweep, Pareto front, trade-off plot |
| `tb/rd_test.py` | scene generator, golden fixed-point model, checks |
| `src/range_part.cpp` | range FFT handoff, mask, DRAM writes |
| `src/doppler_part.cpp` | persistence AND, Doppler median threshold |
| `src/angle_part.cpp` | currently a dummy sink |
| `fft_accelerator_component/src/graph.h` | AIE graphs: 2048 / 256 / 128-point FFTs |

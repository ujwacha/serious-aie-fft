#!/usr/bin/env bash
#
# Run the full range-Doppler chain test.
#
#   ./tb/run_test.sh                    # one 2048 x 256 frame, scene "rd"
#   SCENES="rd dense" ./tb/run_test.sh  # several scenes
#   CHIRPS=256 ./tb/run_test.sh         # must be 256 for one RD frame
#
# Each scene:
#   1. tb/rd_test.py --generate writes a float range-Doppler scene and
#      quantises it to int16 ADC samples.
#   2. hls.sh csim runs the HLS kernel.  Its testbench calls the 2048-point
#      range AIE, lets tb/rd_test.py build the 256-point Doppler input from the
#      range cube, then runs the HLS range-consume and Doppler stages.
#   3. tb/rd_test.py --check compares the Q15 windows, the range cube, the
#      Doppler cube and the target peaks against the Python model.
#   4. tb/doppler_aie_check.py runs the real AIE 256-point Doppler FFT on the
#      strongest frame and compares it with the Python model.  Set
#      DOPPLER_AIE_CHECK=0 to skip this step.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMP="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$COMP/.." && pwd)"
WORK="$HERE/work"
SCENES="${SCENES:-rd}"
CHIRPS="${CHIRPS:-256}"

mkdir -p "$WORK"
rc=0

if [ "$CHIRPS" -ne 256 ]; then
    echo "error: one range-Doppler frame needs CHIRPS=256 (got $CHIRPS)" >&2
    exit 2
fi

for scene in $SCENES; do
    echo
    echo "================ scene: $scene ================"
    python3 "$HERE/rd_test.py" --generate --scene "$scene" --chirps "$CHIRPS" \
        || { rc=1; continue; }

    log="$WORK/csim_$scene.log"
    "$ROOT/hls.sh" csim >"$log" 2>&1
    status=$?
    if [ "$status" -eq 0 ] && grep -q "RESULT: PASS" "$log"; then
        grep -E "scene +:|chirps +:|taps|windowed[01]:|range AIE|range cube|Doppler|AIE range|targets:|\(|RESULT" "$log" \
            | sed 's/^/  /'
        echo "  -> PASS"

        # Optional: run the real AIE 256-point Doppler FFT on the strongest
        # frame of this scene and compare it with the Python model.
        if [ "${DOPPLER_AIE_CHECK:-1}" = "1" ] &&
           [ -d "$ROOT/fft_accelerator_component/build/x86sim" ]; then
            aie_log="$WORK/aie_doppler_$scene.log"
            if python3 "$HERE/doppler_aie_check.py" >"$aie_log" 2>&1; then
                grep -E "running AIE|max \|error\||correlation|RESULT" "$aie_log" \
                    | sed 's/^/  /'
            else
                echo "  AIE 256-pt FFT: FAIL (see $aie_log)"
                rc=1
            fi
        fi
    else
        echo "  --- last lines of $log ---"
        tail -40 "$log"
        echo "  -> FAIL"
        rc=1
    fi
done

echo
if [ "$rc" -eq 0 ]; then
    echo "SUITE: all scenes passed"
else
    echo "SUITE: failures above"
fi
exit "$rc"

#!/usr/bin/env bash
#
# Run the whole HLS + AIE chain test over a set of scenes.
#
#   ./tb/run_test.sh                 # noise, sparse, dense (1 chirp each)
#   SCENES="sparse" ./tb/run_test.sh # one scene
#   CHIRPS=256 ./tb/run_test.sh      # 256 chirps per scene
#
# Each scene: generate the ADC frames, run the HLS kernel under C simulation
# (which shells out to the AIE once per chirp), then compare every stage
# against tb/golden.py.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMP="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$COMP/.." && pwd)"
WORK="$HERE/work"
SCENES="${SCENES:-noise sparse dense}"
CHIRPS="${CHIRPS:-1}"

mkdir -p "$WORK"
rc=0

for scene in $SCENES; do
    echo
    echo "================ scene: $scene ================"
    python3 "$HERE/golden.py" --generate --scene "$scene" --chirps "$CHIRPS" \
        || { rc=1; continue; }

    log="$WORK/csim_$scene.log"
    "$ROOT/hls.sh" csim >"$log" 2>&1
    status=$?
    if [ "$status" -eq 0 ] && grep -q "RESULT: PASS" "$log"; then
        grep -E "scene +:|chirps +:|model keeps|windowed[01]:|AIE |DRAM |mask packet|RESULT" "$log" \
            | sed 's/^/  /'
        echo "  -> PASS"
    else
        echo "  --- last lines of $log ---"
        tail -25 "$log"
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

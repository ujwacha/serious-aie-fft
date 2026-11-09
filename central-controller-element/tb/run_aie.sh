#!/usr/bin/env bash
#
# Bridge between the HLS testbench and the AI Engine simulator.
#
#   tb/work/windowed{0,1}.txt  --split per chirp-->  aie_component/data/temp_input{0,1}.txt
#   x86sim (one run per chirp) ->  tb/work/aie{0,1}.txt (concatenated, chirp order)
#
# Usage: run_aie.sh [chirps]
#
# Called from tb/test.cpp while the HLS kernel is under C simulation.  Each
# chirp is 1024 lines per stream (2048 samples split by parity).

set -eo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
WORK="$HERE/work"
AIE="$ROOT/aie_component"
BUILD="$AIE/build/x86sim"
SIMOUT="$BUILD/x86simulator_output/data"
CHIRPS="${1:-1}"
LINES=1024

for f in windowed0 windowed1; do
    [ -f "$WORK/$f.txt" ] || { echo "run_aie: missing $WORK/$f.txt" >&2; exit 1; }
done

# x86simulator is only on PATH after the Vitis environment is sourced.  hls.sh
# already runs inside the distrobox, so there is no re-exec here.
if ! command -v x86simulator >/dev/null 2>&1; then
    # shellcheck disable=SC1090
    source "$HOME/FPGA/2026.1/Vitis/settings64.sh" >/dev/null 2>&1 || true
fi
if ! command -v x86simulator >/dev/null 2>&1; then
    echo "run_aie: x86simulator not found (source settings64.sh)" >&2
    exit 1
fi

# Slice the concatenated windowed streams into one file per chirp once.
SPLIT="$(mktemp -d "$WORK/aie_split.XXXXXX")"
trap 'rm -rf "$SPLIT"' EXIT
split -l "$LINES" -d -a 4 "$WORK/windowed0.txt" "$SPLIT/w0_"
split -l "$LINES" -d -a 4 "$WORK/windowed1.txt" "$SPLIT/w1_"

: >"$WORK/aie0.txt"
: >"$WORK/aie1.txt"

for ((c = 0; c < CHIRPS; c++)); do
    f0="$(printf '%s/w0_%04d' "$SPLIT" "$c")"
    f1="$(printf '%s/w1_%04d' "$SPLIT" "$c")"
    [ -f "$f0" ] && [ -f "$f1" ] || {
        echo "run_aie: missing split chunk for chirp $c" >&2
        exit 1
    }

    cp "$f0" "$AIE/data/temp_input0.txt"
    cp "$f1" "$AIE/data/temp_input1.txt"

    if ! ( cd "$BUILD" && x86simulator --pkg-dir=./Work --i=../../ ) \
            >"$WORK/aie_chirp$c.log" 2>&1; then
        echo "run_aie: x86sim failed on chirp $c, see $WORK/aie_chirp$c.log" >&2
        tail -20 "$WORK/aie_chirp$c.log" >&2
        exit 1
    fi

    for p in 0 1; do
        [ -f "$SIMOUT/temp_output$p.txt" ] || {
            echo "run_aie: missing $SIMOUT/temp_output$p.txt (chirp $c)" >&2
            exit 1
        }
        cat "$SIMOUT/temp_output$p.txt" >>"$WORK/aie$p.txt"
    done

    if [ $((c % 32)) -eq 31 ]; then
        echo "run_aie: $((c + 1))/$CHIRPS chirps"
    fi
done

echo "run_aie: $CHIRPS chirps done -> tb/work/aie{0,1}.txt"

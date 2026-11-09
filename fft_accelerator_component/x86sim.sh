#!/usr/bin/env bash
#
# Build / run helper for the serious-aie-fft AI Engine design (x86sim).
#
#   ./x86sim.sh [all|configure|build|run|clean]
#
#     all        configure if needed + build + run + compare vs golden   (default)
#     configure  cmake configure only
#     build      cmake build
#     run        run x86simulator + golden compare + FFT functional test
#     clean      remove build/x86sim
#
# By default, 'run' generates a synthetic IQ test vector for the FFT graph and
# checks the x86sim output. Set FFT_TEST=0 to use your own data/input.txt and
# skip the functional test. Choose the vector with
# FFT_TEST_CASE=tones|real_tone|chirp.
#
# The script normally lives inside the AIE component:
#
#   fft_accelerator_component/x86sim.sh  -> uses that component directory
#
# It also works one level up if a component directory is present:
#
#   serious-aie-fft/x86sim.sh            -> uses serious-aie-fft/fft_accelerator_component
#
# Always runs inside the distrobox. The host's Vitis/CMake combination picks up
# an old libstdc++ and fails, so when on the host we re-exec inside 'myubuntu'
# first.

set -eo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Support both the component layout (x86sim.sh inside the component) and the
# workspace layout (x86sim.sh next to fft_accelerator_component/).
if [ -f "$HERE/CMakeLists.txt" ]; then
    PROJECT="$HERE"
elif [ -f "$HERE/fft_accelerator_component/CMakeLists.txt" ]; then
    PROJECT="$HERE/fft_accelerator_component"
else
    echo "error: cannot find CMakeLists.txt in $HERE or its fft_accelerator_component/" >&2
    exit 1
fi

BUILD="$PROJECT/build/x86sim"
SETTINGS="$HOME/FPGA/2026.1/Vitis/settings64.sh"
CONTAINER="myubuntu"

# FFT functional test (generates data/temp_input0.txt and checks the output).
TEST_SCRIPT="$PROJECT/fft_x86sim_test.py"
FFT_TEST="${FFT_TEST:-1}"
FFT_TEST_CASE="${FFT_TEST_CASE:-tones}"
export FFT_TEST FFT_TEST_CASE

# ---- always run inside the distrobox ---------------------------------------
# CONTAINER_ID / DISTROBOX_ENTER_PATH are set by distrobox-enter; if neither is
# present we are on the host and need to hop in.
if [ -z "${CONTAINER_ID:-}" ] && [ -z "${DISTROBOX_ENTER_PATH:-}" ]; then
    if command -v distrobox >/dev/null 2>&1; then
        echo "==> entering distrobox '$CONTAINER'"
        exec distrobox enter "$CONTAINER" -- bash -lc \
            'cd "$1" || exit 1; shift; exec bash ./x86sim.sh "$@"' _ "$HERE" "$@"
    fi
    echo "error: not inside distrobox '$CONTAINER' and 'distrobox' not found" >&2
    exit 1
fi

# ---- make sure the Vitis tools are on PATH (inside the container) ----------
if ! command -v aiecompiler >/dev/null 2>&1 && [ -f "$SETTINGS" ]; then
    # shellcheck disable=SC1090
    source "$SETTINGS" >/dev/null 2>&1 || true
fi

if ! command -v aiecompiler >/dev/null 2>&1; then
    echo "error: aiecompiler not found after sourcing $SETTINGS" >&2
    exit 1
fi

MODE="${1:-all}"

configure() {
    # CMakeLists.txt defaults VITIS_PART to a Zynq part (no AIE). Use the real
    # part from aiecompiler.cfg instead.
    local part
    part="$(sed -n 's/^part=//p' "$PROJECT/aiecompiler.cfg" | head -1)"
    echo "==> cmake configure (part=${part:-<default>})"
    if [ -n "$part" ]; then
        cmake -S "$PROJECT" -B "$BUILD" \
            -DVITIS_TARGET=x86sim \
            -DVITIS_PART="$part"
    else
        cmake -S "$PROJECT" -B "$BUILD" -DVITIS_TARGET=x86sim
    fi
}

build() {
    [ -f "$BUILD/CMakeCache.txt" ] || configure
    echo "==> cmake build"
    cmake --build "$BUILD" --target all
}

run() {
    if [ "$FFT_TEST" = 1 ] && [ -f "$TEST_SCRIPT" ] && command -v python3 >/dev/null 2>&1; then
        echo "==> generating FFT test input (case: $FFT_TEST_CASE)"
        python3 "$TEST_SCRIPT" --generate-only --case "$FFT_TEST_CASE"
    fi

    if [ ! -f "$PROJECT/data/input.txt" ]; then
        echo "error: $PROJECT/data/input.txt not found" >&2
        echo "       add the x86sim input file, or run '$0 build' to compile only." >&2
        exit 1
    fi

    echo "==> x86simulator"
    ( cd "$BUILD" && x86simulator --pkg-dir=./Work --i=../../ )
    echo
    echo "==> result vs golden:"
    local out="x86simulator_output/data"
    local got name gold found
    found=0
    for got in "$BUILD/$out"/*.txt; do
        [ -f "$got" ] || continue
        found=1
        name="$(basename "$got")"
        gold=""
        for candidate in \
            "$PROJECT/data/golden/$name" \
            "$PROJECT/data/golden_$name" \
            "$PROJECT/data/golden${name}"; do
            if [ -f "$candidate" ]; then
                gold="$candidate"
                break
            fi
        done

        if [ -z "$gold" ]; then
            echo "   $name : no golden -- skipped"
        elif diff -q "$got" "$gold" >/dev/null 2>&1; then
            echo "   $name : MATCH   ${gold##*/}"
        else
            echo "   $name : DIFFERS from ${gold##*/}"
            diff "$got" "$gold" | head -20 || true
        fi
    done

    if [ "$found" -eq 0 ]; then
        echo "   (no output files produced)"
    fi

    if [ "$FFT_TEST" = 1 ] && [ -f "$TEST_SCRIPT" ] && command -v python3 >/dev/null 2>&1; then
        echo
        echo "==> FFT functional test"
        python3 "$TEST_SCRIPT" --check-only --case "$FFT_TEST_CASE"
    fi
}

clean() {
    rm -rf "$BUILD"
    echo "==> removed $BUILD"
}

case "$MODE" in
    all)
        configure
        build
        if [ -f "$PROJECT/data/input.txt" ] || { [ "$FFT_TEST" = 1 ] && [ -f "$TEST_SCRIPT" ]; }; then
            run
        else
            echo
            echo "==> no $PROJECT/data/input.txt yet; skipping simulation"
            echo "    add the input file and run '$0 run' when ready"
        fi
        ;;
    configure) configure ;;
    build)     build ;;
    run)       run ;;
    clean)     clean ;;
    *) echo "usage: $0 [all|configure|build|run|clean]" >&2; exit 2 ;;
esac

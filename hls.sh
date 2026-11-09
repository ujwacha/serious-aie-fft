#!/usr/bin/env bash
#
# Build / test helper for the serious-aie-fft HLS component
# (central-controller-element).
#
#   ./hls.sh [csim|cosim|syn|impl|package|report|clean]
#
#     csim      C simulation of the testbench (tb/test.cpp)        (default)
#     cosim     RTL co-simulation: checks the generated HDL against the C++
#     syn       C synthesis only, no simulation           (alias: synth)
#     impl      out-of-context implementation (synth + place & route)
#     package   package the IP catalog (add_vec.zip)
#     report    results of the last run: csim/cosim state, latency/II,
#               timing and resource usage
#     clean     remove the HLS work directory
#
# Only the C testbench runs by default. Synthesis, co-simulation,
# implementation and packaging have to be asked for explicitly.
#
# The script can live either next to the component:
#
#   serious-aie-fft/hls.sh                            -> uses serious-aie-fft/central-controller-element
#   serious-aie-fft/central-controller-element/hls.sh -> uses the component directory
#
# Always runs inside the distrobox. The host's Vitis/CMake combination picks up
# an old libstdc++ and fails, so when on the host we re-exec inside 'myubuntu'
# first.
#
# Environment overrides:
#   HLS_WORK_DIR    HLS work directory      (default: central-controller-element)
#   HLS_EXTRA_ARGS  extra flags appended to every v++ / vitis-run call

set -eo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Support both the workspace layout (hls.sh next to central-controller-element/)
# and the component layout (hls.sh inside central-controller-element/).
if [ -f "$HERE/central-controller-element/hls_config.cfg" ]; then
    PROJECT="$HERE/central-controller-element"
elif [ -f "$HERE/hls_config.cfg" ]; then
    PROJECT="$HERE"
else
    echo "error: cannot find central-controller-element/hls_config.cfg or hls_config.cfg" >&2
    exit 1
fi

CONFIG="$PROJECT/hls_config.cfg"
WORK_DIR="${HLS_WORK_DIR:-central-controller-element}"
SETTINGS="$HOME/FPGA/2026.1/Vitis/settings64.sh"
CONTAINER="myubuntu"

# --work_dir may be given as a relative name (resolved inside $PROJECT) or as an
# absolute path; keep both working when we need to look at the outputs.
case "$WORK_DIR" in
    /*) OUT="$WORK_DIR" ;;
    *)  OUT="$PROJECT/$WORK_DIR" ;;
esac

EXTRA=()
if [ -n "${HLS_EXTRA_ARGS:-}" ]; then
    read -r -a EXTRA <<< "$HLS_EXTRA_ARGS"
fi

# ---- always run inside the distrobox ---------------------------------------
# CONTAINER_ID / DISTROBOX_ENTER_PATH are set by distrobox-enter; if neither is
# present we are on the host and need to hop in.
if [ -z "${CONTAINER_ID:-}" ] && [ -z "${DISTROBOX_ENTER_PATH:-}" ]; then
    if command -v distrobox >/dev/null 2>&1; then
        echo "==> entering distrobox '$CONTAINER'"
        exec distrobox enter "$CONTAINER" -- bash -lc \
            'cd "$1" || exit 1; shift; exec bash ./hls.sh "$@"' _ "$HERE" "$@"
    fi
    echo "error: not inside distrobox '$CONTAINER' and 'distrobox' not found" >&2
    exit 1
fi

# ---- make sure the Vitis tools are on PATH (inside the container) ----------
if ! command -v vitis-run >/dev/null 2>&1 && [ -f "$SETTINGS" ]; then
    # shellcheck disable=SC1090
    source "$SETTINGS" >/dev/null 2>&1 || true
fi

if ! command -v vitis-run >/dev/null 2>&1; then
    echo "error: vitis-run not found after sourcing $SETTINGS" >&2
    exit 1
fi

if ! command -v v++ >/dev/null 2>&1; then
    echo "error: v++ not found after sourcing $SETTINGS" >&2
    exit 1
fi

# Vitis ships its own GNU make but settings64.sh does not put it on PATH, and a
# bare distrobox image often has none. Use the bundled one if the container is
# missing make.
VITIS_MAKE_DIR="$HOME/FPGA/2026.1/tps/lnx64/make-4.2.1/bin"
if ! command -v make >/dev/null 2>&1 && [ -x "$VITIS_MAKE_DIR/make" ]; then
    export PATH="$VITIS_MAKE_DIR:$PATH"
fi

MODE="${1:-csim}"

cfg() { sed -n "s/^$1=//p" "$CONFIG" | head -1; }

# csim/cosim build and run the testbench on the host with clang-16, which needs
# the system C headers as well as make. A bare distrobox image usually has
# neither, and the failure Vitis reports is just "compilation error(s)".
check_c_toolchain() {
    local missing=()
    command -v make >/dev/null 2>&1 || missing+=("make")
    [ -f /usr/include/stdio.h ] || missing+=("libc headers (libc6-dev)")
    if [ "${#missing[@]}" -gt 0 ]; then
        echo "error: C simulation needs a host C toolchain inside the container." >&2
        echo "       missing: ${missing[*]}" >&2
        echo "       fix:     sudo apt install -y build-essential" >&2
        exit 1
    fi
}

# Run a vitis-run HLS step from the component directory: the config file uses
# paths relative to it (./src/main.cpp, ./tb/test.cpp).
step() {
    local what="$1"; shift
    echo "==> $what"
    ( cd "$PROJECT" && vitis-run --mode hls "$@" \
        --config "$CONFIG" --work_dir "$WORK_DIR" "${EXTRA[@]}" )
}

# Last "state" recorded in a *.hlsrun_*_summary file (CS_RUNNING / CS_PASSED ...).
state_of() {
    [ -f "$1" ] || return 1
    sed -n 's/.*"state": "\(CS_[A-Z_]*\)".*/\1/p' "$1" | tail -1
}

# Print PASSED / FAILED for a simulation summary and fail the script on failure.
check_state() {
    local label="$1" file="$2" st
    st="$(state_of "$file" || true)"
    case "$st" in
        *PASSED)
            echo "   $label : PASSED" ;;
        "")
            echo "   $label : no result (${file##*/} missing or incomplete)"
            return 1 ;;
        *)
            echo "   $label : FAILED ($st)"
            return 1 ;;
    esac
}

syn() {
    local part top
    part="$(cfg part)"
    top="$(cfg syn.top)"
    echo "==> C synthesis (top=${top:-?}, part=${part:-?})"
    ( cd "$PROJECT" && v++ -c --mode hls \
        --config "$CONFIG" --work_dir "$WORK_DIR" "${EXTRA[@]}" )
}

csim() {
    if ! grep -q '^tb\.file=' "$CONFIG"; then
        echo "error: no tb.file in $CONFIG; nothing to simulate" >&2
        exit 1
    fi
    check_c_toolchain
    step "C simulation" --csim
    echo
    echo "==> result:"
    check_state "csim" "$OUT/${PROJECT##*/}.hlsrun_csim_summary"
}

cosim() {
    if ! grep -q '^tb\.file=' "$CONFIG"; then
        echo "error: no tb.file in $CONFIG; nothing to co-simulate" >&2
        exit 1
    fi
    check_c_toolchain
    step "RTL co-simulation" --cosim
    echo
    echo "==> result:"
    check_state "cosim" "$OUT/${PROJECT##*/}.hlsrun_cosim_summary"
}

impl() {
    step "implementation" --impl
}

package() {
    step "IP packaging" --package
    local ip
    ip="$(ls -1 "$OUT"/*.zip 2>/dev/null | head -1 || true)"
    if [ -n "$ip" ]; then
        echo "   IP catalog: $ip"
    fi
}

report() {
    local name
    name="${PROJECT##*/}"
    echo "==> component : $name"
    echo "    config    : $CONFIG"
    echo "    work dir  : $OUT"
    echo "    top       : $(cfg syn.top)   part: $(cfg part)"

    echo
    echo "==> simulation:"
    local st
    st="$(state_of "$OUT/$name.hlsrun_csim_summary" || true)"
    echo "   csim  : ${st:-not run}"
    st="$(state_of "$OUT/$name.hlsrun_cosim_summary" || true)"
    echo "   cosim : ${st:-not run}"

    if [ -f "$OUT/reports/hls_compile.rpt" ]; then
        echo
        echo "==> C synthesis estimates:"
        sed -n '/Performance & Resource Estimates/,/^$/p' \
            "$OUT/reports/hls_compile.rpt" | sed '/^$/d'
    fi

    if [ -f "$OUT/reports/hls_impl_syn.rpt" ]; then
        echo
        echo "==> implementation:"
        grep -m1 'RTL Synthesis target clock' "$OUT/reports/hls_impl_syn.rpt" \
            | sed 's/^[[:space:]]*/   /'
        grep -m1 'Timing was met' "$OUT/reports/hls_impl_syn.rpt" \
            | sed 's/^[[:space:]]*/   /'
        grep -E '^(LUT|FF|DSP|BRAM|URAM):' "$OUT/reports/hls_impl_syn.rpt" \
            | sed 's/^/   /'
    fi
}

clean() {
    if [ -e "$OUT" ]; then
        rm -rf "$OUT"
        echo "==> removed $OUT"
    else
        echo "==> nothing to remove ($OUT)"
    fi
}

usage() {
    cat <<'EOF'
Build / test helper for the serious-aie-fft HLS component
(central-controller-element).

  ./hls.sh [csim|cosim|syn|impl|package|report|clean]

    csim      C simulation of the testbench (tb/test.cpp)        (default)
    cosim     RTL co-simulation: checks the generated HDL against the C++
    syn       C synthesis only, no simulation           (alias: synth)
    impl      out-of-context implementation (synth + place & route)
    package   package the IP catalog (add_vec.zip)
    report    results of the last run: csim/cosim state, latency/II,
              timing and resource usage
    clean     remove the HLS work directory

Only the C testbench runs by default. Synthesis, co-simulation,
implementation and packaging have to be asked for explicitly.

Environment overrides:
    HLS_WORK_DIR    HLS work directory      (default: central-controller-element)
    HLS_EXTRA_ARGS  extra flags appended to every v++ / vitis-run call
EOF
}

case "$MODE" in
    csim)                csim ;;
    cosim)               cosim ;;
    syn|synth|synthesis) syn ;;
    impl)                impl ;;
    package)             package ;;
    report)              report ;;
    clean)               clean ;;
    help|-h|--help)      usage ;;
    *) echo "usage: $0 [csim|cosim|syn|impl|package|report|clean]" >&2; exit 2 ;;
esac

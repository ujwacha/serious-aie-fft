#!/usr/bin/env bash
# Build docs/waveform-design.pdf from docs/waveform-design.tex.
#
# Normally just runs pdflatex twice.  In this workspace pdflatex lives on the
# host and is reached through /run/host (the agent shell is inside a distrobox),
# so the script falls back to the host loader and the host texmf tree.
set -euo pipefail

cd "$(dirname "$0")"
TEX=waveform-design.tex
JOB=waveform-design

if command -v pdflatex >/dev/null 2>&1; then
    for _ in 1 2; do pdflatex -interaction=nonstopmode -halt-on-error "$TEX" >/dev/null; done
else
    HOSTLD=/run/host/lib64/ld-linux-x86-64.so.2
    HOSTLIB=/run/host/usr/lib/x86_64-linux-gnu:/run/host/lib/x86_64-linux-gnu:/run/host/usr/lib
    export TEXMFDIST=/run/host/usr/share/texmf-dist
    export TEXMFSYSVAR=/run/host/var/lib/texmf
    export TEXMFVAR="${TMPDIR:-/tmp}/texmf-var"
    export TEXMFCONFIG="${TMPDIR:-/tmp}/texmf-config"
    export TEXMFCACHE="${TMPDIR:-/tmp}/texmf-cache"
    mkdir -p "$TEXMFVAR" "$TEXMFCONFIG" "$TEXMFCACHE"
    for _ in 1 2; do
        "$HOSTLD" --library-path "$HOSTLIB" \
            /run/host/usr/bin/pdflatex -interaction=nonstopmode \
            -halt-on-error "$TEX" >/dev/null
    done
fi

rm -f "$JOB.aux" "$JOB.log" "$JOB.out"
echo "wrote $(pwd)/$JOB.pdf"

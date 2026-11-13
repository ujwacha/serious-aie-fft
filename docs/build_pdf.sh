#!/usr/bin/env bash
# Build the LaTeX design note. Run on the host, where pdflatex is on PATH:
#
#     ./docs/build_pdf.sh
#
# Two passes are needed for the section references.
set -euo pipefail

cd "$(dirname "$0")"
name="${1:-waveform-design}"

for _ in 1 2; do
    pdflatex -interaction=nonstopmode -halt-on-error "$name.tex" >/dev/null
done

rm -f "$name.aux" "$name.log" "$name.out"
echo "wrote $(pwd)/$name.pdf"

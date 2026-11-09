#!/usr/bin/env python3
"""Rewrite Vitis HLS's compile_commands.json into one a normal language server
can use.

Vitis writes flags such as `-fhls` and `-hls-syn-headers-dir=...` that clangd
and the VS Code C/C++ extension do not understand, so `ap_uint`, `ap_int` and
`cint16` show up as unknown types.  This rewrites the entries with plain `-I`
flags and keeps the Vitis original as `compile_commands.vitis.json`.

Run it after a Vitis build has regenerated compile_commands.json:

    python3 tb/gen_compile_commands.py
"""

from __future__ import annotations

import json
from pathlib import Path

COMP = Path(__file__).resolve().parent.parent
CC = COMP / "compile_commands.json"
BAK = COMP / "compile_commands.vitis.json"

SYN = Path.home() / "FPGA/2026.1/Vitis/common/technology/autopilot"
SIM = Path.home() / "FPGA/2026.1/Vitis/include"


def main() -> int:
    entries = json.loads(CC.read_text())
    if any("-fhls" in e.get("arguments", []) for e in entries):
        BAK.write_text(json.dumps(entries, indent=2) + "\n")

    out = []
    for entry in entries:
        file = entry["file"]
        # Use the simulation headers for both files.  The synthesis hls_stream
        # needs the -fhls intrinsics, which a plain language server cannot
        # parse; the simulation headers are ordinary C++ and expose the same
        # ap_uint / ap_int / hls::stream API for IntelliSense.
        incs = [SIM, SYN]
        out.append({
            "directory": entry["directory"],
            "file": file,
            "arguments": ["clang++", *[f"-I{d}" for d in incs], "-c", file],
        })

    CC.write_text(json.dumps(out, indent=2) + "\n")
    print(f"wrote {CC} ({len(out)} entries); Vitis original kept in {BAK.name}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

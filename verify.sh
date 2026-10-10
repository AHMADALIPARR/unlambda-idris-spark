#!/usr/bin/env bash
# Copyright (c) 2026 Ahmad Ali Parr. All rights reserved.
# SPDX-License-Identifier: LicenseRef-Proprietary
# Public source visibility does not grant an open-source license. See LICENSE.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IDRIS_DIR="$ROOT/idris"
ADA_DIR="$ROOT/ada"
ATS_DIR="$ROOT/ats"

# Guardrail only: semantic review and compiler checks remain necessary.
if grep -RniE '\b(believe_me|sorry|admit|assert_total|assert_smaller)\b|pragma[[:space:]]+Assume' \
    "$IDRIS_DIR" "$ADA_DIR" "$ATS_DIR"; then
  echo "FAIL: prohibited proof escape hatch detected" >&2
  exit 20
fi

for tool in idris2 patsopt gprbuild gnatprove; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "FAIL: $tool not installed" >&2
    exit 2
  fi
done

mkdir -p "$ROOT/build"
patsopt -tc -s "$ATS_DIR/heap.sats"
patsopt -tc -s "$ATS_DIR/state.sats"
cd "$IDRIS_DIR"
idris2 --total --check Main.idr
idris2 --total --check LambdaProofs.idr
idris2 --total -o unlambda_model Main.idr
test "$(build/exec/unlambda_model)" = 'step: advanced'

cd "$ADA_DIR"
gprbuild -p -P heap_model.gpr
test "$("$ROOT/build/heap_demo")" = 'heap contract smoke test: PASS'
# All required checks must be proved; ordinary successful invocation is insufficient.
gnatprove -P heap_model.gpr -u heap_model.adb --mode=all \
  --checks-as-errors=on --warnings=error --report=all --level=2
echo "PASS: ATS interfaces, Idris model, and allocation-counter heap."

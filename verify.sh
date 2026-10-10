#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IDRIS_DIR="$ROOT/idris"
ADA_DIR="$ROOT/ada"

# Guardrail only: semantic review and compiler checks remain necessary.
if grep -RniE '\b(believe_me|sorry|admit|assert_total|assert_smaller)\b|pragma[[:space:]]+Assume' \
    "$IDRIS_DIR" "$ADA_DIR"; then
  echo "FAIL: prohibited proof escape hatch detected" >&2
  exit 20
fi

if ! command -v idris2 >/dev/null 2>&1; then
  echo "FAIL: idris2 not installed" >&2
  exit 2
fi
if ! command -v gnatprove >/dev/null 2>&1; then
  echo "FAIL: gnatprove not installed" >&2
  exit 2
fi

mkdir -p "$ROOT/build"
cd "$IDRIS_DIR"
idris2 --total --check Main.idr
idris2 --total --check LambdaProofs.idr
idris2 --total -o unlambda_model Main.idr

cd "$ADA_DIR"
# GNATprove must analyze the SPARK package and report proof results.
gnatprove -P heap_model.gpr --mode=prove

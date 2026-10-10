#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOKS="${AGENT_HOOKS:-$ROOT/agent_hooks.sh}"
MAX_RETRIES="${MAX_RETRIES:-5}"
ATTEMPT=1
TARGET="$ROOT/idris/GeneratedProofs.idr"

if [[ ! -f "$HOOKS" ]]; then
  echo "Missing agent hook file: $HOOKS" >&2
  echo "Create it with generate_proof_tactic and update_agent_context functions." >&2
  exit 2
fi
# The hook file is executable project configuration and must be reviewed before sourcing.
# shellcheck source=/dev/null
source "$HOOKS"
command -v generate_proof_tactic >/dev/null || { echo "generate_proof_tactic hook missing" >&2; exit 2; }
command -v update_agent_context >/dev/null || { echo "update_agent_context hook missing" >&2; exit 2; }
command -v idris2 >/dev/null || { echo "idris2 not installed" >&2; exit 2; }

while (( ATTEMPT <= MAX_RETRIES )); do
  echo "Proof iteration $ATTEMPT/$MAX_RETRIES"
  if ! generate_proof_tactic > "$TARGET"; then
    FEEDBACK="Agent generation command failed. Return a complete Idris 2 module with explicit theorem statements and constructive proof terms."
    update_agent_context "$FEEDBACK"
    ((ATTEMPT+=1))
    continue
  fi

  if grep -nE '\b(believe_me|sorry|admit|assert_total|assert_smaller)\b' "$TARGET"; then
    FEEDBACK="Rejected: prohibited Idris proof escape hatch detected. Remove the escape hatch and construct a proof term that typechecks."
    update_agent_context "$FEEDBACK"
    ((ATTEMPT+=1))
    continue
  fi

  set +e
  COMPILER_OUT="$(cd "$ROOT/idris" && idris2 --total --check GeneratedProofs.idr 2>&1)"
  COMPILER_STATUS=$?
  set -e

  if (( COMPILER_STATUS == 0 )); then
    echo "Idris typecheck passed. This validates the generated module only; it does not by itself establish the cross-language SPARK correspondence."
    exit 0
  fi

  update_agent_context "Idris 2 typechecker output (attempt $ATTEMPT):\n$COMPILER_OUT"
  ((ATTEMPT+=1))
done

echo "FAIL: proof generation did not produce a typechecking module after $MAX_RETRIES attempts." >&2
exit 1

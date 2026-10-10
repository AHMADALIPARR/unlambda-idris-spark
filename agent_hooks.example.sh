# Copy to agent_hooks.sh and replace the bodies with your local agent integration.
# Do not source unreviewed hook scripts: they execute with your user permissions.

generate_proof_tactic() {
  # Print a COMPLETE Idris 2 module to stdout, not a tactic fragment.
  # Example: invoke your local agent CLI here.
  echo 'module GeneratedProofs'
  echo '%default total'
  echo 'example : 1 = 1'
  echo 'example = Refl'
}

update_agent_context() {
  # Persist feedback to your agent's context/session using your integration.
  # This sample only writes feedback to stderr.
  printf '%s\n' "$1" >&2
}

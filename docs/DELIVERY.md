# Delivery workflow

Lead: Codex, during active working sessions. Product owner: repository owner.
Status: implementation and release preparation in progress; no production release.

## Working cycle

1. Select the next unmet gate and record its concrete acceptance criteria.
2. Implement a reviewable increment with tests of observable behavior.
3. Compile and run the tests; collect proof reports where applicable.
4. Commit the increment and update this ledger with evidence and blockers.
5. Release only after all required gates pass on the release commit.

## Backlog and acceptance gates

| Gate | Work | Required evidence | State |
| --- | --- | --- | --- |
| 0 | Combined ATS runtime, Idris semantic proofs, SPARK heap; freeze platform, dialect and licensing | Product decisions; authoritative semantics; license provenance | Architecture confirmed; remaining decisions open |
| A | Bounded slot-map heap with generations | Allocation exhaustion, reuse, stale lookup/update, invariant tests | Open |
| B | Parser and core machine: s,k,i,v,d,output,newline | Compiler success; strictness, delay, output order, fuel tests | Open |
| C | Continuations, exit and input primitives | Capture/restore, EOF, current-character, input order tests | Open |
| D | Independent reference comparisons | Pinned reference; byte-for-byte output and termination corpus | Open |
| E | GC, if required for release | Root tracing, continuation retention, stale-reference safety | Open |
| R | Packaging and production release | Clean builds; CI; installation smoke test; version/checksums; rollback instructions | Open |

## Current assessment

- Idris `stepControl` consumes fuel but does not evaluate terms.
- Ada heap is an allocation counter; it has no node slots or generation handles.
- ATS files are interface sketches, not compilable runtime modules.
- No executable interpreter or behavioral test suite exists yet.
- Private GitHub repository and `origin` configured:
  https://github.com/AHMADALIPARR/unlambda-idris-spark.
  The owner explicitly approved the push; the Idris workflow is active.
- ATS, Idris 2, and GNATprove are absent from the current PATH. Git's bundled
  Bash is available at `C:/Program Files/Git/bin/bash.exe`.
- WSL has no usable installed distribution in the current environment.

## Definition of done

A runtime increment must compile and pass behavior and resource-boundary tests.
A proof increment must produce checked proof evidence; a source scan is insufficient.
A release must include a documented supported platform, CLI contract, resource
limits, tested installation, reproducible build instructions, license/provenance,
and a recorded passing release-gate result. Design documents alone do not pass a gate.

## Next increment

Architecture confirmed by the owner: ATS runtime, handwritten lambda-calculus
derivations formalized in Idris 2, and SPARK-verified heap contracts. The Idris
program/models must typecheck. Begin with the explicit SKI proof terms and
compiler workflow, then implement gate A before connecting the core machine.
Production platform and packaging remain to be decided.

## Proof increment

- Handwritten I/K/S beta derivations recorded in `spec/lambda-proofs.md`.
- Explicit indexed reduction witnesses written in `idris/LambdaProofs.idr`.
- Capture-avoidance boundary cases expressed as equality proofs.
- Corrected the original fuel theorem's successor inequality; added explicit
  `OutOfMemory` and exact fuel-consumption obligations.
- CI definition bootstraps pinned Idris 2 and retains typechecker logs.
- Local whitespace and Bash syntax checks pass. Compiler validation is pending.
- GitHub upload completed after the owner's explicit approval. The first Idris
  run is bootstrapping the pinned compiler; typechecking results are pending.

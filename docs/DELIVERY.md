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
| 0 | Freeze implementation language, target platform, dialect and licensing | Product decisions; authoritative semantics; license provenance | Open |
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
- No Git remote is configured. GitHub CLI is authenticated locally.
- ATS, Idris 2, GNATprove, and Bash are absent from the current PATH.
- WSL has no usable installed distribution in the current environment.

## Definition of done

A runtime increment must compile and pass behavior and resource-boundary tests.
A proof increment must produce checked proof evidence; a source scan is insufficient.
A release must include a documented supported platform, CLI contract, resource
limits, tested installation, reproducible build instructions, license/provenance,
and a recorded passing release-gate result. Design documents alone do not pass a gate.

## Next increment

Resolve gate 0 while preparing tooling. Then implement and test gate A before
connecting the parser and core machine. Confirm whether production means an ATS
CLI release, an Idris/SPARK runtime, or a hosted service before choosing packaging.

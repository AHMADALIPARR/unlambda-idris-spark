<!--
Copyright (c) 2026 Ahmad Ali Parr. All rights reserved.
SPDX-License-Identifier: LicenseRef-Proprietary
Public source visibility does not grant an open-source license. See LICENSE.
-->

# Contributing

This public, proprietary source-visible repository develops a combined Unlambda/ATS/Idris/SPARK
verification scaffold. Review [LICENSE](LICENSE) before proposing contributions. Start with the
[workflow](docs/WORKFLOW.md), [current evidence](docs/verification/ats-spark-af40c4e.md),
and [delivery gates](docs/DELIVERY.md).

## Work on a reviewable increment

Open an issue describing the behavior or proof obligation, then use a focused
branch. An implementation change should include a test of observable behavior
or a constructive proof of the changed invariant. Documentation-only changes
should have working links and accurate scope statements.

```sh
git switch -c change/describe-the-increment
# Edit source, specifications, and relevant tests or proofs.
bash verify.sh
git add <changed-files>
git commit -m "Describe the resulting behavior"
git push -u origin change/describe-the-increment
```

Create a pull request with the concrete problem, resulting behavior, checked
commands/CI runs, and any remaining proof obligations. Reference the gate it
advances. Do not mark a runtime gate complete from interface checks alone.

## Proof and safety rules

- Keep handwritten derivations and Idris witnesses consistent. State the
  quantified operand class and every required substitution lemma.
- Keep Idris proof-bearing definitions total. Do not use `believe_me`,
  `assert_total`, `assert_smaller`, missing proof holes, or equivalent bypasses.
- Do not introduce `pragma Assume` or suppress required SPARK checks. Strengthen
  contracts and supply loop invariants when needed; retain unproved-check failures.
- Preserve distinct `OutOfFuel`, `OutOfMemory`, failure, and successful statuses.
- Do not dereference a future node handle without generation-checked lookup.
- Preserve input/output ordering and record effects in explicit machine state.
- Add runtime code only with its actual compiler and behavioral checks. Abstract
  ATS declarations do not establish implementation or FFI correctness.
- Never source unreviewed agent hooks. `agent_hooks.example.sh` is an example,
  not an active proof-generation agent or a release gate.

The source scanner is a guardrail. Compiler/prover evidence and review are still
required. Do not invent coverage percentages, certification seals, or claims
that one language's tool verifies the other language's implementation.

## Review checklist

- The change explains its observable behavior and proof boundary.
- Specs and implementation agree; provenance and dependency versions are recorded.
- Relevant CI passes on the proposed source snapshot.
- Required checks are not skipped, assumed, or downgraded.
- Reports and release notes distinguish checked scope from future work.
- Contributions identify their authorship and any third-party license obligations.

Original project code is proprietary and source-visible, not open source;
see [LICENSING.md](LICENSING.md). Do not assume a copyright transfer or commercial
relicensing grant. Discuss the applicable contribution terms with the maintainer
before contributing third-party material. Report sensitive issues through
[SECURITY.md](SECURITY.md), rather than a normal issue or pull request.

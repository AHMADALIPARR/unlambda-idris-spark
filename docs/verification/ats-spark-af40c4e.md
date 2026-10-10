<!--
Copyright (c) 2026 Ahmad Ali Parr. All rights reserved.
SPDX-License-Identifier: LicenseRef-Proprietary
Public source visibility does not grant an open-source license. See LICENSE.
-->

# ATS/SPARK verification report

Checked source commit: `af40c4e75c51c4dfc636b3eaa53f2362ffae0c4a`.

[ATS and SPARK validation run](https://github.com/AHMADALIPARR/unlambda-idris-spark/actions/runs/38026024273)
and [Idris validation on the same source commit](https://github.com/AHMADALIPARR/unlambda-idris-spark/actions/runs/38026024320)
both passed.

## Checked scope

| Component | Result | Scope |
| --- | --- | --- |
| `ats/heap.sats` | ATS typecheck passed | Interface declarations |
| `ats/state.sats` | ATS typecheck passed | Interface declarations |
| Ada `Heap_Model` | Compiled and tests passed | Fixed-capacity allocation counter |
| Ada `Heap_Model` | All six GNATprove checks discharged | Initialization, range safety, postconditions, termination |
| Idris proofs/model | Typechecked; model built and smoke-tested | Previously documented proof/model slice |
| ATS runtime | Not certified | No `.dats` implementation exists |
| Generational slot-map heap | Not certified | Not yet implemented |
| Cross-language correspondence | Not certified | No checked adapter/simulation argument yet |

This report certifies only the observed compiler/prover results for the stated
source snapshot and scope. It is not a third-party certification, a full
interpreter correctness proof, or a production release certificate.

## Tools and reproducibility

- Runner: Ubuntu 24.04, x86-64.
- ATS/Postiats: 0.4.2; Ubuntu package `ats2-lang=0.4.2-1.1`.
- Native Ada compiler: GNAT 13.3.0; assertion checking enabled with `-gnata`.
- GNATprove distribution: Alire `gnatprove` 15.1.0 (reports `FSF 15.0`).
- GNATprove archive SHA-256:
  `aad9a73f600d3008f33141a6cd4c5314d4c210e8928edc172c23c76104ddf7b2`.
- Prover checks use `--mode=all --checks-as-errors=on --warnings=error
  --report=all --level=2`, targeting `heap_model.adb`.
- Machine evidence is retained in the run's `ats-validation-evidence` and
  `spark-validation-evidence` artifacts, subject to GitHub retention.

The compiler/prover installation follows the official
[Ubuntu ATS package](https://packages.ubuntu.com/noble/ats2-lang),
[Alire GNATprove manifest](https://github.com/alire-project/alire-index/blob/9ecbbfb0f9442fa6e53f5492258837c430154a3e/index/gn/gnatprove/gnatprove-15.1.0.toml),
and [GNATprove command documentation](https://docs.adacore.com/spark2014-docs/html/ug/en/source/how_to_run_gnatprove.html).

## Discharged SPARK checks

The prover summary reports six checks: two initialization checks, one run-time
range check, two functional-contract checks, and one termination check. Three
are discharged by flow analysis and three by CVC5. There are zero unproved or
justified checks. The detailed report records no warnings or `pragma Assume`.

The functional contracts establish:

- Reset sets the used count to zero.
- Allocation succeeds exactly when the old count is below capacity.
- Successful allocation increments the count by one.
- Rejected allocation preserves the count.

The test driver fills all 64 slots counted by the model, checks exhaustion,
resets the count, and allocates again. It uses runtime assertions; its I/O
driver is outside the SPARK proof boundary.

## Checked source hashes

SHA-256 hashes are for the Git blob bytes in the checked commit, with LF endings.

| File | SHA-256 |
| --- | --- |
| `ats/heap.sats` | `31f057dca9fc21f88bda99f071904fb781cc02650d005b3aa098204f48a1d550` |
| `ats/state.sats` | `ce64db05252470b0dd1eb3ec930477f02aa22c812c3857eceab43466527836e4` |
| `ada/heap_model.ads` | `a98bd4dc755c03807b1ea84cc158fcd94f325503facfe5021443d60df33317ab` |
| `ada/heap_model.adb` | `8bb9c934b080efe8ff9d9e7e042c1fa3a95c92497f1f6511ce1cdd7409ded9cc` |

## Required before full runtime certification

Implement the ATS parser and evaluator, the Ada slot-map with generation-checked
references, and the ATS/Ada adapter. Compile/link the real runtime; test every
Unlambda primitive, strictness/delay, I/O ordering, continuation restoration,
fuel exhaustion, and heap exhaustion. Prove the extended heap contracts and
establish correspondence to the Idris semantics. Passing interface checks and
counter proofs alone cannot establish these properties.

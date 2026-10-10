# Unlambda + ATS + Idris 2 + SPARK

## Purpose

Delivery status, acceptance gates, and the current implementation backlog are
tracked in [the delivery workflow](docs/DELIVERY.md).

The target architecture combines an ATS Unlambda runtime, handwritten
lambda-calculus derivations formalized in Idris 2, and Ada heap contracts
verified by SPARK. Idris 2 typechecks the semantic models and proof terms.
The runtime-to-model correspondence is a separate required obligation.
This repository is under implementation and is not yet a production interpreter.

The [handwritten SKI derivations](spec/lambda-proofs.md) correspond to explicit
proof terms in `idris/LambdaProofs.idr`. The Idris CI workflow typechecks them
and the current control model; it does not certify the ATS runtime or SPARK heap.

## Supplied ATS runtime design

The [ATS runtime specification](spec/ats-runtime-architecture.md) records the
supplied Unlambda semantics, abstract machine, heap invariants, and verification
gates. The original architecture document is in `docs/`. The shorthand heap and
state sketches have been converted into typed ATS interfaces in `ats/` and
validated by ATS/Postiats 0.4.2. Original sketches are preserved in
`docs/source-sketches/`. The interfaces declare operations; their runtime
implementations and ATS-to-Ada adapter remain to be written.

## Starter toolchain

- Idris 2
- ATS 2 / Postiats for the runtime
- GNAT toolchain and GNATprove
- Bash, grep

## Run

```sh
./verify.sh
```

GitHub CI uses pinned Idris 2 0.8.0 to typecheck `LambdaProofs.idr` and
`Main.idr`, compile the control-model program, and check its expected output.
[Recorded compiler evidence](docs/verification/idris-bb9abcc.md) documents the
passing increment. [ATS/SPARK verification evidence](docs/verification/ats-spark-af40c4e.md)
records passing interface checks, Ada compilation, capacity/reset tests, and all
six GNATprove checks for the current allocation-counter heap. This establishes
the checked component scope; it does not certify a full Unlambda runtime or
cross-language correspondence.

## Important next steps

1. Freeze the supported Unlambda dialect and cite its formal/authoritative semantics.
2. Expand `Term` and define a complete operational semantics, including strictness, delayed application, input/output, and control operators.
3. Replace the control-model stub with real machine transitions and proofs.
4. Add an independent reference evaluator and differential tests.
5. Extend the SPARK heap from an allocation counter to a bounded slot table with generation-checked handles and explicit read/write contracts.
6. Add a proof report gate that fails on any unproved required obligation, not just a nonzero command exit status.
7. Add a machine-readable shared invariant manifest and tests comparing Idris and SPARK model behavior.

## Trust boundary

Idris typechecking does not verify the Ada implementation. GNATprove does not verify Idris source. The shared specification and a reviewed correspondence argument are required to claim cross-language semantic agreement.

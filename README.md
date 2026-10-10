# Unlambda + Idris 2 + SPARK verification starter

## Purpose

A minimal proof-oriented starter showing the split between an Idris 2 control/semantic model and an Ada/SPARK heap contract. It deliberately does not claim to be a complete Unlambda interpreter or a completed cross-language proof.

## Supplied ATS runtime design

The [ATS runtime specification](spec/ats-runtime-architecture.md) records the
supplied Unlambda semantics, abstract machine, heap invariants, and verification
gates. The original architecture document is in `docs/`; the supplied heap and
state interface sketches are in `ats/`. These additions are design materials
and have not been compiler-validated.

## Starter toolchain

- Idris 2
- GNAT toolchain and GNATprove
- Bash, grep

## Run

```sh
./verify.sh
```

The current execution environment did not have Idris 2 or GNATprove installed, so the source files have not been compiler-validated here. Treat this as a starter scaffold requiring a local compile/proof pass, not as a verified release.

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

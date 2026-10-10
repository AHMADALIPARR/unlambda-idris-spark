# Idris compiler evidence

Source commit: `bb9abccd3eec626ce1aeac0894a75a6385ed898b`.

[Successful GitHub Actions run](https://github.com/AHMADALIPARR/unlambda-idris-spark/actions/runs/38025027084).

Runner: Ubuntu 24.04. Compiler: Idris 2 0.8.0, bootstrapped from upstream commit
`15a3e4e70843f7a34100f6470c04b791330788df`.

## Passed checks

- `idris2 --total --check LambdaProofs.idr`
- `idris2 --total --check Main.idr`
- `idris2 --total -o control-model Main.idr`
- Run `build/exec/control-model`; require exact output `step: advanced`.

The run retains the `idris-typecheck-evidence` artifact with version,
typechecker, build, and smoke-test logs. It also retains the prototype executable
as `idris-control-model-ubuntu24`. Artifact availability follows GitHub retention.

## What the checked proofs establish

- Explicit I/K/S beta-reduction witnesses for symbolic free atoms.
- Concrete substitution/capture-avoidance boundary cases.
- Fuel never increases in the current control model.
- A positive-fuel running transition consumes exactly one unit.
- Zero fuel reports `OutOfFuel`.
- `OutOfMemory` remains preserved through fuel handling.

## Remaining verification

The control model is still a stub; the smoke test is not an Unlambda semantic
test. ATS runtime compilation, SPARK heap verification, general substitution
lemmas, effectful semantics, and cross-language correspondence remain open.
No production release is certified by this run.

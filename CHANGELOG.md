# Changelog

## v1.0.0 — Verification scaffold

- Converted supplied heap/state sketches into ATS/Postiats-checked interfaces.
- Added handwritten I/K/S lambda derivations and explicit Idris beta witnesses.
- Added capture-avoidance examples, corrected fuel proofs, and explicit exhaustion status.
- Compiled the Idris control-model program and checked its output in CI.
- Strengthened Ada allocation contracts and tested capacity, exhaustion, and reset.
- Discharged all six SPARK checks for the allocation-counter model.
- Added pinned compiler/prover workflows and combined `verify.sh` validation.
- Recorded source-pinned verification reports and original sketch provenance.
- Added workflow diagrams, conceptual photographs, contribution/security policies,
  licensing-inquiry and support pages, repository description, topics, and badges.

The ATS evaluator, generation-checked slot-map heap, FFI adapter, full effectful
semantics, differential tests, and cross-language correspondence remain open.
Commercial license terms and a payment destination remain owner decisions.

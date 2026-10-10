<!--
Copyright (c) 2026 Ahmad Ali Parr. All rights reserved.
SPDX-License-Identifier: LicenseRef-Proprietary
Public source visibility does not grant an open-source license. See LICENSE.
-->

# Unlambda / Idris 2 / SPARK verification contract

## Scope of this executable slice

This starter project verifies a bounded heap model and a small abstract-machine control model. It is not yet a complete Unlambda implementation. Before adding the remaining language primitives, freeze the chosen Unlambda dialect and its operational semantics.

## Shared invariants

- H1: heap capacity is fixed and every valid index is in `0 .. Capacity - 1`.
- H2: `Used <= Capacity`.
- H3: allocation succeeds only when capacity remains; failure does not change `Used`.
- H4: a successful allocation increases `Used` by exactly one.
- M1: machine fuel never increases during a transition.
- M2: an exhausted machine reports `OutOfFuel`, never `Halted`.
- M3: the Idris model's state constructors make the terminal status explicit.

## Proof boundary

Idris 2 checks the model and its proof terms. SPARK/GNATprove checks Ada contracts and runtime-safety/functional verification conditions. Neither tool proves the other language's implementation. Agreement is established through the shared invariants, tests, and (later) a translation/correspondence proof.

## Escape-hatch policy

Reject `believe_me`, `assert_total`, `assert_smaller`, `sorry`, `admit`, `pragma Assume`, and unchecked imported proof claims in proof-bearing files unless a specific reviewed exception is documented. The scanner is a guardrail, not a sound proof of absence of unsoundness.

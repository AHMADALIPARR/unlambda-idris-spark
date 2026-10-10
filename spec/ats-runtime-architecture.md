# Unlambda ATS runtime specification

Supplied design notes. These describe intended behavior and proof obligations;
they do not claim that the current starter implements or verifies them.
The `ats/heap.sats` and `ats/state.sats` files are supplied interface sketches.

## Language semantics — Unlambda 2.0.0

Dialect: 2.0.0 GPL2+ from madore.org (as specified by the supplied notes).

Syntax: application, primitives `s k i v c d e r @ | .x ?x`.

Evaluation is strict except for `d`: `d x => Delayed(x)` without evaluating
`x`; `Delayed(x) y => Eval(x)` applied to `y`.

Reductions:

- `i x => x`
- `k x => K1(x)`; `K1(x) y => x`
- `s x => S1`; `s x y => S2`; `s x y z => x z y z`
- `v x => v`
- `.c x => print c, return x`; `r => newline`
- `e x => halt`
- `c x => capture K as Cont(K), eval x, apply x to Cont`
- `Cont(k) y => K=k, result y`
- `@ x => read byte, cur_char set, x i if byte else x v`
- `?c x => if cur_char==c then x i else x v`
- `| x => if cur_char Some(b) then x .b else x v`

Observables: output `O` is ordered; input cursor `I` is monotonic.

## Abstract machine

`Sigma=<C,K,H,I,O,F,Q>`

- `C=Ctrl_Term|Ctrl_Value`
- `K=list Frame`: `F_EvalArg(arg_term)`, `F_ApplyFun(fun_ref)`
- `H=slot-map NodeRef {slot,gen}`
- `I={buf,cursor,cur_char}`
- `O=vec OutChar`
- `F=fuel`
- `Q=Running|Halted|Failed|OutOfFuel|OutOfMemory`

Step: at most one transition, consumes one fuel. If `F==0`, set `OutOfFuel`.
Apply logic handles `d` specially in `EvalArg`: if `fun==D`, produce
`Delayed(arg_term)`; otherwise evaluate strictly.
Capture the continuation on `c`; restore it on `Cont` application.

## Memory model

Slot-map: slots contain generation plus state `Free|Occupied(Node)`;
maintain a free list, capacity, and live count.

`NodeRef` contains slot and generation. Allocation pops the free list and
checks generation. Lookup checks `gen==slot.gen` and `Occupied`, otherwise
returns `StaleRef`. Update performs the same checks. Free increments generation.

- H1: stored references valid at store time.
- H2: free list exact.
- H3: live count equals occupied count.
- H4: generation monotonic.
- H5: no dereference without lookup.

Capacity is fixed initially; `OutOfMemory` is explicit and leaves the heap valid.
Future GC roots: `C`, `K`, and continuation nodes.

## Invariants

- I1: stack references valid.
- I2: control valid.
- I3: heap satisfies H1–H5.
- I4: fuel decreases monotonically by one per transition.
- I5: output extends monotonically.
- I6: input cursor monotonic.
- I7: no hidden state.
- I8: status consistent.
- R1: `OutOfFuel != Halted`.
- R2: `OutOfMemory != Failed`.
- R3: `StaleRef` never dereferenced.

Intended ATS enforcement: abstract `term_ref` constructible only via parser,
abstract `NodeRef`, typed stack, abstract heap.
Runtime assertions: lookup before use, depth limit, spans.
Future proofs: `s,k,i` match SKI; `d` delays side effects; `c` captures/restores;
I/O preserves order.

## Gates

- A: heap safety.
- B: core machine `s,k,i,v,d,.,r`.
- C: all primitives.
- D: differential testing.
- E: garbage collection.

## Source materials

- [Architecture HTML](../docs/unlambda_x5f_ats_x5f_runtime_x5f_architecture.html)
- [Heap interface sketch](../ats/heap.sats)
- [State interface sketch](../ats/state.sats)

The supplied syntax sentence omits its application symbol, and the newline
rule does not specify an argument or return value. These details remain to be
resolved against the dialect before implementing the evaluator.

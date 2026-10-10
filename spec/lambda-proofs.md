# Handwritten lambda-calculus proofs: pure SKI fragment

Application associates to the left. Bound variables are alpha-renamed to avoid
capture. The implementation uses de Bruijn indices for bound variables and
separate free atoms; see `idris/LambdaProofs.idr`.

## Identity

`I = λa.a`

`I x = (λa.a) x →β x`.

Idris witness: `iBeta`, one `Contract`.

## Constant

`K = λa.λb.a`

`K x y = ((λa.λb.a) x) y →β (λb.x) y →β x`.

Idris witness: `kBeta`, two contractions, the first inside the function position.

## Substitution

`S = λa.λb.λc.(a c) (b c)`

`S x y z = (((λa.λb.λc.(a c) (b c)) x) y) z`

`→β ((λb.λc.(x c) (b c)) y) z`

`→β (λc.(x c) (y c)) z`

`→β (x z) (y z)`.

Idris witness: `sBeta`, three explicit contractions.

## Scope and remaining obligations

The Idris witnesses quantify over symbolic free atoms. They do not yet establish
substitution lemmas for arbitrary compound operands, confluence, or operational
equivalence of the ATS evaluator. Unlambda is strict and effectful: beta equality
of pure SKI terms alone cannot justify reordering output, input, delay, or
continuation operations.

SPARK verifies Ada heap safety and contracts. It does not check these lambda
proof terms or the Idris compiler. The production argument additionally needs
ATS-to-model simulation, a checked FFI contract, and correspondence evidence for
the Idris heap abstraction and the concrete Ada implementation.

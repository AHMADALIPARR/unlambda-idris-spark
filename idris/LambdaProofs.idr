module LambdaProofs

%default total

||| Locally nameless syntax: free atoms cannot be captured by a binder.
public export
data Lambda = Free Nat | Bound Nat | Lam Lambda | App Lambda Lambda

||| Shift bound indices at or above a cutoff when entering binders.
public export
shift : Nat -> Nat -> Lambda -> Lambda
shift amount cutoff (Free atom) = Free atom
shift amount cutoff (Bound index) =
  case compare index cutoff of
    LT => Bound index
    EQ => Bound (amount + index)
    GT => Bound (amount + index)
shift amount cutoff (Lam body) = Lam (shift amount (S cutoff) body)
shift amount cutoff (App fun arg) =
  App (shift amount cutoff fun) (shift amount cutoff arg)

||| Remove one binder, substituting its argument without variable capture.
public export
substitute : Nat -> Lambda -> Lambda -> Lambda
substitute depth argument (Free atom) = Free atom
substitute depth argument (Bound index) =
  case compare index depth of
    LT => Bound index
    EQ => shift depth Z argument
    GT => Bound (pred index)
substitute depth argument (Lam body) =
  Lam (substitute (S depth) argument body)
substitute depth argument (App fun arg) =
  App (substitute depth argument fun) (substitute depth argument arg)

public export
identity : Lambda
identity = Lam (Bound 0)

public export
constant : Lambda
constant = Lam (Lam (Bound 1))

public export
substitutionBody : Lambda
substitutionBody = Lam (Lam (App (App (Bound 2) (Bound 0))
                               (App (Bound 1) (Bound 0))))

public export
substitutionCombinator : Lambda
substitutionCombinator = Lam substitutionBody

||| One beta reduction, possibly in the function side of an application.
||| This relation describes the pure SKI fragment, not effectful evaluation.
public export
data BetaStep : Lambda -> Lambda -> Type where
  Contract : (body : Lambda) -> (argument : Lambda) ->
             BetaStep (App (Lam body) argument)
                      (substitute Z argument body)
  InFunction : BetaStep before after -> (argument : Lambda) ->
               BetaStep (App before argument) (App after argument)

public export
data BetaSteps : Lambda -> Lambda -> Type where
  Done : BetaSteps term term
  Then : BetaStep before middle -> BetaSteps middle after ->
         BetaSteps before after

||| I x -> x for every symbolic free atom x.
public export
iBeta : (x : Nat) -> BetaStep (App identity (Free x)) (Free x)
iBeta x = Contract (Bound 0) (Free x)

||| K x y -> x, with two explicit contractions.
public export
kBeta : (x, y : Nat) ->
        BetaSteps (App (App constant (Free x)) (Free y)) (Free x)
kBeta x y =
  Then (InFunction (Contract (Lam (Bound 1)) (Free x)) (Free y))
       (Then (Contract (Free x) (Free y)) Done)

||| S x y z -> (x z) (y z), with three explicit contractions.
public export
sBeta : (x, y, z : Nat) ->
        BetaSteps (App (App (App substitutionCombinator (Free x))
                           (Free y)) (Free z))
                  (App (App (Free x) (Free z)) (App (Free y) (Free z)))
sBeta x y z =
  Then (InFunction (InFunction (Contract substitutionBody (Free x))
                              (Free y)) (Free z))
       (Then (InFunction
               (Contract (Lam (App (App (Free x) (Bound 0))
                                   (App (Bound 1) (Bound 0))))
                         (Free y))
               (Free z))
             (Then (Contract (App (App (Free x) (Bound 0))
                                  (App (Free y) (Bound 0)))
                             (Free z)) Done))

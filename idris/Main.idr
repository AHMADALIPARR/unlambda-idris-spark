module Main

import Data.Nat

%default total

||| Abstract execution status. Resource exhaustion is not successful termination.
data Status = Running | Halted | OutOfFuel | OutOfMemory | Failed

||| Minimal control term for the first machine milestone.
||| Extend only after the selected Unlambda dialect is specified.
data Term = PrimI | PrimK | PrimS | Apply Term Term | Delay Term

record Machine where
  constructor MkMachine
  control : Term
  fuel : Nat
  status : Status

||| A transition outcome always records the next explicit machine status.
data Transition = Advanced Machine | Finished Machine

||| Fuel is consumed exactly once for an ordinary transition.
consumeFuel : Machine -> Machine
consumeFuel (MkMachine t Z Running) = MkMachine t Z OutOfFuel
consumeFuel (MkMachine t (S k) Running) = MkMachine t k Running
consumeFuel (MkMachine t n s) = MkMachine t n s

||| The transition function is intentionally a control-model stub until
||| the full Unlambda operational semantics are fixed in spec/.
stepControl : Machine -> Transition
stepControl m@(MkMachine _ Z Running) = Finished (consumeFuel m)
stepControl m@(MkMachine _ (S _) Running) = Advanced (consumeFuel m)
stepControl m = Finished m

||| A structural fact: consuming fuel never increases the fuel counter.
natLteRefl : (n : Nat) -> LTE n n
natLteRefl Z = LTEZero
natLteRefl (S n) = LTESucc (natLteRefl n)

natLteNext : (n : Nat) -> LTE n (S n)
natLteNext Z = LTEZero
natLteNext (S n) = LTESucc (natLteNext n)

fuelDoesNotIncrease : (m : Machine) -> fuel (consumeFuel m) `LTE` fuel m
fuelDoesNotIncrease (MkMachine t Z Running) = LTEZero
fuelDoesNotIncrease (MkMachine t (S k) Running) = natLteNext k
fuelDoesNotIncrease (MkMachine t n Halted) = natLteRefl n
fuelDoesNotIncrease (MkMachine t n OutOfFuel) = natLteRefl n
fuelDoesNotIncrease (MkMachine t n OutOfMemory) = natLteRefl n
fuelDoesNotIncrease (MkMachine t n Failed) = natLteRefl n

||| One running transition consumes exactly one unit, not two or zero.
positiveFuelConsumesOne : (t : Term) -> (n : Nat) ->
  fuel (consumeFuel (MkMachine t (S n) Running)) = n
positiveFuelConsumesOne t n = Refl

||| Heap exhaustion remains distinct from generic failure and termination.
memoryExhaustionIsPreserved : (t : Term) -> (n : Nat) ->
  status (consumeFuel (MkMachine t n OutOfMemory)) = OutOfMemory
memoryExhaustionIsPreserved t n = Refl

||| Resource exhaustion is explicit when a running machine has zero fuel.
zeroFuelIsNotHalted : (t : Term) -> status (consumeFuel (MkMachine t Z Running)) = OutOfFuel
zeroFuelIsNotHalted t = Refl

main : IO ()
main = do
  let initial = MkMachine PrimI 1 Running
  case stepControl initial of
    Advanced next => putStrLn "step: advanced"
    Finished next => putStrLn "step: finished"

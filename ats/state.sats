(* Typed contract for the planned machine. Implementations are pending. *)
staload H = "./heap.sats"

abstype term_ref = ptr

datatype status =
  | Running of ()
  | Halted of ()
  | Failed of ()
  | OutOfFuel of ()
  | OutOfMemory of ()

datatype control =
  | Ctrl_Term of term_ref
  | Ctrl_Value of $H.node_ref

datatype frame =
  | F_EvalArg of term_ref
  | F_ApplyFun of $H.node_ref

typedef input_state = @{
  buffer=List0(uchar), cursor=size_t, current=Option(uchar)
}

typedef machine_state = @{
  control=control,
  kont=List0(frame),
  heap=$H.heap,
  input=input_state,
  output=List0(uchar),
  fuel=intGte(0),
  status=status
}

fun state_invariant_holds (state: machine_state): bool
fun state_step (state: machine_state): machine_state

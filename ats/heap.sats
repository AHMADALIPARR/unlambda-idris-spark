(* Typed contract for the planned heap adapter. Implementations are pending. *)
abstype heap = ptr
abstype node_ref = ptr
abstype node = ptr

datatype heap_err =
  | StaleRef of ()
  | InvalidSlot of ()
  | OutOfMemory of ()

datatype heap_result (a:t@ype) =
  | HeapOK of a
  | HeapError of heap_err

fun heap_create (capacity: intGte(0)): heap_result(heap)
fun heap_alloc (h: heap, n: node): heap_result(node_ref)
fun heap_lookup (h: heap, r: node_ref): heap_result(node)
fun heap_update (h: heap, r: node_ref, n: node): heap_result(bool)
fun heap_free (h: heap, r: node_ref): heap_result(bool)
fun heap_live (h: heap): intGte(0)
fun heap_is_valid (h: heap): bool

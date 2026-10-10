package Heap_Model with SPARK_Mode is
   Capacity : constant := 64;
   subtype Index is Natural range 0 .. Capacity - 1;
   subtype Count is Natural range 0 .. Capacity;

   type Heap is private;

   function Used (H : Heap) return Count;

   procedure Reset (H : out Heap)
     with Post => Used (H) = 0;

   procedure Allocate (H : in out Heap; Success : out Boolean)
     with
       Pre  => Used (H) <= Capacity,
       Post =>
         Success = (Used (H'Old) < Capacity) and then
         (if Success then Used (H) = Used (H'Old) + 1
          else Used (H) = Used (H'Old));

private
   type Heap is record
      Allocated : Count := 0;
   end record;
end Heap_Model;

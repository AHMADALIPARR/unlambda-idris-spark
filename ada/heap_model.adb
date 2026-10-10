package body Heap_Model with SPARK_Mode is

   function Used (H : Heap) return Count is (H.Allocated);

   procedure Reset (H : out Heap) is
   begin
      H := (Allocated => 0);
   end Reset;

   procedure Allocate (H : in out Heap; Success : out Boolean) is
   begin
      if H.Allocated < Capacity then
         H.Allocated := H.Allocated + 1;
         Success := True;
      else
         Success := False;
      end if;
   end Allocate;

end Heap_Model;

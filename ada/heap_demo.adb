with Ada.Text_IO; use Ada.Text_IO;
with Heap_Model;

procedure Heap_Demo with SPARK_Mode is
   H : Heap_Model.Heap;
   Success : Boolean;
begin
   Heap_Model.Reset (H);
   Heap_Model.Allocate (H, Success);
   if Success and then Heap_Model.Used (H) = 1 then
      Put_Line ("heap contract smoke test: PASS");
   else
      Put_Line ("heap contract smoke test: FAIL");
   end if;
end Heap_Demo;

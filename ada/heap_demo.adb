-- Copyright (c) 2026 Ahmad Ali Parr. All rights reserved.
-- SPDX-License-Identifier: LicenseRef-Proprietary
-- Public source visibility does not grant an open-source license. See LICENSE.

with Ada.Text_IO; use Ada.Text_IO;
with Heap_Model;

--  Test driver: I/O is outside the proof boundary of Heap_Model.
procedure Heap_Demo is
   H : Heap_Model.Heap;
   Success : Boolean;
begin
   Heap_Model.Reset (H);
   pragma Assert (Heap_Model.Used (H) = 0);
   for Expected in 1 .. Heap_Model.Capacity loop
      Heap_Model.Allocate (H, Success);
      pragma Assert (Success);
      pragma Assert (Heap_Model.Used (H) = Expected);
   end loop;
   Heap_Model.Allocate (H, Success);
   pragma Assert (not Success);
   pragma Assert (Heap_Model.Used (H) = Heap_Model.Capacity);
   Heap_Model.Reset (H);
   pragma Assert (Heap_Model.Used (H) = 0);
   Heap_Model.Allocate (H, Success);
   pragma Assert (Success and then Heap_Model.Used (H) = 1);
   Put_Line ("heap contract smoke test: PASS");
end Heap_Demo;

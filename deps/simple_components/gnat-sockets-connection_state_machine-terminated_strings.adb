--                                                                    --
--  package                         Copyright (c)  Dmitry A. Kazakov  --
--     GNAT.Sockets.Connection_State_Machine.      Luebeck            --
--     Terminated_Strings                          Winter, 2012       --
--  Implementation                                                    --
--                                Last revision :  13:09 10 Mar 2013  --
--                                                                    --
--  This  library  is  free software; you can redistribute it and/or  --
--  modify it under the terms of the GNU General Public  License  as  --
--  published by the Free Software Foundation; either version  2  of  --
--  the License, or (at your option) any later version. This library  --
--  is distributed in the hope that it will be useful,  but  WITHOUT  --
--  ANY   WARRANTY;   without   even   the   implied   warranty   of  --
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU  --
--  General  Public  License  for  more  details.  You  should  have  --
--  received  a  copy  of  the GNU General Public License along with  --
--  this library; if not, write to  the  Free  Software  Foundation,  --
--  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.    --
--                                                                    --
--  As a special exception, if other files instantiate generics from  --
--  this unit, or you link this unit with other files to produce  an  --
--  executable, this unit does not by  itself  cause  the  resulting  --
--  executable to be covered by the GNU General Public License. This  --
--  exception  does not however invalidate any other reasons why the  --
--  executable file might be covered by the GNU Public License.       --
--____________________________________________________________________--

with Ada.Exceptions;         use Ada.Exceptions;
with Ada.IO_Exceptions;      use Ada.IO_Exceptions;
with Strings_Edit.Integers;  use Strings_Edit.Integers;

package body GNAT.Sockets.Connection_State_Machine.Terminated_Strings is

   procedure Feed
             (  Item    : in out String_Data_Item;
                Data    : Stream_Element_Array;
                Pointer : in out Stream_Element_Offset;
                Client  : in out State_Machine'Class;
                State   : in out Stream_Element_Offset
             )  is
      This : Character;
   begin
      if State = 0 then
         Item.Last := 0;
         State := 1;
      end if;
      while Pointer <= Data'Last loop
         This := Character'Val (Data (Pointer));
         if This = Item.Terminator then
            Pointer := Pointer + 1;
            State := 0;
            return;
         elsif Item.Last = Item.Value'Last then
            Raise_Exception
            (  Data_Error'Identity,
               (  "Terminated string length exceeds "
               &  Image (Item.Size)
               &  " characters"
            )  );
         else
            Item.Last := Item.Last + 1;
            Item.Value (Item.Last) := This;
            Pointer := Pointer + 1;
         end if;
      end loop;
   end Feed;

   function Get
            (  Data       : Stream_Element_Array;
               Pointer    : access Stream_Element_Offset;
               Terminator : Character
            )  return String is
      Next : Stream_Element_Offset := Pointer.all;
   begin
      if (  Next < Data'First
         or else
            (  Next > Data'Last
            and then
               Next > Data'Last + 1
         )  )
      then
         Raise_Exception
         (  Layout_Error'Identity,
            "Pointer is out of bounds"
         );
      end if;
      while Next <= Data'Last loop
         if Character'Val (Data (Next)) = Terminator then
            declare
               Result : String (1..Natural (Next - Pointer.all));
            begin
               Next := Pointer.all;
               for Index in Result'Range loop
                  Result (Index) := Character'Val (Data (Next));
                  Next := Next + 1;
               end loop;
               Pointer.all := Next + 1;
               return Result;
            end;
         else
            Next := Next + 1;
         end if;
      end loop;
      Raise_Exception
      (  End_Error'Identity,
         "Missing string terminator"
      );
   end Get;

   procedure Put
             (  Data       : in out Stream_Element_Array;
                Pointer    : in out Stream_Element_Offset;
                Value      : String;
                Terminator : Character
             )  is
   begin
      if (  Pointer < Data'First
         or else
            (  Pointer > Data'Last
            and then
               Pointer > Data'Last + 1
         )  )
      then
         Raise_Exception
         (  Layout_Error'Identity,
            "Pointer is out of bounds"
         );
      elsif Data'Last - Pointer < Value'Length then
         Raise_Exception
         (  End_Error'Identity,
            "No room for output"
         );
      end if;
      for Index in Value'Range loop
         if Value (Index) = Terminator then
            Raise_Exception
            (  Data_Error'Identity,
               "The string body contains the terminator"
            );
         end if;
      end loop;
      for Index in Value'Range loop
         Data (Pointer) := Character'Pos (Value (Index));
         Pointer := Pointer + 1;
      end loop;
      Data (Pointer) := Character'Pos (Terminator);
      Pointer := Pointer + 1;
   end Put;

end GNAT.Sockets.Connection_State_Machine.Terminated_Strings;

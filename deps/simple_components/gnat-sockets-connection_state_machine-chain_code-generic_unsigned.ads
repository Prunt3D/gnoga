--                                                                    --
--  package                         Copyright (c)  Dmitry A. Kazakov  --
--     GNAT.Sockets.Connection_State_Machine.      Luebeck            --
--     Chain_Code.Generic_Unsigned                 Winter, 2012       --
--  Interface                                                         --
--                                Last revision :  10:05 22 Nov 2014  --
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

generic
   type Number is range <>;
package GNAT.Sockets.Connection_State_Machine.Chain_Code.
        Generic_Unsigned is
--
-- Unsigned_Data_Item -- Chain-encoded unsigned number
--
   type Unsigned_Data_Item is new Data_Item with record
      Value : Number;
   end record;
--
-- Feed -- Implementation of the feed operation
--
   procedure Feed
             (  Item    : in out Unsigned_Data_Item;
                Data    : Stream_Element_Array;
                Pointer : in out Stream_Element_Offset;
                Client  : in out State_Machine'Class;
                State   : in out Stream_Element_Offset
             );
--
-- Get -- Number from stream element array
--
--    Data    - The stream element array
--    Pointer - The first element to read
--    Value   - The result
--
-- The parameter Pointer is advanced beyond the value obtained
--
-- Exceptions :
--
--    Data_Error   - The number is too large
--    End_Error    - Not enough data
--    Layout_Error - Pointer is outside bounds
--
   procedure Get
             (  Data    : in out Stream_Element_Array;
                Pointer : in out Stream_Element_Offset;
                Value   : out Number
             );
--
-- Put -- Number into stream element array
--
--    Data    - The stream element array
--    Pointer - The first element to write
--    Value   - The value to encode
--
-- The parameter Pointer is advanced beyond the value output
--
-- Exceptions :
--
--    Constraint_Error - Negative value
--    End_Error        - No room for output
--    Layout_Error     - Pointer is outside bounds
--
   procedure Put
             (  Data    : in out Stream_Element_Array;
                Pointer : in out Stream_Element_Offset;
                Value   : Number
             );
private
   pragma Assert (Stream_Element'Size = 8);

end GNAT.Sockets.Connection_State_Machine.Chain_Code.Generic_Unsigned;

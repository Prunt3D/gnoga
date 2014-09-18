------------------------------------------------------------------------------
--                                                                          --
--                   GNOGA - The GNU Omnificent GUI for Ada                 --
--                                                                          --
--                        G N O G A . W I N D O W                           --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                                                                          --
--                     Copyright (C) 2014 David Botton                      --
--                                                                          --
--  This library is free software;  you can redistribute it and/or modify   --
--  it under terms of the  GNU General Public License  as published by the  --
--  Free Software  Foundation;  either version 3,  or (at your  option) any --
--  later version. This library is distributed in the hope that it will be  --
--  useful, but WITHOUT ANY WARRANTY;  without even the implied warranty of --
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                    --
--                                                                          --
--  As a special exception under Section 7 of GPL version 3, you are        --
--  granted additional permissions described in the GCC Runtime Library     --
--  Exception, version 3.1, as published by the Free Software Foundation.   --
--                                                                          --
--  You should have received a copy of the GNU General Public License and   --
--  a copy of the GCC Runtime Library Exception along with this program;    --
--  see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see   --
--  <http://www.gnu.org/licenses/>.                                         --
--                                                                          --
--  As a special exception, if other files instantiate generics from this   --
--  unit, or you link this unit with other files to produce an executable,  --
--  this  unit  does not  by itself cause  the resulting executable to be   --
--  covered by the GNU General Public License. This exception does not      --
--  however invalidate any other reasons why the executable file  might be  --
--  covered by the  GNU Public License.                                     --
--                                                                          --
-- For more information please go to http://www.gnoga.com                   --
------------------------------------------------------------------------------

with Ada.Strings.Unbounded;

with Gnoga.Connections;

package body Gnoga.Window is

   ------------
   -- Attach --
   ------------

   overriding procedure Attach
     (Window        : in out Window_Type;
      Connection_ID : in     Gnoga.Types.Connection_ID;
      ID            : in     String                     := "window";
      ID_Type       : in     Gnoga.Types.ID_Enumeration := Gnoga.Types.Script)
   is
      use type Gnoga.Types.ID_Enumeration;
   begin
      if ID_Type = Gnoga.Types.DOM_ID then
         raise Invalid_ID_Type;
      end if;

      Gnoga.Base.Attach (Object        => Gnoga.Base.Base_Type (Window),
                         Connection_ID => Connection_ID,
                         ID            => ID,
                         ID_Type       => ID_Type);

      Window.DOM_Document.Attach (Connection_ID, ID, ID_Type);

      Window.Location.Attach
        (Connection_ID => Connection_ID,
         ID            => Window.jQuery & ".prop ('location')",
         ID_Type       => Gnoga.Types.Script);
   end Attach;

   procedure Attach
     (Window  : in out Window_Type;
      Parent  : in out Window_Type'Class;
      ID      : in     String;
      ID_Type : in     Gnoga.Types.ID_Enumeration := Gnoga.Types.Script)
   is
      use type Gnoga.Types.ID_Enumeration;

      CID : String := Gnoga.Connections.Execute_Script
        (Parent.Connection_ID,
         Base.Script_Accessor (ID, ID_Type) & ".gnoga['Connection_ID']");
   begin
      if ID_Type = Gnoga.Types.DOM_ID then
         raise Invalid_ID_Type;
      end if;

      Attach (Window, Gnoga.Types.Connection_ID'Value (CID));
   exception
      when others =>
         Log ("Unable to find gnoga['Connection_ID'] on " & ID &
                " eval returned : " & CID);
         raise Not_A_Gnoga_Window;
   end Attach;

   --------------
   -- Reattach --
   --------------

   procedure Reattach (Window : in out Window_Type;
                       Parent : in out Window_Type'Class)
   is
      CID : String := Gnoga.Connections.Execute_Script
        (Parent.Connection_ID,
         Base.Script_Accessor (Window.ID, Window.ID_Type) &
           ".gnoga['Connection_ID']");
   begin
      Window.Connection_ID (Gnoga.Types.Connection_ID'Value (CID));
   end Reattach;

   --------------
   -- Document --
   --------------

   function Document (Window : Window_Type)
                      return Gnoga.Document.Document_Access
   is
   begin
      return Window.DOM_Document'Unrestricted_Access;
   end Document;

   --------------
   -- Location --
   --------------

   function Location (Window : Window_Type)
                      return Gnoga.Location.Location_Access
   is
   begin
      return Window.Location'Unrestricted_Access;
   end Location;

   ----------
   -- Name --
   ----------

   procedure Name (Window : in out Window_Type; Value : String) is
   begin
      Window.Property ("name", Value);
   end Name;

   ----------
   -- Name --
   ----------

   function Name (Window : Window_Type) return String is
   begin
      return Window.Property ("name");
   end Name;

   ------------------
   -- Inner_Height --
   ------------------

   procedure Inner_Height (Window : in out Window_Type; Value : in Integer) is
   begin
      Window.Property ("innerHeight", Value);
   end Inner_Height;

   ------------------
   -- Inner_Height --
   ------------------

   function Inner_Height (Window : Window_Type) return Integer is
   begin
      return Window.Property ("innerHeight");
   end Inner_Height;

   -----------------
   -- Inner_Width --
   -----------------

   procedure Inner_Width (Window : in out Window_Type; Value : in Integer) is
   begin
      Window.Property ("innerWidth", Value);
   end Inner_Width;

   -----------------
   -- Inner_Width --
   -----------------

   function Inner_Width (Window : Window_Type) return Integer is
   begin
      return Window.Property ("innerWidth");
   end Inner_Width;

   ------------------
   -- Outer_Height --
   ------------------

   procedure Outer_Height (Window : in out Window_Type; Value : in Integer) is
   begin
      Window.Property ("outerHeight", Value);
   end Outer_Height;

   ------------------
   -- Outer_Height --
   ------------------

   function Outer_Height (Window : Window_Type) return Integer is
   begin
      return Window.Property ("outerHeight");
   end Outer_Height;

   -----------------
   -- Outer_Width --
   -----------------

   procedure Outer_Width (Window : in out Window_Type; Value : in Integer) is
   begin
      Window.Property ("outerWidth", Value);
   end Outer_Width;

   -----------------
   -- Outer_Width --
   -----------------

   function Outer_Width (Window : Window_Type) return Integer is
   begin
      return Window.Property ("outerWidth");
   end Outer_Width;

   --------------
   -- X_Offset --
   --------------

   function X_Offset (Window : Window_Type) return Integer is
   begin
      return Window.Property ("pageXOffset");
   end X_Offset;

   --------------
   -- Y_Offset --
   --------------

   function Y_Offset (Window : Window_Type) return Integer is
   begin
      return Window.Property ("pageYOffset");
   end Y_Offset;

   ---------
   -- Top --
   ---------

   function Top (Window : Window_Type) return Integer is
   begin
      return Window.Property ("screenY");
   end Top;

   ----------
   -- Left --
   ----------

   function Left (Window : Window_Type) return Integer is
   begin
      return Window.Property ("screenX");
   end Left;

   ----------------------
   -- Search_Parameter --
   ----------------------

   function Search_Parameter (Window : Window_Type; Name  : String)
                              return String
   is
   begin
      return Gnoga.Connections.Search_Parameter (Window.Connection_ID, Name);
   end Search_Parameter;
   ------------
   -- Launch --
   ------------

   procedure Launch (Window   : in out Window_Type;
                     Parent   : in out Window_Type'Class;
                     URL      : in     String;
                     Width    : in     Integer := -1;
                     Height   : in     Integer := -1;
                     Left     : in     Integer := -1;
                     Top      : in     Integer := -1;
                     Menu     : in     Boolean := False;
                     Status   : in     Boolean := False;
                     Tool_Bar : in     Boolean := False;
                     Title    : in     Boolean := False)
   is
      GID : constant String := Gnoga.Connections.New_GID;

      function Params return String is
         use Ada.Strings.Unbounded;

         P : Unbounded_String;
         C : Boolean := False;

         procedure Add_Param (S : String; V : String) is
         begin
            if C then
               P := P & ", ";
            end if;

            P := P & To_Unbounded_String (S) & "=" & To_Unbounded_String (V);
            C := True;
         end Add_Param;
      begin
         if Width > -1 then
            Add_Param ("width", Width'Img);
         end if;

         if Height > -1 then
            Add_Param ("height", Height'Img);
         end if;

         if Top > -1 then
            Add_Param ("top", Top'Img);
         end if;

         if Left > -1 then
            Add_Param ("left", Left'Img);
         end if;

         Add_Param ("menubar", Menu'Img);
         Add_Param ("status", Status'Img);
         Add_Param ("toolbar", Tool_Bar'Img);
         Add_Param ("menubar", Menu'Img);
         Add_Param ("titlebar", Title'Img);

         return To_String (P);
      end Params;

   begin
      Window.Create_With_Script
        (Connection_ID => Parent.Connection_ID,
         ID            => GID,
         Script        => "gnoga['" & GID & "']=" & Parent.jQuery &
           ".get(0).open ('" & URL & "', '_blank', '" & Params & "')",
         ID_Type       => Gnoga.Types.Gnoga_ID);

      Window.DOM_Document.Attach
        (Parent.Connection_ID, GID, Gnoga.Types.Gnoga_ID);

      Window.Location.Attach
        (Connection_ID => Parent.Connection_ID,
         ID            => Window.jQuery & ".prop ('location')",
         ID_Type       => Gnoga.Types.Script);
   end Launch;

   -----------
   -- Alert --
   -----------

   procedure Alert (Window : in out Window_Type; Message : String) is
   begin
      Window.Execute ("alert (""" & Escape_Quotes (Message) & """);");
   end Alert;

   ---------
   -- Log --
   ---------

   procedure Log (Window : in out Window_Type; Message : String) is
   begin
      Window.Execute ("console.log (""" & Escape_Quotes (Message) & """);");
   end Log;

   -----------
   -- Error --
   -----------

   procedure Error (Window : in out Window_Type; Message : String) is
   begin
      Window.Execute ("console.error (""" & Escape_Quotes (Message) & """);");
   end Error;

   -----------
   -- Close --
   -----------

   procedure Close (Window : in out Window_Type) is
   begin
      Window.Execute ("close();");
   end Close;

   -----------
   -- Print --
   -----------

   procedure Print (Window : in out Window_Type) is
   begin
      Window.Execute ("print();");
   end Print;

   ---------------
   -- Resize_By --
   ---------------

   procedure Resize_By
     (Window : in out Window_Type;
      Width, Height : Integer)
   is
   begin
      Window.Execute ("resizeBy(" & Width'Img & "," & Height'Img & ");");
   end Resize_By;

   ---------------
   -- Resize_To --
   ---------------

   procedure Resize_To
     (Window : in out Window_Type;
      Width, Height : Integer)
   is
   begin
      Window.Execute ("resizeTo(" & Width'Img & "," & Height'Img & ");");
   end Resize_To;

   -------------
   -- Move_By --
   -------------

   procedure Move_By (Window : in out Window_Type; X, Y : Integer) is
   begin
      Window.Execute ("moveBy(" & X'Img & "," & Y'Img & ");");
   end Move_By;

   -------------
   -- Move_To --
   -------------

   procedure Move_To (Window : in out Window_Type; X, Y : Integer) is
   begin
      Window.Execute ("moveTo(" & X'Img & "," & Y'Img & ");");
   end Move_To;

   ---------------
   -- Scroll_By --
   ---------------

   procedure Scroll_By (Window : in out Window_Type; X, Y : Integer) is
   begin
      Window.Execute ("scrollBy(" & X'Img & "," & Y'Img & ");");
   end Scroll_By;

   ---------------
   -- Scroll_To --
   ---------------

   procedure Scroll_To (Window : in out Window_Type; X, Y : Integer) is
   begin
      Window.Execute ("scrollTo(" & X'Img & "," & Y'Img & ");");
   end Scroll_To;

end Gnoga.Window;

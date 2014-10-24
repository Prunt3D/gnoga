------------------------------------------------------------------------------
--                                                                          --
--                   GNOGA - The GNU Omnificent GUI for Ada                 --
--                                                                          --
--     G N O G A . G U I . P L U G I N . J Q U E R Y U I . W I D G E T      --
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

package body Gnoga.Gui.Plugin.jQueryUI.Widget is

   -------------
   --  Create --
   -------------

   overriding
   procedure Create
     (View    : in out Accordion_Type;
      Parent  : in out Gnoga.Gui.Base.Base_Type'Class;
      Attach  : in     Boolean := True;
      ID      : in     String  := "")
   is
   begin
      Gnoga.Gui.View.View_Type (View).Create (Parent, Attach, ID);
   end Create;

   procedure Create_Section
     (View : in out Accordion_Type; Heading : String)
   is
   begin
      View.Put_HTML ("<h3>" & Escape_Quotes (Heading) & "</h3>");
   end Create_Section;

   ----------------------
   -- Render_Accordion --
   ----------------------

   procedure Render_Accordion
     (View           : in out Accordion_Type;
      Allow_Collapse : in     Boolean := False)
   is
      function params return String;

      function params return String is
      begin
         if Allow_Collapse = False then
            return "";
         else
            return "{ collapsible: true }";
         end if;
      end params;
   begin
      View.jQuery_Execute ("accordion(" & params & ")");
   end Render_Accordion;

   -----------------
   -- Make_Button --
   -----------------

   procedure Make_Button
     (Element    : in out Gnoga.Gui.Element.Element_Type'Class;
      Left_Icon  : in     String  := "";
      Right_Icon : in     String  := "";
      No_Text    : in     Boolean := False)
   is
      function params return String;

      function params return String is
         function Is_No_Text return String;
         function Is_Icon return String;

         function Is_No_Text return String is
         begin
            if No_Text then
               return "false";
            else
               return "true";
            end if;
         end Is_No_Text;

         function Is_Icon return String is
         begin
            if Left_Icon = "" and Right_Icon = "" then
               return "";
            else
               return ", icons: { primary: """ & Left_Icon & """," &
                 "secondary: """ & Right_Icon & """}";
            end if;
         end Is_Icon;
      begin
         return "{ text: " & Is_No_Text & Is_Icon & "}";
      end params;
   begin
      Element.jQuery_Execute ("button(" & Escape_Quotes (params) & ")");
   end Make_Button;

   ---------------------
   -- Make_Button_Set --
   ---------------------

   procedure Make_Button_Set
     (View : in out Gnoga.Gui.View.View_Base_Type'Class)
   is
   begin
      View.jQuery_Execute ("buttonset()");
   end Make_Button_Set;

   ------------
   -- Create --
   ------------

   procedure Create
     (Dialog          : in out Dialog_Type;
      Parent          : in out Gnoga.Gui.Base.Base_Type'Class;
      Title           : in     String;
      Content         : in     String  := "";
      Height          : in     Natural := 0;
      Width           : in     Natural := 0;
      Position_My     : in     String  := "center";
      Position_At     : in     String  := "center";
      Resizable       : in     Boolean := False;
      Minimum_Height  : in     Natural := 150;
      Minimum_Width   : in     Natural := 150;
      Maximum_Height  : in     Natural := 0;
      Maximum_Width   : in     Natural := 0;
      Modal           : in     Boolean := True;
      Close_On_Escape : in     Boolean := True;
      Draggable       : in     Boolean := True;
      ID              : in     String  := "")
   is
      function Is_Auto (N : Natural) return String;
      function Is_False (N : Natural) return String;

      function Is_Auto (N : Natural) return String is
      begin
         if N = 0 then
            return " 'auto'";
         else
            return N'Img;
         end if;
      end Is_Auto;

      function Is_False (N : Natural) return String is
      begin
         if N = 0 then
            return " 'false'";
         else
            return N'Img;
         end if;
      end Is_False;
   begin
      Dialog.Create_From_HTML
        (Parent, "<div>" & Escape_Quotes (Content) & "</div>", ID);

      Dialog.jQuery_Execute
        ("dialog({title: """ & Escape_Quotes (Title) & """," &
           "height:" & Is_Auto (Height) & "," &
           "width:" & Is_Auto (Width) & "," &
           "position: { my: '" & Position_My & "', at: '" &
           Position_At & "', of: window }," &
           "resizable: " & Resizable'Img & "," &
           "minHeight:" & Minimum_Height'Img & "," &
           "minWidth:" & Minimum_Width'Img & "," &
           "height:" & Is_Auto (Height) & "," &
           "width:" & Is_Auto (Width) & "," &
           "maxHeight:" & Is_False (Maximum_Height) & "," &
           "maxWidth:" & Is_False (Maximum_Height) & "," &
           "modal: " & Modal'Img & "," &
           "closeOnEscape: " & Close_On_Escape'Img & "," &
           "draggable: " & Draggable'Img & "})");
   end Create;

   procedure Close (Dialog : in out Dialog_Type) is
   begin
      Dialog.jQuery_Execute ("dialog(""close"")");
   end Close;

   function Is_Open (Dialog : in out Dialog_Type) return Boolean is
   begin
      return Dialog.jQuery_Execute ("dialog(""isOpen"")") = "true";
   end Is_Open;

   procedure Open (Dialog : in out Dialog_Type) is
   begin
      Dialog.jQuery_Execute ("dialog(""open"")");
   end Open;

   ---------------
   -- Make_Menu --
   ---------------

   procedure Make_Menu
     (List : in out Gnoga.Gui.Element.List.Unordered_List_Type'Class)
   is
   begin
      List.jQuery_Execute ("menu()");
   end Make_Menu;

   -----------------------
   -- Turn_On_Tool_Tips --
   -----------------------

   procedure Turn_On_Tool_Tips
     (Window : in out Gnoga.Gui.Window.Window_Type'Class)
   is
   begin
      Window.Document.jQuery_Execute ("tooltip()");
   end Turn_On_Tool_Tips;

   ------------------
   -- Add_Tool_Tip --
   ------------------

   procedure Add_Tool_Tip
     (Element : in out Gnoga.Gui.Element.Element_Type'Class;
      Tip     : in     String)
   is
   begin
      Element.Attribute ("title", Tip);
   end Add_Tool_Tip;

end Gnoga.Gui.Plugin.jQueryUI.Widget;

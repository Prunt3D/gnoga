with Gnoga.Application.Multi_Connect;
with Gnoga.Gui.Window;
with Gnoga.Gui.View.Console;
with Gnoga.Gui.Base;
with Gnoga.Gui.Element;
with Gnoga.Gui.Element.Common;
with Gnoga.Types;

with Gnoga.Gui.Element.Form.Fieldset;
with Gnoga.Gui.Element.Form.Data_List;

procedure Demo is
   use Gnoga;
   use Gnoga.Types;
   use Gnoga.Gui;
   use Gnoga.Gui.Element;

   type App_Data is new Connection_Data_Type with
      record
         Main_Window : Window.Pointer_To_Window_Class;
         Console     : View.Console.Console_View_Type;
         FSet        : Form.Fieldset.Fieldset_Type;
         My_Form     : Form.Form_Type;
         My_List     : Form.Data_List.Data_List_Type;
         My_Input    : Form.Text_Type;
      end record;
   type App_Access is access all App_Data;

   procedure On_Click2 (Object : in out Gnoga.Gui.Base.Base_Type'Class) is
      App : App_Access := App_Access (Object.Connection_Data);
   begin
      App.Console.Put_Line ("Dynamic reasign of click handler worked");
      Object.On_Click_Handler (null);
      App.Console.Put_Line ("Click handler now set to null - disabled");
   end On_Click2;

   procedure On_Click (Object : in out Gnoga.Gui.Base.Base_Type'Class)
   is
      App : App_Access := App_Access (Object.Connection_Data);
      D : Common.DIV_Access;
   begin
      For i in 1 .. 50 loop
         D := new Common.DIV_Type;
         D.Dynamic;
         D.Create (App.Console, "This is a dynamic DIV");
      end loop;
      App.Console.Put_Line ("Changing click handler.");
      Object.On_Click_Handler (On_Click2'Unrestricted_Access);
   end On_Click;

   procedure On_Connect
     (Main_Window : in out Gnoga.Gui.Window.Window_Type'Class;
      Connection  : access Gnoga.Application.Multi_Connect.Connection_Holder_Type)
   is
      App     : App_Access := new App_Data;
      Play    : Common.Button_Access := new Common.Button_Type;
   begin
      Main_Window.Connection_Data (App.all);

      App.Main_Window := Main_Window'Unchecked_Access;

      App.Console.Create (Main_Window);

      App.My_Form.Create (App.Console);

      App.FSet.Create (App.My_Form);
      App.FSet.Put_Legend ("My set");

      Play.Dynamic;
      Play.Create (App.FSet, "Click Me");
      Play.On_Click_Handler (On_Click'Unrestricted_Access);

      App.FSet.New_Line;

      App.My_List.Create (App.My_Form, "stuff");
      App.My_List.Add_Option ("thing1");
      App.My_List.Add_Option ("abcde");
      App.My_List.Add_Option ("1234");

      App.My_Input.Create (Form  => App.My_Form,
                           Size  => 40);
      App.My_Input.Place_Inside_Bottom_Of (App.FSet);
      App.My_Input.Data_List ("stuff");
      App.My_Input.Auto_Complete;
   end On_Connect;

begin
   Application.Multi_Connect.Initialize (Event => On_Connect'Unrestricted_Access,
                                     Boot  => "debug.html");

   Application.Title ("Test App for Gnoga");
   Application.HTML_On_Close
     ("<b>Connection to Application has been terminated</b>");

   Application.Multi_Connect.Message_Loop;
end Demo;

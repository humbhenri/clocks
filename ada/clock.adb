with Gtk.Main;
with Gtk.Enums;
with Gtk.Window; use Gtk.Window;
with Gtk.Handlers;
with Gtk.Drawing_Area; use Gtk.Drawing_Area;
with Callbacks;
with Glib.Main; use Glib.Main;
with Gtk.Widget; use Gtk.Widget;

procedure Clock is
    Timeout : G_Source_Id;

    Main_Window : Gtk_Window;
    Canvas : Gtk_Drawing_Area;

    package Gui_Timeout is new Glib.Main.Generic_Sources(Gtk_Drawing_Area);

    function Refresh(Canvas: Gtk_Drawing_Area) return Boolean is
    begin
        Canvas.Queue_Draw;
        return True;
    end Refresh;

    procedure Create_Window is
    begin
        Gtk.Window.Gtk_New
            (Window   => Main_Window,
            The_Type => Gtk.Enums.Window_Toplevel);
        Gtk.Window.Set_Title (Window => Main_Window, Title  => "Clock with Ada");
        Gtk.Window.Set_Default_Size(Window => Main_Window, Width => 1026, Height => 768);
        Main_Window.On_Destroy(Callbacks.Quit'Access);
        Gtk.Drawing_Area.Gtk_New(Canvas);
        Main_Window.Add(Canvas);
        Canvas.On_Draw(Callbacks.Draw'Access);
        Gtk.Window.Show_All (Main_Window);

    end Create_Window;

begin
    Gtk.Main.Init;
    Create_Window;
    Timeout := Gui_Timeout.Timeout_Add(1000, Refresh'Access, Canvas);
    Gtk.Main.Main;
end Clock;

with Gtk.Main;
with Gtk.Enums;
with Gtk.Window;
with Gtk.Handlers;
with Gtk.Drawing_Area;
with Callbacks;

procedure Clock is

    procedure Create_Window is
        Main_Window : Gtk.Window.Gtk_Window;
        Canvas: Gtk.Drawing_Area.Gtk_Drawing_Area;

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

    --  Signal handling loop
    Gtk.Main.Main;

end Clock;

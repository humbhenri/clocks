with Gtk.Main;
with Gtk.Enums;
with Gtk.Window;
with Gtk.Handlers;
with Window_Callback;

procedure Clock is

    procedure Create_Window is
        Main_Window : Gtk.Window.Gtk_Window;

    begin
        Gtk.Window.Gtk_New
            (Window   => Main_Window,
            The_Type => Gtk.Enums.Window_Toplevel);

        Gtk.Window.Set_Title (Window => Main_Window, Title  => "Clock");

        Window_Callback.Window_Cb.Connect(Main_Window, "delete_event", Window_Callback.Quit'Access);

        Gtk.Window.Show_All (Main_Window);

    end Create_Window;

begin
    --  Set the locale specific datas (e.g time and date format)
    --  Gtk.Main.Set_Locale;

    --  Initializes GtkAda
    Gtk.Main.Init;

    --  Create the main window
    Create_Window;

    --  Signal handling loop
    Gtk.Main.Main;

end Clock;

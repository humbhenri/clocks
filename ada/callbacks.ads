with Gtk.Window;
with Gtk.Handlers;

package Callbacks is 
    package Cb is new Gtk.Handlers.Return_Callback(
        Gtk.Window.Gtk_Window_Record, 
        Boolean);
    function Quit (Widget: access Gtk.Window.Gtk_Window_Record'Class) 
        return Boolean;
end Callbacks;


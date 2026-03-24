with Gtk.Window;
with Gtk.Handlers;

package Window_Callback is 
    package Window_Cb is new Gtk.Handlers.Return_Callback(
        Gtk.Window.Gtk_Window_Record, 
        Boolean);
    function Quit (Widget: access Gtk.Window.Gtk_Window_Record'Class) 
        return Boolean;
end Window_Callback;


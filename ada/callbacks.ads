with Gtk.Widget; use Gtk.Widget;
with Cairo; use Cairo;

package Callbacks is
    procedure Quit (Widget: access Gtk_Widget_Record'Class);
    function Draw (Canvas: access Gtk_Widget_Record'Class; context: in Cairo_Context)
        return boolean;
end Callbacks;

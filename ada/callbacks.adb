with Gtk.Main;
use Gtk.Main;
with Gtk.Widget;
use Gtk.Widget;
with Cairo; 
use Cairo;
with Ada.Text_IO;
use Ada.Text_IO;

package body Callbacks is
    procedure Quit
        (Widget: access Gtk_Widget_Record'class)
    is
    begin
        Main_Quit;
    end Quit;

    function Draw (
		canvas	: access Gtk_Widget_Record'class;
		context	: in Cairo_Context)
		return boolean
	is
		result : boolean := true;
	begin
		put_line ("cb_draw");

		set_line_width (context, 1.0);
		set_source_rgb (context, 1.0, 0.0, 0.0);

		rectangle (context, 1.0, 1.0, 100.0, 100.0);
		stroke (context);
		
		return result;
	end Draw;
end Callbacks;

with Gtk.Main; use Gtk.Main;
with Gtk.Widget; use Gtk.Widget;
with Cairo; use Cairo;
with Ada.Text_IO; use Ada.Text_IO;
with glib; use glib;
with Ada.Numerics;
with Ada.Calendar; use Ada.Calendar;
with Gtk.Drawing_Area; use Gtk.Drawing_Area;

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
		return Boolean
	is
		result : Boolean := true;
                width : Gint;
                height : Gint;
                center_x : Gdouble;
                center_y : Gdouble;
                radius: Gdouble;
                Now : Time;
                Now_Seconds: Day_Duration;
                Hours: Integer;
                Minutes: Integer;
                Secs: Integer;
	begin
                width := Get_Allocated_Width(canvas);
                height := Get_Allocated_Height(canvas);
                center_x := Gdouble(width) / 2.0;
                center_y := Gdouble(height) / 2.0;
                radius := Gdouble'Min(center_x, center_y) / 2.0;
                Now := Clock;
                Now_Seconds := Seconds(Now);
                Hours := Integer(Now_Seconds) / 3600;
                Minutes := (Integer(Now_Seconds) mod 3600) / 60;
                Secs := Integer(Now_Seconds) mod 60;

                Put_Line("now is " & Now_Seconds'Image);
                Put_Line("hours is " & Hours'Image);
                Put_Line("minutes is " & Minutes'Image);
                Put_Line("seconds is " & Secs'Image);

                Arc(context, center_x, center_y, radius, Gdouble(0), 2.0 * Ada.Numerics.PI);
                Stroke(context);
                return result;
	end Draw;
end Callbacks;

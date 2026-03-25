with Gtk.Main; use Gtk.Main;
with Gtk.Widget; use Gtk.Widget;
with Cairo; use Cairo;
with Ada.Text_IO; use Ada.Text_IO;
with glib; use glib;
with Ada.Numerics;
with Ada.Calendar; use Ada.Calendar;
with Gtk.Drawing_Area; use Gtk.Drawing_Area;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;

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
        center_x : Float;
        center_y : Float;
        radius: Float;
        Now : Time;
        Now_Seconds: Day_Duration;
        Hours: Integer;
        Minutes: Integer;
        Secs: Integer;

        procedure Draw_Clock_Hand(Size: Float; Value: Integer) is
            function Radian(Value: Integer) return Float is
            begin
                return (Float(Value) * Ada.Numerics.Pi / 30.0) - Ada.Numerics.Pi / 2.0;
            end Radian;
        begin
            Move_To(context, GDouble(center_x), GDouble(center_y));
            Line_To(context, GDouble(center_x + Size * Cos(Radian(Value))), GDouble(center_y + size * Sin(Radian(Value))));
            Stroke(context);
        end Draw_Clock_Hand;

    begin
        Width := Get_Allocated_Width(Canvas);
        Height := Get_Allocated_Height(Canvas);
        Center_x := Float(Width) / 2.0;
        Center_y := Float(Height) / 2.0;
        Radius := Float'Min(Center_x, Center_y) / 2.0;
        Now := Clock;
        Now_Seconds := Seconds(Now);
        Hours := Integer(Now_Seconds) / 3600;
        Minutes := (Integer(Now_Seconds) mod 3600) / 60;
        Secs := Integer(Now_Seconds) mod 60;

        Put_Line("now is " & Now_Seconds'Image);
        Put_Line("hours is " & Hours'Image);
        Put_Line("minutes is " & Minutes'Image);
        Put_Line("seconds is " & Secs'Image);

        Arc(Context, GDouble(Center_x), GDouble(Center_y), GDouble(Radius), GDouble(0), 2.0 * Ada.Numerics.PI);
        Stroke(Context);

        Set_Line_Width(Context, 2.0 * Get_Line_Width(Context));
        Draw_Clock_Hand(Radius/4.0, (Hours*5) mod 60);

        Set_Line_Width(Context, 0.5 * Get_Line_Width(Context));
        Draw_Clock_Hand(Radius/2.0, Minutes mod 60);

        Set_Source_RGB(Context, 1.0, 0.0, 0.0);
        Draw_Clock_Hand(Radius * 0.75, Secs mod 60);

        return result;
    end Draw;
end Callbacks;

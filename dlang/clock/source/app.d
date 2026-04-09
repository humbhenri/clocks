import raylib;
import std.datetime.systime : SysTime, Clock;
import std.stdio;
import std.algorithm;
import std.math;

double radian(double x) {
  return (x * raylib.PI/30.0)/(raylib.PI/2.0);
}

double handX(double val, double size) {
  return size * cos(radian(val));
}

double handY(double val, double size) {
  return size * sin(radian(val));
}

void main()
{
    validateRaylibBinding();
    InitWindow(1024, 768, "Clock made with Raylib-D!");
    SetTargetFPS(10);
    SetWindowState(ConfigFlags.FLAG_WINDOW_RESIZABLE);
    while (!WindowShouldClose())
    {
      auto date = Clock.currTime();
      auto w = GetScreenWidth();
      auto h = GetScreenHeight();
      auto cx = w/2;
      auto cy = h/2;
      auto radius = min(w, h) * 0.3;
      auto hourHand = radius * 0.5;
      auto minuteHand = radius * 0.75;
      auto secondHand = radius * 0.9;
      auto hourX = cx + handX((date.hour * 5) % 60, hourHand);
      auto hourY = cy + handY((date.hour * 5) % 60, hourHand);
      auto minuteX = cx + handX(date.minute, minuteHand);
      auto minuteY = cy + handY(date.minute, minuteHand);
      auto secondX = cx + handX(date.second, secondHand);
      auto secondY = cy + handY(date.second, secondHand);
      BeginDrawing();
      ClearBackground(Colors.RAYWHITE);
      DrawCircleLines(cx, cy, radius, Colors.BLACK);
      DrawLineEx(Vector2(cast(int)cx, cast(int)cy), Vector2(cast(int)hourX, cast(int)hourY), 3.0, Colors.BLACK);
      DrawLineEx(Vector2(cast(int)cx, cast(int)cy), Vector2(cast(int)minuteX, cast(int)minuteY), 2.0, Colors.LIGHTGRAY);
      DrawLineEx(Vector2(cast(int)cx, cast(int)cy), Vector2(cast(int)secondX, cast(int)secondY), 2.0, Colors.RED);
      EndDrawing();
    }
    CloseWindow();
}

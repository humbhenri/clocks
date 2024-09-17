#include <stdio.h>
#include <stdlib.h>
#include <raylib.h>
#include <math.h>
#include <time.h>

#define W 1024
#define H 768
#define RADIAN(x) (((x) * M_PI/30.0) - (M_PI/2.0))
#define HOUR(x) (((x) * 5) % 60)
#define HANDX(val, size) (W/2 + (size) * cos(RADIAN(val)))
#define HANDY(val, size) (H/2 + (size) * sin(RADIAN(val)))

int main(void) {
  InitWindow(W, H, "Clocks");
  float radius = 360.;
  float hourHandSize = 180.;
  float minuteHandSize = 200.;
  float secondHandSize = 300.;  
  while (!WindowShouldClose()) {
    struct tm *timeinfo;
    time_t rawtime;
    time(&rawtime);
    timeinfo = localtime(&rawtime);
    int hours = timeinfo->tm_hour;
    int minutes = timeinfo->tm_min;
    int seconds = timeinfo->tm_sec;
    int endHourX = HANDX(HOUR(hours), hourHandSize);
    int endHourY = HANDY(HOUR(hours), hourHandSize);
    int endMinuteX = HANDX(minutes, minuteHandSize);
    int endMinuteY = HANDY(minutes, minuteHandSize);
    int endSecondX = HANDX(seconds, secondHandSize);
    int endSecondY = HANDY(seconds, secondHandSize);
    BeginDrawing();
    ClearBackground(WHITE);
    DrawCircleLines(W/2, H/2, radius, BLACK);
    DrawLine(W/2, H/2, endHourX, endHourY, BLACK);
    DrawLine(W/2, H/2, endMinuteX, endMinuteY, LIGHTGRAY);
    DrawLine(W/2, H/2, endSecondX, endSecondY, RED);
    EndDrawing();
  }
  CloseWindow();
  return 0;
}

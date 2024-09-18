#include <stdio.h>
#include <stdlib.h>
#include <raylib.h>
#include <math.h>
#include <time.h>

#define RADIAN(x) (((x) * M_PI/30.0) - (M_PI/2.0))
#define HOUR(x) (((x) * 5) % 60)
#define HANDX(val, size) ((size) * cos(RADIAN(val)))
#define HANDY(val, size) ((size) * sin(RADIAN(val)))
#define MIN(x, y) ((x) < (y) ? (x) : (y))

int main(void) {
  InitWindow(1024, 768, "Clocks");
  SetTargetFPS(10);
  SetWindowState(FLAG_WINDOW_RESIZABLE);
  while (!WindowShouldClose()) {
    struct tm *timeinfo;
    time_t rawtime;
    time(&rawtime);
    timeinfo = localtime(&rawtime);
    int screenWidth = GetScreenWidth();
    int screenHeight = GetScreenHeight();
    int centerX = screenWidth/2;
    int centerY = screenHeight/2;
    float radius = MIN(screenWidth, screenHeight)*0.3;
    float hourHandSize = radius*0.5;
    float minuteHandSize = radius*0.75;
    float secondHandSize = radius*0.9;
    int hours = timeinfo->tm_hour;
    int minutes = timeinfo->tm_min;
    int seconds = timeinfo->tm_sec;
    int endHourX = centerX + HANDX(HOUR(hours), hourHandSize);
    int endHourY = centerY + HANDY(HOUR(hours), hourHandSize);
    int endMinuteX = centerX + HANDX(minutes, minuteHandSize);
    int endMinuteY = centerY + HANDY(minutes, minuteHandSize);
    int endSecondX = centerX + HANDX(seconds, secondHandSize);
    int endSecondY = centerY + HANDY(seconds, secondHandSize);
    BeginDrawing();
    ClearBackground(WHITE);
    DrawCircleLines(centerX, centerY, radius, BLACK);
    DrawLine(centerX, centerY, endHourX, endHourY, BLACK);
    DrawLine(centerX, centerY, endMinuteX, endMinuteY, LIGHTGRAY);
    DrawLine(centerX, centerY, endSecondX, endSecondY, RED);
    EndDrawing();
  }
  CloseWindow();
  return 0;
}

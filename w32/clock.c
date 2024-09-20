#ifndef UNICODE
#define UNICODE
#endif

#include <stdio.h>
#include <windows.h>
#include <wingdi.h>
#include <time.h>
#include <math.h>

#define RADIAN(x) (((x) * M_PI/30.0) - (M_PI/2.0))
#define HOUR(x) (((x) * 5) % 60)
#define HANDX(val, size) ((size) * cos(RADIAN(val)))
#define HANDY(val, size) ((size) * sin(RADIAN(val)))
#define MIN(x, y) ((x) < (y) ? (x) : (y))

#define IDT_TIMER1 1

#define CLIENT_WIDTH  800
#define CLIENT_HEIGHT 600

LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam);

int WINAPI wWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, PWSTR pCmdLine, int nCmdShow)
{
    const wchar_t CLASS_NAME[]  = L"Clock";

    WNDCLASS wc = { };

    wc.lpfnWndProc   = WindowProc;
    wc.hInstance     = hInstance;
    wc.lpszClassName = CLASS_NAME;
    wc.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1); // White background

    RegisterClass(&wc);
    RECT rect = { 0, 0, CLIENT_WIDTH, CLIENT_HEIGHT };
    AdjustWindowRect(&rect, WS_OVERLAPPEDWINDOW, FALSE);

    HWND hwnd = CreateWindowEx(
        0,                              // Optional window styles.
        CLASS_NAME,                     // Window class
        L"Clock",    // Window text
        WS_OVERLAPPEDWINDOW,            // Window style

        // Size and position
        CW_USEDEFAULT, CW_USEDEFAULT, rect.right - rect.left, rect.bottom - rect.top,

        NULL,       // Parent window
        NULL,       // Menu
        hInstance,  // Instance handle
        NULL        // Additional application data
        );

    if (hwnd == NULL)
    {
        return 0;
    }

    ShowWindow(hwnd, nCmdShow);
    SetTimer(hwnd, IDT_TIMER1, 1000, (TIMERPROC) NULL);

    // Run the message loop.

    MSG msg = { };
    while (GetMessage(&msg, NULL, 0, 0) > 0)
    {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }

    return 0;
}

LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
    switch (uMsg)
    {
    case WM_DESTROY:
        KillTimer(hwnd, IDT_TIMER1);
        PostQuitMessage(0);
        return 0;

    case WM_PAINT:
        {
            PAINTSTRUCT ps;
            HDC hdc = BeginPaint(hwnd, &ps);

            HPEN blackPen = CreatePen(PS_SOLID, 1, RGB(0, 0, 0));
            HPEN bluePen = CreatePen(PS_SOLID, 1, RGB(0, 0, 255));
            HPEN redPen = CreatePen(PS_SOLID, 1, RGB(255, 0, 0));
            HBRUSH hBrush = CreateSolidBrush(RGB(255, 255, 255));

            SelectObject(hdc, blackPen);
            SelectObject(hdc, hBrush);

            RECT rc;
            GetClientRect(hwnd, &rc);

            int width = rc.right - rc.left;
            int height = rc.bottom - rc.top;
            int radius = min(width, height) / 4;

            int centerX = width / 2;
            int centerY = height / 2;

            Ellipse(hdc, centerX - radius, centerY - radius, centerX + radius, centerY + radius);

            struct tm *timeinfo;
            time_t rawtime;
            time(&rawtime);
            timeinfo = localtime(&rawtime);
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
            SelectObject(hdc, bluePen);
            MoveToEx(hdc, centerX, centerY, NULL);
            LineTo(hdc, endHourX, endHourY);
            MoveToEx(hdc, centerX, centerY, NULL);
            LineTo(hdc, endMinuteX, endMinuteY);
            SelectObject(hdc, redPen);
            MoveToEx(hdc, centerX, centerY, NULL);
            LineTo(hdc, endSecondX, endSecondY);

            // Cleanup GDI objects
            DeleteObject(blackPen);
            DeleteObject(redPen);
            DeleteObject(bluePen);
            DeleteObject(hBrush);

            EndPaint(hwnd, &ps);
        }
        return 0;

    case WM_SIZE:
        InvalidateRect(hwnd, NULL, TRUE);
        return 0;

    case WM_TIMER:
        InvalidateRect(hwnd, NULL, TRUE);
        return 0;

    }
    return DefWindowProc(hwnd, uMsg, wParam, lParam);
}

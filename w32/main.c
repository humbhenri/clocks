#ifndef UNICODE
#define UNICODE
#endif

#include <stdio.h>
#include <windows.h>
#include <wingdi.h>

LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam);

int WINAPI wWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, PWSTR pCmdLine, int nCmdShow)
{
    // Register the window class.
    const wchar_t CLASS_NAME[]  = L"Clock";

    WNDCLASS wc = { };

    wc.lpfnWndProc   = WindowProc;
    wc.hInstance     = hInstance;
    wc.lpszClassName = CLASS_NAME;
    wc.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1); // White background

    RegisterClass(&wc);

    // Create the window.

    HWND hwnd = CreateWindowEx(
        0,                              // Optional window styles.
        CLASS_NAME,                     // Window class
        L"Clock",    // Window text
        WS_OVERLAPPEDWINDOW,            // Window style

        // Size and position
        CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT,

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
        PostQuitMessage(0);
        return 0;

    case WM_PAINT:
        {
            PAINTSTRUCT ps;
            HDC hdc = BeginPaint(hwnd, &ps);

             // Set the pen and brush for drawing
            HPEN hPen = CreatePen(PS_SOLID, 1, RGB(0, 0, 0)); // Black pen for the outline
            HBRUSH hBrush = CreateSolidBrush(RGB(255, 255, 255)); // White brush for filling

            SelectObject(hdc, hPen);
            SelectObject(hdc, hBrush);

            RECT rc;
            GetClientRect(hwnd, &rc);

            // Calculate the center and radius for the circle
            int width = rc.right - rc.left;
            int height = rc.bottom - rc.top;
            int radius = min(width, height) / 4;  // Radius is 1/4th of the smallest dimension

            int centerX = width / 2;
            int centerY = height / 2;

            // Draw the circle (GDI Ellipse function draws an ellipse inside the given rectangle)
            Ellipse(hdc, centerX - radius, centerY - radius, centerX + radius, centerY + radius);

            // Cleanup GDI objects
            DeleteObject(hPen);
            DeleteObject(hBrush);

            EndPaint(hwnd, &ps);
        }
        return 0;

    case WM_SIZE:
        InvalidateRect(hwnd, NULL, TRUE);


    }
    return DefWindowProc(hwnd, uMsg, wParam, lParam);
}

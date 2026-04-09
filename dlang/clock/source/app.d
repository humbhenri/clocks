import raylib;

void main()
{
    // call this before using raylib
    validateRaylibBinding();
    InitWindow(800, 600, "Hello, Raylib-D!");
    SetTargetFPS(60);
    while (!WindowShouldClose())
    {
        BeginDrawing();
        ClearBackground(Colors.RAYWHITE);
        DrawText("Hello, World!", 400, 300, 28, Colors.BLACK);
        EndDrawing();
    }
    CloseWindow();
}

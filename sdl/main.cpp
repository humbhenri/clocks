#include <SDL2/SDL.h>
#include <cstdio>
#include <cmath>
#include <ctime>
#include <chrono>
#include <tuple>

const int SCREEN_WIDTH = 640;
const int SCREEN_HEIGHT = 480;
const int CLOCK_RADIUS = 200;
const int FPS=60;

void drawCircle(SDL_Renderer * renderer);

double radian(double x);

int hour(int x);

void drawClockHand(SDL_Renderer * renderer, double size, int value);

std::tuple<int, int, int> getTime();

int main(int argc, char *args[])
{
    SDL_Window *window = NULL;
    SDL_Renderer* gRenderer = NULL;
    SDL_Surface *screenSurface = NULL;
    bool quit;
    SDL_Event e;
    int waittime = 1000.0f/FPS;
    int framestarttime = 0;
    int delaytime;

    if (SDL_Init(SDL_INIT_VIDEO) < 0)
    {
        printf("SDL could not initialize! SDL_Error: %s\n", SDL_GetError());
    }
    else
    {
        if( !SDL_SetHint( SDL_HINT_RENDER_SCALE_QUALITY, "1" ) )
        {
            printf( "Warning: Linear texture filtering not enabled!" );
        }
        window = SDL_CreateWindow("SDL Clock", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, SCREEN_WIDTH, SCREEN_HEIGHT, SDL_WINDOW_SHOWN);
        if (window == NULL)
        {
            printf("Window could not be created! SDL_Error: %s\n", SDL_GetError());
        }
        else
        {
            gRenderer = SDL_CreateRenderer( window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC );
            if( gRenderer == NULL )
			{
				printf( "Renderer could not be created! SDL Error: %s\n", SDL_GetError() );
				return 1;
			}
            screenSurface = SDL_GetWindowSurface(window);
            while(!quit)
            {
                while(SDL_PollEvent(&e) != 0)
                {
                    if (e.type == SDL_QUIT)
                    {
                        printf("Quit");
                        quit = true;
                    }
                }
                //Clear screen
				SDL_SetRenderDrawColor( gRenderer, 0xFF, 0xFF, 0xFF, 0xFF );
				SDL_RenderClear( gRenderer );

                const auto [hours, minutes, seconds] = getTime();

                // Draw clock
                SDL_SetRenderDrawColor(gRenderer, 0, 0, 0, 255);
                drawCircle(gRenderer);
                drawClockHand(gRenderer, 100, hour(hours));
                drawClockHand(gRenderer, 150, minutes);
                SDL_SetRenderDrawColor(gRenderer, 255, 0, 0, 255);
                drawClockHand(gRenderer, 150, seconds);

                // Update screen
                SDL_RenderPresent( gRenderer );

                // control FPS
                delaytime = waittime - (SDL_GetTicks() - framestarttime);
                if (delaytime > 0)
                    SDL_Delay(delaytime);
                framestarttime = SDL_GetTicks();
            }
        }
        SDL_DestroyWindow(window);
        SDL_DestroyRenderer(gRenderer);
        SDL_Quit();
        return 0;
    }
}

void drawCircle(SDL_Renderer * renderer)
{
    const int radius = CLOCK_RADIUS;
    const int centreX = SCREEN_WIDTH/2;
    const int centreY = SCREEN_HEIGHT/2;
    const int diameter = (radius * 2);

    int x = (radius - 1);
    int y = 0;
    int tx = 1;
    int ty = 1;
    int error = (tx - diameter);

    while (x >= y)
    {
        //  Each of the following renders an octant of the circle
        SDL_RenderDrawPoint(renderer, centreX + x, centreY - y);
        SDL_RenderDrawPoint(renderer, centreX + x, centreY + y);
        SDL_RenderDrawPoint(renderer, centreX - x, centreY - y);
        SDL_RenderDrawPoint(renderer, centreX - x, centreY + y);
        SDL_RenderDrawPoint(renderer, centreX + y, centreY - x);
        SDL_RenderDrawPoint(renderer, centreX + y, centreY + x);
        SDL_RenderDrawPoint(renderer, centreX - y, centreY - x);
        SDL_RenderDrawPoint(renderer, centreX - y, centreY + x);

        if (error <= 0)
        {
            ++y;
            error += ty;
            ty += 2;
        }

        if (error > 0)
        {
            --x;
            tx += 2;
            error += (tx - diameter);
        }
    }
}

double radian(int x)
{
    return (x * M_PI/30.0) - (M_PI/2.0);
}

int hour(int x)
{
    return (x * 5) % 60;
}

void drawClockHand(SDL_Renderer * renderer, double size, int value)
{
    const int centreX = SCREEN_WIDTH/2;
    const int centreY = SCREEN_HEIGHT/2;
    SDL_RenderDrawLine(renderer,
                       centreX,
                       centreY,
                       centreX + size * cos(radian(value)),
                       centreY + size * sin(radian(value)));
}

std::tuple<int, int, int> getTime()
{
    const auto now = std::chrono::system_clock::now();
    const auto tt = std::chrono::system_clock::to_time_t(now);
    const auto local_tm = *std::localtime(&tt);
    const auto hours = local_tm.tm_hour;
    const auto minutes = local_tm.tm_min;
    const auto seconds = local_tm.tm_sec;
    return std::make_tuple(hours, minutes, seconds);
}

#include <X11/Xlib.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <unistd.h>

#define WIDTH 300
#define HEIGHT 300
#define MIN(x, y) ((x) < (y) ? (x) : (y))
#define SLEEP_MS(m) (usleep((m) * 1000))

void draw_circle(Display *dpy, Window win, GC gc, int xc, int yc, int radius) {
  XDrawArc(dpy, win, gc, xc - radius, yc - radius, radius * 2, radius * 2, 0, 360 * 64);
}

void draw_hand(Display *dpy, Window win, GC gc, int xc, int yc, double angle, int length) {
  int x_end = xc + length * sin(angle);
  int y_end = yc - length * cos(angle);  
  XDrawLine(dpy, win, gc, xc, yc, x_end, y_end);
}

int main() {
  Display *dpy;
  Window win;
  GC gc;
  XEvent e;
  int screen;

  dpy = XOpenDisplay(NULL);
  if (dpy == NULL) {
    fprintf(stderr, "Unable to connect to X server\n");
    exit(1);
  }

  screen = DefaultScreen(dpy);
  win = XCreateSimpleWindow(dpy, RootWindow(dpy, screen), 10, 10, WIDTH, HEIGHT, 1, 
                            BlackPixel(dpy, screen), WhitePixel(dpy, screen));
  XSelectInput(dpy, win, ExposureMask | KeyPressMask);
  XMapWindow(dpy, win);
  gc = XCreateGC(dpy, win, 0, NULL);
  // Set up window close (Alt+F4) handling
  Atom wm_delete_window = XInternAtom(dpy, "WM_DELETE_WINDOW", False);
  XSetWMProtocols(dpy, win, &wm_delete_window, 1);

  XSelectInput(dpy, win, ExposureMask | KeyPressMask | StructureNotifyMask);

  int sleep_interval = 1000;
  int time_to_update = 0;
  struct tm *timeinfo;
  time_t rawtime;
  time(&rawtime);
  while (1) {
    SLEEP_MS(1);
    
    // Check for keypress events to exit the loop
    if (XPending(dpy)) {
      XEvent e;
      XNextEvent(dpy, &e);

      if (e.type == ClientMessage) {
        if (e.xclient.data.l[0] == wm_delete_window) {
          printf("Window close event received. Exiting...\n");
          break;
        }
      }
    }
    time_to_update = (time_to_update+1) % sleep_interval;
    if (time_to_update != 0) {
      continue;
    }
    
    rawtime++;
    timeinfo = localtime(&rawtime);
    
    XWindowAttributes wa;
    XGetWindowAttributes(dpy, win, &wa);
    int width = wa.width;
    int height = wa.height;
    
    int xc = width / 2;
    int yc = height / 2;

    float clock_radius = 0.8 * MIN(width, height)/2.0;

    XClearWindow(dpy, win);
            
    draw_circle(dpy, win, gc, xc, yc, clock_radius);
            
    double second_angle = (M_PI / 30) * timeinfo->tm_sec;
    double minute_angle = (M_PI / 30) * timeinfo->tm_min + (M_PI / 1800) * timeinfo->tm_sec;
    double hour_angle = (M_PI / 6) * (timeinfo->tm_hour % 12) + (M_PI / 360) * timeinfo->tm_min;

    draw_hand(dpy, win, gc, xc, yc, second_angle, clock_radius*0.9); // Second hand
    draw_hand(dpy, win, gc, xc, yc, minute_angle, clock_radius*0.75); // Minute hand
    draw_hand(dpy, win, gc, xc, yc, hour_angle, clock_radius*0.5);   // Hour hand
    XFlush(dpy);        
    
  }

  XFreeGC(dpy, gc);
  XDestroyWindow(dpy, win);
  XCloseDisplay(dpy);

  return 0;
}


/*
 * A clock widget shows a analogical clock
 */

#ifndef __CLOCK_WIDGET
#define __CLOCK_WIDGET

#include <gtk/gtk.h>
#include <cairo.h>

#define CLOCK_TYPE (clock_get_type())
#define CLOCK(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), CLOCK_TYPE, Clock))
#define CLOCK_CLASS(obj) (G_TYPE_CHECK_CLASS_CAST ((obj), CLOCK, ClockClass))
#define IS_CLOCK(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), CLOCK_TYPE))
#define IS_CLOCK_CLASS(obj) (G_TYPE_CHECK_CLASS_TYPE ((obj), CLOCK_TYPE))
#define CLOCK_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), CLOCK_TYPE, ClockClass))

typedef struct _Clock Clock;
typedef struct _ClockClass ClockClass;

struct _Clock {
  GtkDrawingArea parent;
  gint hoursHand;
  gint minutesHand;
  gint secondsHand;
};

struct _ClockClass {
  GtkDrawingAreaClass parent_class;
};

/* widget public methods */
GtkWidget * gtk_clock_new();
void clock_tick(Clock*);
void clock_redraw_canvas(Clock*);

#endif


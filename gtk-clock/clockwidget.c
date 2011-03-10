#include "clockwidget.h"
#include <time.h>
#include <math.h>

#define RADIAN(x) (((x) * M_PI/30.0) - M_PI/2.0)

G_DEFINE_TYPE (Clock, clock, GTK_TYPE_DRAWING_AREA);


/* one second passes */
void clock_tick(Clock *clock)
{
	clock->secondsHand = (clock->secondsHand + 1) % 60;
	if (clock->secondsHand == 0) {
		clock->minutesHand = (clock->minutesHand + 1) % 60;
		if (clock->minutesHand == 0) {
			clock->hoursHand = (clock->hoursHand + 5) % 60;
		}
	}
}


void clock_redraw_canvas(Clock *clock)
{
	/*GtkWidget *widget;
	GdkRegion *region;
	widget = GTK_WIDGET (clock);

	if (!widget->window) return;

	region = gdk_drawable_get_clip_region (widget->window);
	[> redraw the cairo canvas completely by exposing it <]
	gdk_window_invalidate_region (widget->window, region, TRUE);
	gdk_window_process_updates (widget->window, TRUE);

	gdk_region_destroy (region);*/
	gtk_widget_queue_draw(GTK_WIDGET(clock));
}

static gboolean
clock_expose(GtkWidget *clock, GdkEventExpose *event)
{
	double x, y;
	x = clock->allocation.x + clock->allocation.width / 2;
	y = clock->allocation.y + clock->allocation.height / 2;
	double radius = MIN (clock->allocation.width / 2,
			clock->allocation.height / 2) *0.5;
	cairo_t *cr;
	cr = gdk_cairo_create(clock->window);

	//draw circle
	cairo_arc(cr, x, y, radius, 0, 2*M_PI);
	cairo_set_source_rgb(cr, 0, 0, 0);
	cairo_fill_preserve(cr);
	cairo_stroke(cr);

	// draw hands
	double hoursHandSize = 0.25 * radius;
	double minutesHandSize = 0.5 * radius;
	double secondsHandSize = 0.75 * radius;

	cairo_set_line_width(cr, 2 * cairo_get_line_width(cr));
	cairo_set_source_rgb(cr, 0, 255, 0);
	cairo_move_to(cr, x, y);
	cairo_line_to(cr, x + hoursHandSize * cos(RADIAN(CLOCK(clock)->hoursHand)), 
			y + hoursHandSize * sin(RADIAN(CLOCK(clock)->hoursHand)));

	cairo_move_to(cr, x, y);
	cairo_line_to(cr, x + minutesHandSize * cos(RADIAN(CLOCK(clock)->minutesHand)), 
			y + minutesHandSize * sin(RADIAN(CLOCK(clock)->minutesHand)));
	cairo_stroke(cr);

	cairo_set_source_rgb(cr, 255, 0, 0);
	cairo_set_line_width(cr, 0.25 * cairo_get_line_width(cr));
	cairo_move_to(cr, x, y);
	cairo_line_to(cr, x + secondsHandSize * cos(RADIAN(CLOCK(clock)->secondsHand)), 
			y + secondsHandSize * sin(RADIAN(CLOCK(clock)->secondsHand)));	
	
	cairo_stroke(cr);
	cairo_destroy(cr);
	return FALSE;
}


 static void
 clock_class_init (ClockClass *class)
 {
        GtkWidgetClass *widget_class;

        widget_class = GTK_WIDGET_CLASS (class);

        widget_class->expose_event = clock_expose;
 }


static void
clock_init(Clock *clock)
{
	/* get local time  and translate it to angles*/
	time_t now;
	struct tm* timeinfo;
	time(&now);
	timeinfo = localtime(&now);
	clock->hoursHand = (timeinfo->tm_hour%12) * 5;
	clock->minutesHand = timeinfo->tm_min;
	clock->secondsHand = timeinfo->tm_sec;
}


GtkWidget*
clock_new(void) 
{
	return g_object_new (CLOCK_TYPE, NULL);
}



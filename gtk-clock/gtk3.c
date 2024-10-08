#include <math.h>
#include <gtk/gtk.h>
#include <time.h>

#define WIDTH 600
#define HEIGHT 600

#define RADIAN(x) (((x) * G_PI/30.0) - G_PI/2.0)

#define HOUR(x) (((x) * 5) % 60)

static int hour = 12;
static int minute = 15;
static int second = 30;

static void update_time();
gboolean paint_clock (GtkWidget *widget, cairo_t *cr, gpointer data);
static void activate (GtkApplication* app, gpointer user_data);

int main (int argc, char **argv)
{
	GtkApplication *app;
	int status;

  update_time();

	app = gtk_application_new ("org.gtk.example", G_APPLICATION_FLAGS_NONE);
	g_signal_connect (app, "activate", G_CALLBACK (activate), NULL);
	status = g_application_run (G_APPLICATION (app), argc, argv);
	g_object_unref (app);

	return status;
}

void draw_clock_hand(cairo_t *cr, gint center_x, gint center_y, double size, gint value)
{
  cairo_move_to(cr, center_x, center_y);
  cairo_line_to(cr, center_x + size * cos(RADIAN(value)),
                center_y + size * sin(RADIAN(value)));
  cairo_stroke(cr);
}

gboolean paint_clock (GtkWidget *widget, cairo_t *cr, gpointer data)
{
  gint width = gtk_widget_get_allocated_width(widget);
  gint height = gtk_widget_get_allocated_height(widget);
  gint center_x = width/2.0;
  gint center_y = height/2.0;
	double radius = MIN (width / 2, height / 2) / 2;
  GtkStyleContext *context = gtk_widget_get_style_context(widget);
  gtk_render_background(context, cr, 0, 0, width, height);

  // draw clock arc
  cairo_arc (cr, center_x, center_y, radius, 0, 2 * G_PI);
  GdkRGBA color;
  gtk_style_context_get_color (context, gtk_style_context_get_state (context), &color);
  gdk_cairo_set_source_rgba (cr, &color);
  cairo_stroke(cr);

  // draw hour hand
  cairo_set_line_width(cr, 2 * cairo_get_line_width(cr));
  draw_clock_hand(cr, center_x, center_y, radius/4.0, HOUR(hour));

  // draw minute hand
  cairo_set_line_width(cr, 0.5 * cairo_get_line_width(cr));
  draw_clock_hand(cr, center_x, center_y, radius/2.0, minute);

  // draw second hand
  color.red = 1;
  gdk_cairo_set_source_rgba (cr, &color);
  draw_clock_hand(cr, center_x, center_y, 0.75 * radius, second);

  return FALSE;
}

static void update_time()
{
  time_t t = time(NULL);
  struct tm *tm_struct = localtime(&t);
  hour = tm_struct->tm_hour;
  minute = tm_struct->tm_min;
  second = tm_struct->tm_sec;
}

gboolean update_clock(gpointer widget)
{
  update_time();
  gtk_widget_queue_draw((GtkWidget*) widget);
  return TRUE;
}

static void activate (GtkApplication* app, gpointer user_data)
{
	GtkWidget *window, *drawing_area;

	window = gtk_application_window_new (app);
	gtk_window_set_title (GTK_WINDOW (window), "Clock");

	drawing_area = gtk_drawing_area_new();
	gtk_container_add (GTK_CONTAINER (window), drawing_area);
	gtk_widget_set_size_request(drawing_area, WIDTH, HEIGHT);
	g_signal_connect (G_OBJECT (drawing_area), "draw", 
		G_CALLBACK (paint_clock), NULL);

	gtk_widget_show_all (window);

	g_timeout_add(1000, update_clock, (gpointer) drawing_area);
}

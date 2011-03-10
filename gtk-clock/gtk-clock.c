/*
 * compilation: gcc -o gtk-clock gtk-clock.c clockwidget.c `pkg-config --libs --cflags gtk+-2.0
 */

#include "clockwidget.h"

gboolean updateClock (gpointer data)
{
	Clock *clock = CLOCK(data);
	clock_tick(clock);
	clock_redraw_canvas(clock);
	return TRUE;
}

int main(int argc, char* argv[])
{
	gtk_init(&argc, &argv);

	/* create the main window */
	int width = 400;
	int height = 400;
	GtkWidget *window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
	gtk_window_set_default_size(GTK_WINDOW(window), width, height);
	g_signal_connect_swapped(G_OBJECT(window), "destroy",
      G_CALLBACK(gtk_main_quit), NULL);
	GtkWidget *vbox = gtk_vbox_new(TRUE, 1);
	gtk_container_add(GTK_CONTAINER(window), vbox);

	/* add the clock widget */
	GtkWidget *clock = clock_new();
	gtk_box_pack_start(GTK_BOX(vbox), clock, TRUE, TRUE, 0);

	gtk_widget_show_all(window);

	g_timeout_add(1000, updateClock, (gpointer) clock);

	gtk_main();

	return 0;
}


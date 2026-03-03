/**
 * valac --pkg -X -lm gtk4 main.vala
 */
public class Clock : Gtk.Application {
	public static int main(string[] args) {
		var app = new Clock();
		return app.run(args);
	}

	public override void activate() {
		var window = new Gtk.ApplicationWindow(this) {
				title = "Clock", default_width = 800, default_height = 600
		};
		var da = new Gtk.DrawingArea();
		da.set_draw_func(this.paint_clock);
		window.child = da;
		window.present();
	}

	private void paint_clock(Gtk.DrawingArea w, Cairo.Context ctx, int width, int height) {
		int center_x = (int) (width / 2.0);
		int center_y = (int) (height / 2.0);
		double radius = Math.fmin(width / 2, height / 2) / 2;
		stdout.printf("w = %d, h = %d, x = %d, y = %d, radius = %f\n", width, height, center_x, center_y, radius);
		ctx.set_source_rgb(0.0, 0.0, 0.0);
		ctx.set_line_width(2.0);
		ctx.arc(center_x, center_y, radius, 0, 2 * Math.PI);
		ctx.stroke();
	}
}
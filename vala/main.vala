public class Clock : Gtk.Application {

	private int hour;
	private int minute;
	private int second;
	private uint thread_id;
	private Gtk.DrawingArea da;

	public static int main(string[] args) {
		var app = new Clock();
		return app.run(args);
	}

	public override void activate() {
		this.update_time();
		var window = new Gtk.ApplicationWindow(this) {
				title = "Clock", default_width = 800, default_height = 600
		};
		this.da = new Gtk.DrawingArea();
		da.set_draw_func(this.paint_clock);
		window.child = da;
		window.present();
		thread_id = Timeout.add(1000, update_clock);
	}

	private void update_time() {
		var now = new DateTime.now_local();
		hour = now.get_hour();
		minute = now.get_minute();
		second = now.get_second();
		print("Now is %02d:%02d:%02d\n", hour, minute, second);
	}

	private void paint_clock(Gtk.DrawingArea w, Cairo.Context ctx, int width, int height) {
		int center_x = (int) (width / 2.0);
		int center_y = (int) (height / 2.0);
		double radius = Math.fmin(width / 2, height / 2) / 2;
		stdout.printf("w = %d, h = %d, x = %d, y = %d, radius = %f\n", width, height, center_x, center_y, radius);

		ctx.set_source_rgb(0.0, 0.0, 0.0);
		ctx.set_line_width(2.0);
		draw_clock_arc(ctx, center_x, center_y, radius);

		draw_clock_hand(ctx, center_x, center_y, radius/2.0, get_hour(this.hour));

		ctx.set_line_width(1.0);
		draw_clock_hand(ctx, center_x, center_y, radius*0.75, this.minute);

		ctx.set_source_rgb(1.0, 0.0, 0.0);
		draw_clock_hand(ctx, center_x, center_y, radius*0.75, this.second);
	}

	private int get_hour(int value) {
		return (value * 5) % 60;
	}

	private double to_radian(double value) {
		return (value * Math.PI/30.0) - (Math.PI/2.0);
	}

	private void draw_clock_arc(Cairo.Context ctx, int center_x, int center_y, double radius) {
		ctx.arc(center_x, center_y, radius, 0, 2 * Math.PI);
		ctx.stroke();
	}

	private void draw_clock_hand(Cairo.Context ctx, int center_x, int center_y, double size, int value) {
		ctx.move_to(center_x, center_y);
		ctx.line_to(center_x + size * Math.cos(to_radian(value)),
					center_y + size * Math.sin(to_radian(value)));
		ctx.stroke();
	}

	private bool update_clock() {
		this.update_time();
		this.da.queue_draw();
		return true;
	}

}
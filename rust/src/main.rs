use chrono::prelude::*;
use gtk4::cairo::Context;
use gtk4::prelude::*;
use gtk4::{Application, ApplicationWindow, DrawingArea};
use std::f64::consts::PI;

fn draw_clock(context: &Context, width: f64, height: f64) {
    let now = Local::now();
    let seconds = now.second() as f64;
    let minutes = now.minute() as f64 + seconds / 60.0;
    let hours = now.hour() as f64 + minutes / 60.0;

    context.set_source_rgb(1.0, 1.0, 1.0); // white background
    context.paint().expect("Failed to paint");

    context.set_source_rgb(0.0, 0.0, 0.0); // black color
    context.translate(width / 2.0, height / 2.0);
    let radius = width.min(height) / 2.0 * 0.9;

    // Draw clock face
    context.arc(0.0, 0.0, radius, 0.0, 2.0 * PI);
    context.stroke().expect("Failed to stroke");

    // Draw hour hand
    context.save().expect("Failed to save context");
    context.rotate(hours * (PI / 6.0));
    context.move_to(0.0, 0.0);
    context.line_to(0.0, -radius * 0.5);
    context.stroke().expect("Failed to stroke");
    context.restore().expect("Failed to restore context");

    // Draw minute hand
    context.save().expect("Failed to save context");
    context.rotate(minutes * (PI / 30.0));
    context.move_to(0.0, 0.0);
    context.line_to(0.0, -radius * 0.8);
    context.stroke().expect("Failed to stroke");
    context.restore().expect("Failed to restore context");

    // Draw second hand
    context.save().expect("Failed to save context");
    context.set_source_rgb(1.0, 0.0, 0.0); // red color
    context.rotate(seconds * (PI / 30.0));
    context.move_to(0.0, 0.0);
    context.line_to(0.0, -radius * 0.9);
    context.stroke().expect("Failed to stroke");
    context.restore().expect("Failed to restore context");
}

fn main() {
    let application = Application::new(Some("com.example.AnalogClock"), Default::default());

    application.connect_activate(|app| {
        let window = ApplicationWindow::new(app);
        window.set_title(Some("Analog Clock"));
        window.set_default_size(1000, 1000);

        let drawing_area = DrawingArea::new();
        window.set_child(Some(&drawing_area));

        drawing_area.set_draw_func(move |_, context, width, height| {
            let width = width as f64;
            let height = height as f64;
            draw_clock(context, width, height);
        });

        glib::timeout_add_seconds_local(1, move || {
            drawing_area.queue_draw();
            glib::Continue(true)
        });

        window.show();
    });

    application.run();
}


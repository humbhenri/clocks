/* Relógio analógico usando FLTK
 * Humberto H. C. Pinheiro 
 * Qui, 24 Fev 2011
 *
 * To compile: fltk-config --compile filename.cpp
 */

#include <FL/Fl.H>
#include <FL/Fl_Window.H>
#include <FL/Fl_Box.H>
#include <FL/fl_draw.H>
#include <cmath>
#include <ctime>

#define WINDOW_WIDTH 360
#define WINDOW_HEIGHT 360
#define MIN(x, y) ((x) < (y) ? (x) : (y))
#define RADIAN(x) (((x) * M_PI/30.0) - M_PI/2.0)
#define INTERVAL 1

class ClockWidget : public Fl_Widget
{
public:
	ClockWidget() : Fl_Widget(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, "") 
	{
		// hands point to values between 0 and 59, hourHand values are multiples of 5
		time_t now;
		struct tm* timeinfo;
		time(&now);
		timeinfo = localtime(&now);
		hourHand = (timeinfo->tm_hour % 12) * 5;
		minuteHand = timeinfo->tm_min;
		secondHand = timeinfo->tm_sec;
	}	

	void tick() 
	{
		secondHand = (secondHand + 1) % 60;
		if (secondHand == 0) {
			minuteHand = (minuteHand + 1) % 60;
			if (minuteHand == 0) {
				hourHand = (hourHand + 5) % 60;
			}
		}
		redraw();
	}

protected:
	virtual void draw() 
	{
		fl_color(FL_BLACK);

		// draw face
		short centerX, centerY;
		float radius;
		centerX = w()/2;
		centerY = h()/2;
		radius = MIN(w(), h())/4;
		fl_pie(centerX - radius, centerY-radius, radius*2, radius*2, 0, 360);

		// draw hands
		int hourX, hourY, minuteX, minuteY, secondX, secondY;
		hourX = centerX + 0.35 * radius * cos(RADIAN(hourHand));
		hourY = centerY + 0.35 * radius * sin(RADIAN(hourHand));
		minuteX = centerX + 0.65 * radius * cos(RADIAN(minuteHand));
		minuteY = centerY + 0.65 * radius * sin(RADIAN(minuteHand));
		secondX = centerX + 0.85 * radius * cos(RADIAN(secondHand));
		secondY = centerY + 0.85 * radius * sin(RADIAN(secondHand));
		fl_color(FL_GREEN);
		fl_line_style(FL_SOLID, 3);
		fl_line(centerX, centerY, hourX, hourY);
		fl_line(centerX, centerY, minuteX, minuteY);
		fl_color(FL_RED);
		fl_line_style(FL_SOLID, 1);
		fl_line(centerX, centerY, secondX, secondY);
	}
private:
	int hourHand;
	int minuteHand;
	int secondHand;
};


void update(void *data)
{
	ClockWidget *clock = (ClockWidget*) data;
	clock->tick();		
	Fl::repeat_timeout(INTERVAL, update, clock);
}


int main(int argc, char **argv) 
{
	Fl_Window *window = new Fl_Window(WINDOW_WIDTH, WINDOW_HEIGHT);
	ClockWidget *clock = new ClockWidget();
	window->end();
	window->show(argc, argv);
	Fl::add_timeout(INTERVAL, update, clock);
	return Fl::run();
}


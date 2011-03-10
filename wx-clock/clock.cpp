#include "clock.h"
#include <wx/datetime.h>

#define TIMER_ID 123
#define RADIAN(x) (((x) * M_PI/30.0) - M_PI/2.0)

BEGIN_EVENT_TABLE(Clock, wxPanel)
    EVT_TIMER(TIMER_ID, Clock::OnTimer)
END_EVENT_TABLE()

Clock::Clock(wxPanel *parent, int id)
	: wxPanel(parent, id, wxDefaultPosition, wxSize(-1, 30))
{
	m_parent = parent;
	m_timer = new wxTimer(this, TIMER_ID);
	
	Connect(wxEVT_PAINT, wxPaintEventHandler(Clock::OnPaint));
	Connect(wxEVT_SIZE, wxSizeEventHandler(Clock::OnSize));

	SetTime();

	m_timer->Start(1000);
}


void Clock::SetTime()
{
	wxDateTime now = wxDateTime::Now();
	hoursHand = wxAtoi(now.Format(wxT("%H")));
	minutesHand = wxAtoi(now.Format(wxT("%M")));
	secondsHand = wxAtoi(now.Format(wxT("%S")));
}


Clock::~Clock()
{
	m_timer->Stop();
	delete m_timer;
}


void Clock::OnTimer(wxTimerEvent & event)
{
	// update clock
	secondsHand = (secondsHand + 1) % 60;
	if(secondsHand == 0) {
		minutesHand = (minutesHand + 1) % 60;
		if (minutesHand == 0) {
			hoursHand = (hoursHand + 5) % 360;
		}
	}
	Refresh();
}


void Clock::OnPaint(wxPaintEvent & event)
{
	wxPaintDC dc(this);
	wxSize size = GetSize();	
	int width = size.GetWidth();
	int height = size.GetHeight();
	int center_x = width/2;
	int center_y = height/2;
	int radius = width < height ? width/4: height/4;

	dc.SetBrush(wxBrush(wxColour(0,0,0)));
	dc.DrawCircle(center_x, center_y, radius);

	// draw hands
	int hoursHandSize = 0.30 * radius;
	int minutesHandSize = 0.5 * radius;
	int secondsHandSize = 0.75 * radius;
	dc.SetPen(wxPen(wxColour(0,255,0), 2));
	dc.DrawLine(center_x, 
			center_y, 
			center_x + hoursHandSize * cos(RADIAN(hoursHand)),
			center_y + hoursHandSize * sin(RADIAN(hoursHand)));
	dc.DrawLine(center_x, 
			center_y, 
			center_x + minutesHandSize * cos(RADIAN(minutesHand)),
			center_y + minutesHandSize * sin(RADIAN(minutesHand)));
	dc.SetPen(wxPen(wxColour(255,0,0)));
	dc.DrawLine(center_x, 
			center_y, 
			center_x + secondsHandSize * cos(RADIAN(secondsHand)),
			center_y + secondsHandSize * sin(RADIAN(secondsHand)));
}


void Clock::OnSize(wxSizeEvent & event)
{
	Refresh();
}


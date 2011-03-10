#ifndef CLOCK_H
#define CLOCK_H
#include <wx/wx.h>
#include <wx/timer.h>

class Clock : public wxPanel
{
	public:
		Clock(wxPanel *parent, int id);
		virtual ~Clock();
		void OnSize(wxSizeEvent & event);
		void OnPaint(wxPaintEvent & event);
		void OnTimer(wxTimerEvent & event);

	private:
		wxPanel *m_parent;
		wxTimer *m_timer;
		int hoursHand;
		int minutesHand;
		int secondsHand;
		void SetTime();
		DECLARE_EVENT_TABLE();
};

#endif

#include <wx/wx.h>
#include "clock.h"

class Window : public wxFrame
{
	public:
		Window(const wxString & title);

	private:
		Clock *clock;
};


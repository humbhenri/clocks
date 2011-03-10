#include "window.h"

class MyApp : public wxApp
{
  public:
	  virtual bool OnInit();
};

IMPLEMENT_APP(MyApp)

bool MyApp::OnInit()
{
	Window *window = new Window(wxString(wxT("wx-clock")));
	window->Show(true);
	return true;
}


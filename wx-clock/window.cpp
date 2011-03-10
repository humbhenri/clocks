#include "window.h"

Window::Window(const wxString & title)
	: wxFrame(NULL, wxID_ANY, title,wxDefaultPosition, wxSize(360, 360))

{
	wxPanel *panel = new wxPanel(this, -1);
	wxBoxSizer *box = new wxBoxSizer(wxVERTICAL);
	panel->SetSizer(box);

	clock = new Clock(panel, wxID_ANY);
	box->Add(clock, 1, wxEXPAND);

	Centre();
}


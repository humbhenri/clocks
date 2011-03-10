using System;
using Gtk;
using gtksharpclock;
using System.Timers;

public partial class MainWindow : Gtk.Window
{
	private static Timer timer;
	private static Clock clock;
	
	public MainWindow () : base(Gtk.WindowType.Toplevel)
	{
		Build ();
		clock = new Clock();
		timer = new Timer();
		timer.Elapsed += new ElapsedEventHandler(OnTimerElapsed);
		timer.Interval = 1000;
		timer.Start();
		Add(clock);
	}

	protected void OnDeleteEvent (object sender, DeleteEventArgs a)
	{
		Application.Quit ();
		a.RetVal = true;
	}
	
	protected void OnTimerElapsed (object sender, ElapsedEventArgs args)
	{
		clock.Tick();		
	}
}

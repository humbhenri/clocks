
using System;

namespace gtksharpclock
{


	[System.ComponentModel.ToolboxItem(true)]
	public partial class Clock : Gtk.Bin
	{
		private int hoursHand;
		private int minutesHand;
		private int secondsHand;
		private Gtk.DrawingArea drawingArea;

		public Clock ()
		{
			this.Build ();
			
			SetTime ();
			drawingArea = new Gtk.DrawingArea ();
			drawingArea.ExposeEvent += OnExpose;
			Add (drawingArea);
			ShowAll ();
		}


		public void Tick ()
		{
			secondsHand = (secondsHand + 1) % 60;
			if (secondsHand == 0) {
				minutesHand = (minutesHand + 1) % 60;
				if (minutesHand == 0) {
					hoursHand = (hoursHand + 5) % 60;
				}
			}			
			drawingArea.QueueDraw();
		}


		private void SetTime ()
		{
			hoursHand = DateTime.Now.Hour % 12 * 5;
			minutesHand = DateTime.Now.Minute;
			secondsHand = DateTime.Now.Second;
		}


		private void OnExpose (object obj, Gtk.ExposeEventArgs args)
		{
			Gtk.DrawingArea area = (Gtk.DrawingArea)obj;
			
			Cairo.Context cr = Gdk.CairoHelper.Create (area.GdkWindow);
			
			int width, height;
			width = Allocation.Width;
			height = Allocation.Height;
			double radius = Math.Min (width, height) / 4;
			
			//draw face	        
			cr.Arc (width / 2, height / 2, radius, 0, 2 * Math.PI);
			cr.StrokePreserve ();
			cr.SetSourceRGB (0, 0, 0);
			cr.Fill ();
			
			//draw hands
			double hoursHandSize = 0.35 * radius;
			double minutesHandSize = 0.5 * radius;
			double secondsHandSize = 0.75 * radius;
			double x = width / 2;
			double y = height / 2;
			
			cr.LineWidth = 2 * cr.LineWidth;
			cr.SetSourceRGB (0, 255, 0);
			
			cr.MoveTo (x, y);
			cr.LineTo (x + hoursHandSize * Math.Cos (ToRadian (hoursHand)), y + hoursHandSize * Math.Sin (ToRadian (hoursHand)));
			cr.Stroke ();
			
			cr.MoveTo (x, y);
			cr.LineTo (x + minutesHandSize * Math.Cos (ToRadian (minutesHand)), y + minutesHandSize * Math.Sin (ToRadian (minutesHand)));
			cr.Stroke ();
			
			cr.LineWidth = 0.25 * cr.LineWidth;
			cr.SetSourceRGB (255, 0, 0);
			cr.MoveTo (x, y);
			cr.LineTo (x + secondsHandSize * Math.Cos (ToRadian (secondsHand)), y + secondsHandSize * Math.Sin (ToRadian (secondsHand)));
			cr.Stroke ();
			
			((IDisposable)cr.Target).Dispose ();
			((IDisposable)cr).Dispose ();
		}


		private double ToRadian (double x)
		{
			return x * Math.PI / 30.0 - Math.PI / 2.0;
		}
		
	}
}

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace WindowsFormsApplication1
{
    public partial class Clock : Form
    {

        public int HoursHand { set; get; }
        public int MinutesHand { set; get; }
        public int SecondsHand { set; get; }
        private Timer timer;

        public Clock()
        {
            InitializeComponent();

            Paint += new PaintEventHandler(Form1_Paint);
            Resize += new EventHandler(Form1_Resize);

            SetTime();
            
            timer = new Timer(components);
            timer.Interval = 1000;
            timer.Start();
            timer.Tick += new EventHandler(delegate { this.Tick(); });
        }


        void Form1_Resize(object sender, EventArgs e)
        {
            Invalidate();
        }


        void Form1_Paint(object sender, PaintEventArgs e)
        {
            Graphics g = e.Graphics;
            g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;
            
            // draw face
            int centerX = Size.Width / 2;
            int centerY = Size.Height / 2;
            int radius = Math.Min(Size.Width, Size.Height) / 4;
            g.FillEllipse(Brushes.Black, centerX - radius, centerY - radius, radius*2, radius*2);
            
            //draw hands
            float hoursHandSize = 0.35f * radius;
            float minutesHandSize = 0.5f * radius;
            float secondsHandSize = 0.75f * radius;
            g.DrawLine(new Pen(Color.Green, 3), 
                (float)centerX, 
                (float)centerY, 
                centerX + hoursHandSize * (float)Math.Cos(ToRadian(HoursHand)),
                centerY + hoursHandSize * (float)Math.Sin(ToRadian(HoursHand)));
            g.DrawLine(new Pen(Color.Green, 3), 
                (float)centerX,
                (float)centerY,
                centerX + minutesHandSize * (float)Math.Cos(ToRadian(MinutesHand)),
                centerY + minutesHandSize * (float)Math.Sin(ToRadian(MinutesHand)));
            g.DrawLine(new Pen(Color.Red, 0.5f), 
                (float)centerX,
                (float)centerY,
                centerX + secondsHandSize * (float)Math.Cos(ToRadian(SecondsHand)),
                centerY + secondsHandSize * (float)Math.Sin(ToRadian(SecondsHand)));

        }


        public void SetTime()
        {      
			HoursHand = DateTime.Now.Hour % 12 * 5;
			MinutesHand = DateTime.Now.Minute;
			SecondsHand = DateTime.Now.Second;
		}


        private double ToRadian(double x)
        {
            return x * Math.PI / 30.0 - Math.PI / 2.0;
        }


        public void Tick()
        {
            SecondsHand = (SecondsHand + 1) % 60;
            if (SecondsHand == 0)
            {
                MinutesHand = (MinutesHand + 1) % 60;
                if (MinutesHand == 0)
                {
                    HoursHand = (HoursHand + 5) % 60;
                }
            }
            Invalidate();
        }
		
    }
}

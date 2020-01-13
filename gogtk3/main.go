package main

import (
	"github.com/gotk3/gotk3/cairo"
	"github.com/gotk3/gotk3/glib"
	"github.com/gotk3/gotk3/gtk"
	"log"
	"math"
	"time"
)

const (
	width  = 800
	height = 600
	tick   = 1000
)

var (
	hour   int = 12
	minute int = 15
	second int = 30
)

func main() {
	gtk.Init(nil)
	win, err := gtk.WindowNew(gtk.WINDOW_TOPLEVEL)
	if err != nil {
		log.Fatal("Unable to create window:", err)
	}
	win.SetTitle("Clock")
	_, err = win.Connect("destroy", func() {
		gtk.MainQuit()
	})
	if err != nil {
		log.Fatal("Unable to create window:", err)
	}

	canvas, err := gtk.DrawingAreaNew()
	if err != nil {
		log.Fatal("Unable to create canvas:", err)
	}
	win.Add(canvas)

	_, err = canvas.Connect("draw", drawClock)

	if err != nil {
		log.Fatal("Unable to draw:", err)
	}

	updateTime()
	glib.TimeoutAdd(tick, updateClock, canvas)

	// Set the default window size.
	win.SetDefaultSize(width, height)

	// Recursively show all widgets contained in this window.
	win.ShowAll()

	// Begin executing the GTK main loop.  This blocks until
	// gtk.MainQuit() is run.
	gtk.Main()
}

func drawClock(widget *gtk.DrawingArea,
	cr *cairo.Context) {
	width := float64(widget.GetAllocatedWidth())
	height := float64(widget.GetAllocatedHeight())
	centerX := width / 2.0
	centerY := height / 2.0
	radius := math.Min(width/2.0, height/2.0) / 2.0

	// draw clock arc
	cr.Arc(centerX, centerY, radius, 0, 2*math.Pi)
	cr.Stroke()

	// draw hour hand
	cr.SetLineWidth(2 * cr.GetLineWidth())
	drawClockHand(cr, centerX, centerY, radius/4.0, (hour*5)%60)

	// draw minute hand
	cr.SetLineWidth(0.5 * cr.GetLineWidth())
	drawClockHand(cr, centerX, centerY, radius/2.0, minute)

	// draw second hand
	cr.SetSourceRGB(1., 0., 0.)
	drawClockHand(cr, centerX, centerY, 0.75*radius, second)

}

func drawClockHand(cr *cairo.Context, centerX float64, centerY float64, size float64,
	value int) {
	cr.MoveTo(centerX, centerY)
	cr.LineTo(centerX+size*math.Cos(radian(value)),
		centerY+size*math.Sin(radian(value)))
	cr.Stroke()
}

func radian(value int) float64 {
	return (float64(value) * math.Pi / 30.0) - math.Pi/2.0
}

func updateClock(widget interface{}) bool {
	updateTime()
	canvas, ok := widget.(*gtk.DrawingArea)
	if !ok {
		log.Fatal("Unable to cast wiget to gtk.DrawingArea")
	}
	canvas.QueueDraw()
	return true
}

func updateTime() {
	now := time.Now()
	hour = now.Hour()
	minute = now.Minute()
	second = now.Second()
}

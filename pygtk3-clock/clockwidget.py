""" Pygtk clock widget
"""

import datetime
import math

from gi.repository import Gtk
from gi.repository import GLib

class ClockWidget(Gtk.Bin):
    """docstring for ClockWidget"""
    def __init__(self):
        super(ClockWidget, self).__init__()
        self.set_size_request(100, 100)

        aspect = Gtk.AspectFrame(label=None, xalign=0.5, yalign=0.5, ratio=1, vexpand=True)
        self.add(aspect)

        self.drawingarea = Gtk.DrawingArea()
        self.drawingarea.connect('draw', self._draw)
        aspect.add(self.drawingarea)

        # get local time  and translate it to angles
        timeinfo = datetime.datetime.now().time()
        self.hours_hand = (timeinfo.hour%12) * 5
        self.minutes_hand = timeinfo.minute
        self.seconds_hand = timeinfo.second

        GLib.timeout_add(
            priority=GLib.PRIORITY_DEFAULT,
            interval=1000,
            function=self.tick,
        )

    def tick(self):
        """ one second passes
        """
        self.seconds_hand = (self.seconds_hand + 1) % 60
        if self.seconds_hand == 0:
            self.minutes_hand = (self.minutes_hand + 1) % 60
            if self.minutes_hand == 0:
                self.hours_hand = (self.hours_hand + 5) % 60

        self.queue_draw()
        return True

    def _draw(self, widget, cairo):
        """ Paint a clock face
        """
        allocation = widget.get_allocation()
        xpox = allocation.width / float(2)
        ypos = allocation.height / float(2)
        radius = min([
            allocation.width / float(2),
            allocation.height / float(2),
        ]) * 0.5

        # draw circle
        cairo.arc(xpox, ypos, radius, 0, 2 * math.pi)
        cairo.set_source_rgb(0, 0, 0)
        cairo.fill_preserve()
        cairo.stroke()

        # draw _hands
        hours_hand_size = 0.25 * radius
        minutes_hand_size = 0.5 * radius
        seconds_hand_size = 0.75 * radius

        cairo.set_line_width(2 * cairo.get_line_width())
        cairo.set_source_rgb(0, 255, 0)

        cairo.move_to(xpox, ypos)
        cairo.line_to(xpox + hours_hand_size * math.cos(math.radians(self.hours_hand)),
                      ypos + hours_hand_size * math.sin(math.radians(self.hours_hand)))

        cairo.move_to(xpox, ypos)
        cairo.line_to(xpox + minutes_hand_size * math.cos(math.radians(self.minutes_hand)),
                      ypos + minutes_hand_size * math.sin(math.radians(self.minutes_hand)))
        cairo.stroke()

        cairo.set_source_rgb(255, 0, 0)
        cairo.set_line_width(0.25 * cairo.get_line_width())
        cairo.move_to(xpox, ypos)
        cairo.line_to(xpox + seconds_hand_size * math.cos(math.radians(self.seconds_hand)),
                      ypos + seconds_hand_size * math.sin(math.radians(self.seconds_hand)))

        cairo.stroke()

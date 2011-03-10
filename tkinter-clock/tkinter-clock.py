#!/usr/bin/python
# -*- coding: utf-8 -*-

from Tkinter import Tk, Canvas, Frame, BOTH, ALL
import math
import time

WIDTH = 360
HEIGHT = 360
DELAY = 1000

class Clock(Frame):
	def __init__(self, parent):
		Frame.__init__(self, parent)
		self.parent = parent
		self.canvas = Canvas(self, width=WIDTH, height=HEIGHT)
		self.initTime()
		self.draw()
		self.onTimer()

	def initTime(self):
		self.hourHand = time.localtime().tm_hour % 12 * 5
		self.minuteHand = time.localtime().tm_min
		self.secondHand = time.localtime().tm_sec

	def draw(self):
		self.pack(fill=BOTH, expand=1)		
		radius = 300
		x, y = 50, 50		
		centerX, centerY = 180, 180
		hourX = centerX + 0.3 * radius/2.0 * math.cos(self.toRadian(self.hourHand))
		hourY = centerY + 0.3 * radius/2.0 * math.sin(self.toRadian(self.hourHand))
		minuteX = centerX + 0.6 * radius/2.0 * math.cos(self.toRadian(self.minuteHand))
		minuteY = centerY + 0.6 * radius/2.0 * math.sin(self.toRadian(self.minuteHand))
		secondX = centerX + 0.75 * radius/2.0 * math.cos(self.toRadian(self.secondHand))
		secondY = centerY + 0.75 * radius/2.0 * math.sin(self.toRadian(self.secondHand))		
		self.canvas.create_oval(x, y, radius, radius, outline="black", fill="black")
		self.canvas.create_line(centerX, centerY, hourX, hourY, width=3, fill="green")
		self.canvas.create_line(centerX, centerY, minuteX, minuteY, width=3, fill="green")
		self.canvas.create_line(centerX, centerY, secondX, secondY, fill="red")
		self.canvas.pack(fill=BOTH, expand=1)

	def toRadian(self, x):
		return (x * math.pi/30.0) - (math.pi/2.0)
		
	def onTimer(self):
		self.tick()
		self.canvas.delete(ALL)
		self.draw()
		self.after(DELAY, self.onTimer)
		
	def tick(self):
		self.secondHand = (self.secondHand + 1) % 60
		if self.secondHand == 0:
			self.minuteHand = (self.minuteHand + 1) % 60
			if self.minuteHand == 0:
				self.hourHand = (self.hourHand + 5) % 60

if __name__=='__main__':
	root = Tk()
	app = Clock(root)
	root.geometry('%dx%d+300+300' % (WIDTH, HEIGHT))
	root.mainloop()  

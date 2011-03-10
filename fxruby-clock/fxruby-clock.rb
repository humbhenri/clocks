#!/usr/bin/ruby
# Simple clock made in FXRuby

require 'fox16'

include Fox

class ClockWidget < FXVerticalFrame
	def initialize(parentFrame)
		super(parentFrame,  
			FRAME_SUNKEN|LAYOUT_FILL_X|LAYOUT_FILL_Y|LAYOUT_TOP|LAYOUT_LEFT,
			:padLeft => 10, :padRight => 10, :padTop => 10, :padBottom => 10)

		setTime		

		@canvas = FXCanvas.new(self, :opts => LAYOUT_FILL_X|LAYOUT_FILL_Y|LAYOUT_TOP|LAYOUT_LEFT)

		@canvas.connect(SEL_PAINT) do |sender, sel, event|
			FXDCWindow.new(@canvas, event) do |dc|
				radius = [event.rect.w, event.rect.h].min / 4
				centerX = event.rect.w/2
				centerY = event.rect.h/2
				hourX = centerX + 0.3 * radius * Math::cos(toRadian @hourHand)
				hourY = centerY + 0.3 * radius * Math::sin(toRadian @hourHand)
				minuteX = centerX + 0.6 * radius * Math::cos(toRadian @minuteHand)
				minuteY = centerY + 0.6 * radius * Math::sin(toRadian @minuteHand)
				secondX = centerX + 0.75 * radius * Math::cos(toRadian @secondHand)
				secondY = centerY + 0.75 * radius * Math::sin(toRadian @secondHand)
				dc.foreground = FXRGB(255, 255, 255)
				dc.fillRectangle(event.rect.x, event.rect.y, event.rect.w, event.rect.h)
				dc.foreground = FXRGB(0, 0, 0)
				dc.fillCircle(centerX, centerY, radius)
				dc.foreground = FXRGB(0, 255, 0)
				dc.drawLine(centerX, centerY, hourX, hourY)
				dc.drawLine(centerX, centerY, minuteX, minuteY)
				dc.foreground = FXRGB(255, 0, 0)
				dc.drawLine(centerX, centerY, secondX, secondY)
			end
		end
	end

	def setTime
		@hourHand = DateTime.now.hour * 5
		@minuteHand = DateTime.now.min
		@secondHand = DateTime.now.sec
	end

	def tick
		@secondHand = (@secondHand + 1) % 60
		@minuteHand = (@minuteHand + 1) % 60 if @secondHand == 0
		@hourHand = (@hourHand + 5) % 60 if @minuteHand == 0
		@canvas.update
	end

	def toRadian(x)
		return (x * Math::PI/30.0) - (Math::PI/2.0)
	end
end


class MainWindow < FXMainWindow
	def initialize(app) 
		super(app, "FXRuby Clock", :width => 360, :height => 360)
		@clock = ClockWidget.new(self)
		app.addTimeout(1000, :repeat => true) do
			@clock.tick
		end
	end

	def create
		super
		show(PLACEMENT_SCREEN)
	end
end

if __FILE__ == $0
	FXApp.new do |app|
		window = MainWindow.new(app)
		app.create
		app.run
	end
end

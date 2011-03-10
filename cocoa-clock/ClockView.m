//
//  ClockView.m
//  cocoa-clock
//
//  Created by Humberto on 03/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ClockView.h"


@implementation ClockView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
		[self setTime];
		[NSTimer scheduledTimerWithTimeInterval:1.0
										 target:self
									   selector:@selector(updateClock:)
									   userInfo:nil
										repeats:YES];
	}
    return self;
}


- (BOOL)isFlipped
{
    return YES;
}


- (void)drawRect:(NSRect)dirtyRect {
	[[NSColor blackColor] set];
	NSRect bounds = [self bounds];
    [[NSBezierPath bezierPathWithOvalInRect:bounds] fill];
	
	// draw hands
	double hoursHandSize = 0.3 * bounds.size.width/2.0;
	double minutesHandSize = 0.5 * bounds.size.width/2.0;
	double secondsHandSize = 0.75 * bounds.size.width/2.0;
	NSPoint center;
	center.x = bounds.size.width/2.0;
	center.y = bounds.size.height/2.0;
	NSPoint hp, mp, sp;
	hp.x = center.x + hoursHandSize * cos([self toRadian:hoursHand]);
	hp.y = center.y + hoursHandSize * sin([self toRadian:hoursHand]);
	mp.x = center.x + minutesHandSize * cos([self toRadian:minutesHand]);
	mp.y = center.y + minutesHandSize * sin([self toRadian:minutesHand]);
	sp.x = center.x + secondsHandSize * cos([self toRadian:secondsHand]);
	sp.y = center.y + secondsHandSize * sin([self toRadian:secondsHand]);
	NSBezierPath *path = [[NSBezierPath alloc] init];
	[[NSColor greenColor] set];
	[path setLineWidth:3.0];
	[path moveToPoint:center];
	[path lineToPoint:hp];
	[path stroke];
	[path moveToPoint:center];
	[path lineToPoint:mp];
	[path stroke];
	[[NSColor redColor] set];
	[path setLineWidth:1.0];
	[path moveToPoint:center];
	[path lineToPoint:sp];
	[path stroke];
}
										   

- (double)toRadian:(int)num {
	return num * M_PI/30.0 - (M_PI/2.0);
}
										   

- (void)setTime {
	NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:
									(NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) 
											   fromDate:now];
	hoursHand =	[components hour] % 12 * 5;
	minutesHand = [components minute];
	secondsHand = [components second];
}


- (void)updateClock:(NSTimer*)timer {
	secondsHand = (secondsHand + 1) % 60;
	if (secondsHand == 0) {
		minutesHand = (minutesHand + 1) % 60;
		if (minutesHand == 0) {
			hoursHand = (hoursHand + 5) % 60;
		}
	}
	[self setNeedsDisplay:YES];
}

@end

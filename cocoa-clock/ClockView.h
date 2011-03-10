//
//  ClockView.h
//  cocoa-clock
//
//  Created by Humberto on 03/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ClockView : NSView {
	int hoursHand;
	int minutesHand;
	int secondsHand;
}
- (void)setTime;
- (double)toRadian:(int)num;
- (void)updateClock:(NSTimer*)timer;

@end

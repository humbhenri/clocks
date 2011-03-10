//
//  cocoa_clockAppDelegate.h
//  cocoa-clock
//
//  Created by Humberto on 03/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface cocoa_clockAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end

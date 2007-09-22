//
//  AppController.m
//  Switching Color Fix
//
//  Created by Kevin on 8/10/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"


@implementation AppController

- (void) switchHandler:(NSNotification*) notification
{
	if ([[notification name] isEqualToString:
		NSWorkspaceSessionDidResignActiveNotification])
	{
		// Perform deactivation tasks here.
		NSLog(@"Switching out");
	}
	else
	{
		// Perform activation tasks here.
		NSLog(@"Switching in");
		NSTask *task = [NSTask launchedTaskWithLaunchPath:@"/System/Library/Frameworks/ApplicationServices.framework/Versions/Current/Frameworks/CoreGraphics.framework/Versions/Current/Resources/DMProxy" 
												arguments:[NSArray array]];
		[task waitUntilExit];
        
	}
}

// Register the handler
- (void) applicationDidFinishLaunching:(NSNotification*) aNotification
{
	[[[NSWorkspace sharedWorkspace] notificationCenter] 
            addObserver:self
			   selector:@selector(switchHandler:)
				   name:NSWorkspaceSessionDidBecomeActiveNotification 
				 object:nil];
	
	[[[NSWorkspace sharedWorkspace] notificationCenter]
            addObserver:self 
			   selector:@selector(switchHandler:)
				   name:NSWorkspaceSessionDidResignActiveNotification 
				 object:nil];
}

@end


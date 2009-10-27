//
//  AppController.m
//  Switching Color Fix
//
//  Created by Kevin on 8/10/07.
//  Copyright 2007 Kevin A. Mitchell. All rights reserved.
//

#import "AppController.h"


@implementation AppController
- (void) fixColorSync
{
	NSTask *task = [NSTask launchedTaskWithLaunchPath:@"/System/Library/Frameworks/ApplicationServices.framework/Versions/Current/Frameworks/CoreGraphics.framework/Versions/Current/Resources/DMProxy" 
											arguments:[NSArray array]];
	[task waitUntilExit];
}

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
        [self performSelector: @selector(fixColorSync) withObject: self afterDelay: 0.5];
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


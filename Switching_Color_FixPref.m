//
//  Switching_Color_FixPref.m
//  Switching Color Fix
//
//  Created by Kevin on 8/12/07.
//  Copyright (c) 2007 Kevin A. Mitchell. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>
#import "Switching_Color_FixPref.h"
#import "LoginItems.h"

@implementation Switching_Color_FixPref
- (id)initWithBundle:(NSBundle *)bundle

{
    if ( ( self = [super initWithBundle:bundle] ) != nil ) {
		appPath = [[[NSURL URLWithString:@"SwitchingColorFixApp.app" 
                           relativeToURL: [NSURL fileURLWithPath: [bundle resourcePath]]] path] 
                      retain];
    }
	
	helperPathForRights = nil;
	
    return self;
}

- (void) dealloc
{
	[helperPathForRights release];
	[appPath release];
	[super dealloc];
}

- (NSImage*) bundleImageNamed: (NSString*)name
{
	NSBundle* bundle = [NSBundle bundleForClass:[self class]];
	NSString* path = [bundle pathForImageResource:name];
	return [[[NSImage alloc] initWithContentsOfFile:path] autorelease];
}

- (NSString*) helperPath
{
	return [[NSBundle bundleForClass: [self class]] pathForResource: @"scfhelper" ofType: nil];
}

- (void)runFixApp:(bool)runIt
{
	if (runIt)
	{
		// Launch the app		
		NSString* path = appPath;
		NSLog(@"Launching %@", path);
		[[NSWorkspace sharedWorkspace] openFile:path];
	}
	else
	{
		NSLog(@"Quitting com.kamit.switchingcolorfixapp");
		
		// We can send an AppleEvent to the app to turn it off.
		NSAppleEventDescriptor *theAddress;
		
		if (theAddress = [NSAppleEventDescriptor descriptorWithDescriptorType: typeApplicationBundleID data:[@"com.kamit.switchingcolorfixapp" dataUsingEncoding:NSUTF8StringEncoding]])
		{
			NSAppleEventDescriptor *theEvent;
			
			if (theEvent = [NSAppleEventDescriptor appleEventWithEventClass:kCoreEventClass 
																	eventID:kAEQuitApplication 
														   targetDescriptor:theAddress 
																   returnID:kAutoGenerateReturnID 
															  transactionID:kAnyTransactionID]);
			{
				OSStatus status = AESendMessage([theEvent aeDesc], NULL, kAENoReply | kAEDontReconnect | kAENeverInteract | kAEDontRecord, kAEDefaultTimeout);
			}
		}
	}
}

- (void) updateCheckbox
{
	bool checkOn = [[LoginItems items] hasPath: appPath];
	[self runFixApp: checkOn];
	[theCheckbox setState: checkOn];
}

- (void)callHelperApp
{
	if(![authView authorizationState])
	{
		if (![authView authorize: authView])
		{
			[self updateCheckbox];
			return;
		}
		[authView updateStatus: authView];
	}
	
    int err = AuthorizationExecuteWithPrivileges([[authView authorization] authorizationRef],
												 [[self helperPath] fileSystemRepresentation],
												 0, NULL, NULL);
    if(err!=0)
    {
        NSBeep();
        NSLog(@"Error %d in AuthorizationExecuteWithPrivileges",err);
		return;
    }
	
	// We don't have sync with the helper, so wait a short time and check our checkbox again
	// Just in case something failed
	[self performSelector: @selector(updateCheckbox) withObject:self afterDelay:0.5];
}


- (void) mainViewDidLoad
{
	NSString* helper = [self helperPath];
	
	helperPathForRights = [[NSData dataWithBytes:[helper fileSystemRepresentation] length:strlen([helper fileSystemRepresentation]) + 1] retain];
	
    items[0].name = kAuthorizationRightExecute;
    items[0].value = (const char *)[helperPathForRights bytes];
    items[0].valueLength = [helperPathForRights length] - 1;
    items[0].flags = 0;
	rights.count = 1;
	rights.items = items;
	
    [authView setAuthorizationRights:&rights];
    [authView setDelegate:self];
    [authView updateStatus:self];
	[authView setAutoupdate:YES interval:1.0];
}

- (void) willSelect
{
	[self updateCheckbox];
	
	NSBundle* bundle = [NSBundle bundleForClass:[self class]];
	NSString* path = [bundle pathForResource: @"About" ofType: @"rtf"];
	[theAboutBox readRTFDFromFile: path];
}

- (IBAction)checkboxClicked:(id)sender
{
	[self runFixApp: [sender state] == NSOnState];
	[self callHelperApp];
}

@end

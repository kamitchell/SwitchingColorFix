//
//  LoginItems.m
//  Switching Color Fix
//
//  Created by Kevin on 8/12/07.
//  Copyright 2007 Kevin A. Mitchell. All rights reserved.
//

#import "LoginItems.h"

#define PREFUSER kCFPreferencesAnyUser
//#define PREFUSER kCFPreferencesCurrentUser

@implementation LoginItems

- (NSDictionary*) makeDictEntry: (NSString*) path
{
	return [NSDictionary dictionaryWithObjectsAndKeys: path, @"Path", [NSNumber numberWithBool:YES], @"Hide", nil];
}

- (void) save
{
	CFPreferencesSetValue(CFSTR("AutoLaunchedApplicationDictionary"), 
                          (CFArrayRef)prefArray, 
                          CFSTR("loginwindow"), 
                          PREFUSER, 
                          kCFPreferencesCurrentHost);

	CFPreferencesSynchronize(CFSTR("loginwindow"), 
                             PREFUSER, 
                             kCFPreferencesCurrentHost); 
}

+ (LoginItems*) items
{
	return [[[LoginItems alloc] init] autorelease];
}

- (id) init
{	
    if ( ( self = [super init] ) != nil ) {
		
		// N.B. We have to synchronize, because other apps may be changing these preferences, and
		// CFPreferences caches.
		CFPreferencesSynchronize(CFSTR("loginwindow"), 
								 PREFUSER, 
								 kCFPreferencesCurrentHost); 

		NSArray* prefCFArray = (NSArray*)CFPreferencesCopyValue(CFSTR("AutoLaunchedApplicationDictionary"), 
                                                                CFSTR("loginwindow"), 
                                                                PREFUSER, 
                                                                kCFPreferencesCurrentHost);	

		if (prefCFArray)
			prefArray = [[prefCFArray autorelease] mutableCopy];
		else
			prefArray = [NSMutableArray arrayWithCapacity:1];
		
		[prefArray retain];
	}
	
	return self;
}

- (void) dealloc
{
	[prefArray release];
	[super dealloc];
}

- (bool) hasPath: (NSString*)path
{	
	bool has = [prefArray containsObject: [self makeDictEntry: path]];
#if DEBUG
	NSLog(@"hasPath: %@, %@", path, has ? @"true" : @"false");
#endif
	return has;
}

- (void) addPath: (NSString*)path
{
	if (![self hasPath: path])
	{
#if DEBUG
		NSLog(@"addPath: %@", path);
#endif
		[prefArray addObject: [self makeDictEntry: path]];
	}
	[self save];
}

- (void) removePath: (NSString*)path
{
#if DEBUG
	NSLog(@"removePath: %@", path);
#endif
	[prefArray removeObject: [self makeDictEntry: path]];
	[self save];
}

- (void) clean: (NSString*) suffix
{
#if DEBUG
	NSLog(@"clean: %@", suffix);
#endif
	NSMutableArray* newArray = [NSMutableArray arrayWithCapacity:[prefArray count]];
	
	NSEnumerator *enumerator = [prefArray objectEnumerator];
	NSDictionary* entry;
	
	while (entry = (NSDictionary*)[enumerator nextObject]) {
		NSString* path = (NSString*)[entry objectForKey:@"Path"];
		if (path && [path hasSuffix: suffix])
			continue;
		[newArray addObject:entry];
	}
	
	[prefArray release];
	prefArray = [newArray retain];
}

@end

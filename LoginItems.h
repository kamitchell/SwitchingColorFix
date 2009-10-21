//
//  LoginItems.h
//  Switching Color Fix
//
//  Created by Kevin on 8/12/07.
//  Copyright 2007 Kevin A. Mitchell. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LoginItems : NSObject {
	NSMutableArray* prefArray;
}

- (id) init;
- (void) dealloc;

- (bool) hasPath: (NSString*)path;
- (void) addPath: (NSString*)path;
- (void) removePath: (NSString*)path;
- (void) clean: (NSString*) suffix;

+ (LoginItems*) items;

@end

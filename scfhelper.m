#import <Foundation/Foundation.h>
#include "LoginItems.h"

NSString* appName = @"SwitchingColorFixApp.app";
int main (int argc, const char * argv[]) {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    // NSArray *args = [[NSProcessInfo processInfo] arguments];
	
	NSString* daemonPath = [[[NSURL URLWithString:appName 
                                    relativeToURL: [NSURL fileURLWithPath: 
                                                              [[NSBundle mainBundle] executablePath]]] path] retain];
	
	LoginItems* loginItems = [LoginItems items];
	
	// For now, just toggle 
	if ([loginItems hasPath: daemonPath])
	{
		[loginItems clean: [NSString stringWithFormat: @"/%@", appName]];		
		[loginItems removePath: daemonPath];
		NSLog(@"removed %@ from login items", daemonPath);
	}
	else
	{
		[loginItems clean: [NSString stringWithFormat: @"/%@", appName]];		
		[loginItems addPath: daemonPath];
		NSLog(@"added %@ to login items", daemonPath);
	}
	
    [pool release];
	
    return 0;	
}

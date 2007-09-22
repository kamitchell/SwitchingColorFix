//
//  Switching_Color_FixPref.h
//  Switching Color Fix
//
//  Created by Kevin on 8/12/07.
//  Copyright (c) 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <PreferencePanes/PreferencePanes.h>
#import <Security/Authorization.h>
#import <Security/Security.h>
#import <SecurityInterface/SFAuthorizationView.h>

@interface Switching_Color_FixPref : NSPreferencePane
{
    IBOutlet NSButton *theCheckbox;
	IBOutlet NSTextView *theAboutBox;
	IBOutlet SFAuthorizationView *authView;
	
	NSString *appPath;
	NSData *helperPathForRights;

    AuthorizationRights rights;
    AuthorizationItem items[1];

}
- (IBAction)checkboxClicked:(id)sender;
@end

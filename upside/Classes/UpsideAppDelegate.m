//
//  UpsideAppDelegate.m
//  Upside
//
//  Created by Victor Costan on 1/2/09.
//  Copyright Zergling.Net 2009. All rights reserved.
//

#import "UpsideAppDelegate.h"

#import "ActivationLoginViewController.h"
#import "ActivationState.h"
#import "ActivationUserChoiceViewController.h"
#import "RegistrationViewController.h"
#import "TabBarController.h"
#import "User.h"

@implementation UpsideAppDelegate

@synthesize window;

// TODO(overmind): remove this when we have offline storage
static BOOL hasLoggedIn = NO;

-(void)applicationDidFinishLaunching:(UIApplication *)application {
	if (![[ActivationState sharedState] isRegistered]) {		
		self.viewController = [[[RegistrationViewController alloc]
								initWithNibName:@"RegistrationViewController"
								bundle:nil] autorelease];		
	}
	else {
    [[ActivationState sharedState] updateDeviceInfo];
    if (![[ActivationState sharedState] isActivated]) {
      if ([[[ActivationState sharedState] user] isPseudoUser]) {
        self.viewController = [[[ActivationUserChoiceViewController alloc]
                                initWithNibName:@"ActivationUserChoiceViewController"
                                bundle:nil] autorelease];
      }
      else {
        self.viewController = [[[ActivationLoginViewController alloc]
                                initWithNibName:@"ActivationLoginViewController"
                                bundle:nil] autorelease];
      }
    }
    else {
      // TODO(overmind): remove if when we have storage
      if (hasLoggedIn) {
        self.viewController = [TabBarController loadFromNib:@"TabBar"
                                                      owner:self];      
      }
      else {
        // TODO(overmind): remove this entire branch when we have storage
        hasLoggedIn = YES;
        self.viewController = [[[ActivationLoginViewController alloc]
                                initWithNibName:@"ActivationLoginViewController"
                                bundle:nil] autorelease];
      }
    }    
  }
	
	SEL selector = @selector(setActivationState:);
	if ([self.viewController respondsToSelector:selector]) {
		[self.viewController performSelector:selector
		                          withObject:[ActivationState sharedState]];
	}
    [window addSubview:viewController.view];
}

-(void)dealloc {
	[viewController release];
    [window release];
    [super dealloc];
}

+(UpsideAppDelegate*)sharedDelegate {
	return (UpsideAppDelegate*)[[UIApplication sharedApplication] delegate];	
}

@synthesize viewController;

@end

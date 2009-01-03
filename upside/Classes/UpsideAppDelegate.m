//
//  UpsideAppDelegate.m
//  Upside
//
//  Created by Victor Costan on 1/2/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "UpsideAppDelegate.h"

#import "ActivationViewController.h"
#import "ActivationState.h"
#import "TabBarController.h"

@implementation UpsideAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	if ([[ActivationState sharedState] activated]) {
		self.viewController = [TabBarController loadFromNib:@"TabBar"
													  owner:self];
	}
	else {
		self.viewController = [[[ActivationViewController alloc]
								initWithNibName:@"ActivationViewController"
								bundle:nil] autorelease];
	}
    [window addSubview:viewController.view];
}

- (void)dealloc {
	[viewController release];
    [window release];
    [super dealloc];
}

+ (UpsideAppDelegate*) sharedDelegate {
	return (UpsideAppDelegate*)[[UIApplication sharedApplication] delegate];	
}

@synthesize viewController;

@end

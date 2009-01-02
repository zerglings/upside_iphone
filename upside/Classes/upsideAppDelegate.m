//
//  upsideAppDelegate.m
//  upside
//
//  Created by Victor Costan on 1/2/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "upsideAppDelegate.h"
#import "upsideViewController.h"

@implementation upsideAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end

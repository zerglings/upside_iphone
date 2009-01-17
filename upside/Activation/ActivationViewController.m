//
//  upsideViewController.m
//  upside
//
//  Created by Victor Costan on 1/2/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "ActivationViewController.h"

#import "ActivationCommController.h"
#import "ActivationState.h"
#import "UpsideAppDelegate.h"

@implementation ActivationViewController



// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		activationCommController = [[ActivationCommController alloc] init];
    }
    return self;
}

- (void) dealloc {
	[activationCommController release];
	[super dealloc];
}

- (void)loadView {
	[activationCommController activateDevice];
	
	[super loadView];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (IBAction) activateButtonWasTapped {
	[[ActivationState sharedState] setActivated:YES];
	[[ActivationState sharedState] save];
	[self.view removeFromSuperview];
		
	[[UpsideAppDelegate sharedDelegate]
	 applicationDidFinishLaunching:[UIApplication sharedApplication]];
}

@end

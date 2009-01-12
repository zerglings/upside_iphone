//
//  TabBarController.m
//  upside
//
//  Created by Victor Costan on 1/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TabBarController.h"

#import "Game.h"


@implementation TabBarController

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	// Ping the game to force all the good background processing to start.
	[Game sharedGame];
	
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


- (void)dealloc {
    [super dealloc];
}

+ (UITabBarController*) loadFromNib: (NSString*)nibName
	  						  owner: (UpsideAppDelegate*)owner {
	NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:nibName
														 owner:owner
													   options:nil];
	NSEnumerator* nibEnumerator = [nibContents objectEnumerator];
	
	NSObject* nibItem;
	while ((nibItem = [nibEnumerator nextObject])) {
		if ([nibItem isKindOfClass:[UITabBarController class]])
			return (UITabBarController*)nibItem;
	}
	return nil;	
}

@end

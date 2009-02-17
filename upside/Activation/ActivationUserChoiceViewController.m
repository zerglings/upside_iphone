//
//  ActivationUserChoiceViewController.m
//  StockPlay
//
//  Created by Victor Costan on 1/19/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "ActivationUserChoiceViewController.h"

#import "ActivationLoginViewController.h"
#import "ActivationState.h"
#import "UpsideAppDelegate.h"
#import "User.h"

@interface ActivationUserChoiceViewController ()
-(void)switchToLoginView;
@end


@implementation ActivationUserChoiceViewController

/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 -(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 -(void)loadView {
 }
 */

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
-(void)viewDidLoad {
  [super viewDidLoad];
	if (![activationState.user isPseudoUser]) {
		[self switchToLoginView];
	}	
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}

-(void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
  // Release anything that's not essential, such as cached data
}

@synthesize activationState;

-(void)dealloc {
	[activationState release];
  [super dealloc];
}


-(IBAction)newAccountTapped:(id)sender {
  User* newUser = [[User alloc] initPseudoUser:activationState.deviceInfo];
	[activationState setUser:newUser];
  [newUser release];  
	[self switchToLoginView];
}

-(IBAction)loginTapped:(id)sender {
	[self switchToLoginView];
}

-(void)switchToLoginView {
	ActivationLoginViewController* loginViewController =
      [[ActivationLoginViewController alloc]
       initWithNibName:@"ActivationLoginViewController" bundle:nil];
  [[self retain] autorelease];
  [UpsideAppDelegate sharedDelegate].viewController = loginViewController;
	[loginViewController setActivationState:activationState];
	[self.view.superview addSubview:loginViewController.view];
  [loginViewController release];
	[self.view removeFromSuperview];
}

@end

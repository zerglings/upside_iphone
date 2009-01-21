//
//  ActivationLoginViewController.m
//  upside
//
//  Created by Victor Costan on 1/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ActivationLoginViewController.h"

#import "ActivationState.h"
#import "LoginCommController.h"
#import "UpsideAppDelegate.h"
#import "User.h"

@interface ActivationLoginViewController () <LoginCommDelegate>
- (void) flipControls;
@end


@implementation ActivationLoginViewController

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
    [super viewDidLoad];
	[self flipControls];
	
	if (![activationState canLogin]) {
		User* user = activationState.user;
		if ([user isPseudoUser]) {
			[userNameText becomeFirstResponder];
		}
		else {
			userNameText.text = user.name;
			[passwordText becomeFirstResponder];
		}
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

@synthesize activationState;

- (void)dealloc {
	[activationState release];
    [super dealloc];
}

- (void)flipControls {
	BOOL canLogin = [activationState canLogin];
	
	[userNameLabel setHidden:canLogin];
	[passwordLabel setHidden:canLogin];
	[userNameText setHidden:canLogin];
	[passwordText setHidden:canLogin];
	[loginButton setHidden:canLogin];
	
	[activityLabel setHidden:!canLogin];
	if (canLogin) {
		[activityIndicator startAnimating];
		[commController loginUsing:activationState];
	}
	else
		[activityIndicator stopAnimating];
}

- (IBAction)loginTapped: (id)sender {
	User* newUser = [[User alloc] initWithName:userNameText.text
									  password:passwordText.text];
	activationState.user = newUser;
	[newUser release];
	
	[self flipControls];
}
			
- (BOOL)textFieldShouldReturn: (UITextField *)theTextField {
	[theTextField resignFirstResponder];
	if (theTextField == userNameText) {		
		[passwordText becomeFirstResponder];
	}
	else {
		[self loginTapped:nil];
	}
	return YES;
}

#pragma mark LoginCommController Delegate

- (void)loginSucceeded {
	[self.view removeFromSuperview];
	[[UpsideAppDelegate sharedDelegate]
	 applicationDidFinishLaunching:[UIApplication sharedApplication]];
}

- (void)loginFailed: (NSError*)error {
	NSString* title = [error localizedDescription];
	NSString* message = [error localizedFailureReason];
	if (!message) {
		if (title) {
			message = title;
			title = @"Login error";
		}
		else {
			message = @"Something went horribly wrong.";
			title = @"Login error";
		}
	}
	if (!title) {
		title = @"Login error";
	}
	UIAlertView* alertView =
	[[UIAlertView alloc] initWithTitle:title
							   message:message
							  delegate:self
					 cancelButtonTitle:@"Re-enter info"
					 otherButtonTitles:@"Retry request", nil];
	[alertView show];
	[alertView release];
}

- (void) alertView: (UIAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0: {
			User* rollbackUser = [[User alloc] initWithUser:activationState.user
												   password:nil];
			activationState.user = rollbackUser;
			[rollbackUser release];
			[self flipControls];
			break;
		}
		case 1:
			[commController loginUsing:activationState];
			break;
		default:
			break;
	}
}

@end
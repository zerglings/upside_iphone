//
//  PasswordChangeViewController.m
//  upside
//
//  Created by Victor Costan on 7/19/09.
//  Copyright 2009 MIT. All rights reserved.
//

#import "PasswordChangeViewController.h"

#import "RegistrationState.h"
#import "User.h"
#import "UserUpdateCommController.h"


@implementation PasswordChangeViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
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
  
  self.title = @"Change Password";
  [currentPasswordText becomeFirstResponder];
}

/*
// Override to allow orientations other than the default portrait orientation.
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
	
  // Release any cached data, images, etc that aren't in use.
}

-(void)viewDidUnload {
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}


-(void)dealloc {
  [super dealloc];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
  BOOL returnValue = [super textFieldShouldReturn:textField];
  if (textField == newPasswordText) {
    [self changePasswordTapped];
  }
  return returnValue;
}

-(IBAction)changePasswordTapped {
  User* currentUser = [[RegistrationState sharedState] user];
  
  if (![currentUser.password isEqualToString:currentPasswordText.text]) {
    UIAlertView* alert =
        [[UIAlertView alloc]
         initWithTitle:@"Incorrect password"
         message:@"The Old Password doesn't match the password on your account."
                 delegate:nil
         cancelButtonTitle:@"Re-enter"
         otherButtonTitles:nil];
    [alert show];
    [alert release];
    return;
  }
  
  User* newUser = [[User alloc] initWithUser:currentUser
                                    password:newPasswordText.text];
  [updateCommController updateUser:newUser];
  [newUser release];
  [progressIndicatorView setHidden:NO];  
}

@end

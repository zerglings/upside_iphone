//
//  ActivationLoginViewController.m
//  StockPlay
//
//  Created by Victor Costan on 1/19/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "ActivationLoginViewController.h"

#import "LoginCommController.h"
#import "RegistrationState.h"
#import "UpsideAppDelegate.h"
#import "User.h"

@interface ActivationLoginViewController () <LoginCommDelegate>
-(void)flipControls;
@end


@implementation ActivationLoginViewController

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

-(void)viewDidLoad {
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

-(void)flipControls {
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

-(IBAction)loginTapped:(id)sender {
  User* newUser = [[User alloc] initWithName:userNameText.text
                                    password:passwordText.text];
  activationState.user = newUser;
  [newUser release];

  [self flipControls];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  if (textField == userNameText) {
    [passwordText becomeFirstResponder];
  }
  return YES;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  for (UIView* view in self.view.subviews) {
    if ([view isKindOfClass:[UITextField class]])
      [view resignFirstResponder];
  }
}

#pragma mark LoginCommController Delegate

-(void)loginSucceeded {
  [self.view removeFromSuperview];
  [[UpsideAppDelegate sharedDelegate]
   applicationDidFinishLaunching:[UIApplication sharedApplication]];
}

-(void)loginFailed:(NSError*)error {
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

  UIAlertView* alertView;
  if ([[error domain] isEqualToString:@"StockPlay"]) {
    alertView =
        [[UIAlertView alloc] initWithTitle:title
                                   message:message
                                  delegate:self
                         cancelButtonTitle:@"Re-enter password"
                         otherButtonTitles:@"Retry", nil];
  }
  else {
    alertView =
    [[UIAlertView alloc] initWithTitle:title
                               message:message
                              delegate:self
                     cancelButtonTitle:@"Retry"
                     otherButtonTitles:nil];
  }

  [alertView show];
  [alertView release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if ([[alertView buttonTitleAtIndex:buttonIndex]
       isEqualToString:@"Retry"]) {
    [commController loginUsing:activationState];
    return;
  }

  User* rollbackUser = [[User alloc] initWithUser:activationState.user
                                             password:nil];
  activationState.user = rollbackUser;
  [rollbackUser release];
  [self flipControls];
}

@end

//
//  RegistrationViewController.m
//  StockPlay
//
//  Created by Victor Costan on 1/2/09.
//  Copyright Zergling.Net 2009. All rights reserved.
//

#import "RegistrationViewController.h"

#import "RegistrationCommController.h"
#import "RegistrationState.h"
#import "UpsideAppDelegate.h"

@interface RegistrationViewController ()
    <RegistrationCommDelegate, UIActionSheetDelegate>
@end


@implementation RegistrationViewController


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

@synthesize activationState;

-(void)dealloc {
  [activationState release];
  [super dealloc];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
-(void)viewDidLoad {
    [super viewDidLoad];
  [commController registerDeviceUsing:activationState];
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

-(void)exitApplication {
  UIApplication* application = [UIApplication sharedApplication];
  if ([application respondsToSelector:@selector(terminate)]) {
    [application performSelector:@selector(terminate)];
  }
  else {
    kill(getpid(), SIGINT);
  }
}

#pragma mark Aborting

-(IBAction)abortTapped:(id)sender {
  UIActionSheet* sheet = [[UIActionSheet alloc]
                          initWithTitle:@"Exit and try again later?"
                          delegate:self
                          cancelButtonTitle:@"No"
                          destructiveButtonTitle:@"Yes"
                          otherButtonTitles:nil];
  [sheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
  [sheet showInView:self.view];
  [sheet release];
}

-(void)actionSheet:(UIActionSheet*)actionSheet
didDismissWithButtonIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0) { // the "Yes" button
    [self exitApplication];
  }
}

#pragma mark ActivationCommController Delegate

-(void)activationSucceeded {
  // The application delegate will proceed to the next step.
  [self.view removeFromSuperview];
  [[UpsideAppDelegate sharedDelegate]
   applicationDidFinishLaunching:[UIApplication sharedApplication]];
}

-(void)activationFailed:(NSError*)error {
  NSString* title = [error localizedDescription];
  NSString* message = [error localizedFailureReason];
  if (!message) {
    if (title) {
      message = title;
      title = @"Registration error";
    }
    else {
      message = @"Something went horribly wrong.";
      title = @"Registration error";
    }
  }
  if (!title) {
    title = @"Activation error";
  }
  UIAlertView* alertView =
      [[UIAlertView alloc] initWithTitle:title
                   message:message
                  delegate:self
             cancelButtonTitle:@"Abort"
             otherButtonTitles:@"Retry", nil];
  [alertView show];
  [alertView release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0) {
    [self exitApplication];
  }
  else {
    [commController registerDeviceUsing:activationState];
  }
}

@end

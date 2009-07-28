//
//  NamedAccountViewController.m
//  StockPlay
//
//  Created by Victor Costan on 5/9/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "NamedAccountViewController.h"

#import "RegistrationState.h"
#import "ServiceError.h"
#import "User.h"
#import "UserUpdateCommController.h"
#import "UserQueryCommController.h"


@interface NamedAccountViewController () <UITextViewDelegate>
-(void)availabilitySearchNeeded;
-(void)availabilitySearchResults:(NSArray*)results;
@end

@implementation NamedAccountViewController
@synthesize lastQueryResponse, lastQueryName;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    queryCommController = [[UserQueryCommController alloc]
                           initWithTarget:self
                           action:@selector(availabilitySearchResults:)];
    lastQueryTime = 0.0;
  }
  return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
-(void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
-(void)viewDidLoad {
  [super viewDidLoad];

  self.title = @"Claim User Name";
  [userNameText becomeFirstResponder];
}

// Override to allow orientations other than the default portrait orientation.
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
  // Release anything that's not essential, such as cached data
}


-(void)dealloc {
  [queryCommController release];
  [lastQueryResponse release];
  [super dealloc];
}

-(BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
  if (textField == userNameText) {
    // TODO(overmind): prohibit characters that don't work in user names
    [self performSelector:@selector(availabilitySearchNeeded)
               withObject:nil
               afterDelay:0.2];
  }
  return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
  BOOL returnValue = [super textFieldShouldReturn:textField];
  if (textField == newPasswordText) {
    [self claimNameTapped];
  }
  return returnValue;
}

-(IBAction)claimNameTapped {
  User* user = [[User alloc] initWithName:userNameText.text
                                 password:newPasswordText.text];
  [updateCommController updateUser:user];
  [user release];
  [progressIndicatorView setHidden:NO];
}

-(void)availabilitySearchNeeded {
  // Do not issue duplicate queries.
  if ([lastQueryName isEqualToString:userNameText.text]) {
    return;
  }
  NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
  if (now - lastQueryTime < 0.6) {
    // Do not fire more than one search per 0.6 seconds.
    [self performSelector:@selector(availabilitySearchNeeded)
               withObject:nil
               afterDelay:0.2];
    return;
  }
  lastQueryTime = now;
  self.lastQueryName = userNameText.text;
  [queryCommController startQueryForName:lastQueryName];
}
-(void)availabilitySearchResults:(NSArray*)results {
  if (![results isKindOfClass:[NSArray class]]) {
    // TODO(overmind): handle transport error
  }
  UserQueryResponse* response = [results objectAtIndex:0];
  if ([response isKindOfClass:[ServiceError class]]) {
    // TODO(overmind): handle service error
  }

  if ([response.name isEqualToString:lastQueryName]) {
    self.lastQueryResponse = response;
    if ([response.name isEqualToString:userNameText.text]) {
      [self setNameAvailability:(!response.taken)];
    }
  }
}
@end

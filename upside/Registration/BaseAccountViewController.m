//
//  BaseAccountViewController.m
//  upside
//
//  Created by Victor Costan on 7/19/09.
//  Copyright 2009 MIT. All rights reserved.
//

#import "BaseAccountViewController.h"

#import "RegistrationState.h"
#import "ServiceError.h"
#import "User.h"
#import "UserUpdateCommController.h"


@implementation BaseAccountViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    updateCommController = [[UserUpdateCommController alloc] initWithTarget:self
                                                                     action:
                            @selector(userUpdateResult:)];
  }
  return self;
}
-(void)dealloc {
  [updateCommController release];
  
  [super dealloc];
}

-(void)viewDidLoad {
  [super viewDidLoad];
  
  User* user = [[RegistrationState sharedState] user];
  if (![user isPseudoUser]) {
    userNameLabel.text = user.name;
    userNameText.text = user.name;
  }
  
  [self setNameAvailabilityUnknown];
}

-(IBAction)passwordsVisibleChanged {
  [currentPasswordText setSecureTextEntry:(!passwordsVisibleSwitch.on)];
  [newPasswordText setSecureTextEntry:(!passwordsVisibleSwitch.on)];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  if (textField == userNameText) {
    if (currentPasswordText) {
      [currentPasswordText becomeFirstResponder];
    }
    else {
      [newPasswordText becomeFirstResponder];
    }
  }
  else if (textField == currentPasswordText) {
    [newPasswordText becomeFirstResponder];
  }
  return YES;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  for (UIView* view in self.view.subviews) {
    if ([view isKindOfClass:[UITextField class]])
      [view resignFirstResponder];
  }
}


-(void)setNameAvailabilityUnknown {
  nameAvailabilityLabel.text = @"";
  nameAvailabilityImage.image = nil;
}
-(void)setNameAvailability:(BOOL)isNameAvailable {
  nameAvailabilityLabel.text = isNameAvailable ? @"" : @"taken";
  nameAvailabilityLabel.textColor = isNameAvailable ?
  [UIColor greenColor] : [UIColor redColor];
  nameAvailabilityImage.image = isNameAvailable ?
  [UIImage imageNamed:@"GreenTick.png"] : [UIImage imageNamed:@"RedX.png"];
}

-(void)userUpdateResult:(NSArray*)results {
  [progressIndicatorView setHidden:YES];
  
  // HTTP errors.
  if ([results isKindOfClass:[NSError class]]) {
    NSString* title = [(NSError*)results localizedDescription];
    NSString* message = [(NSError*)results localizedFailureReason];
    if (!message) {
      if (title) {
        message = title;
        title = nil;
      }
      else {
        message = @"Something went horribly wrong.";
      }
    }
    if (!title) {
      title = @"Account change error";
    }
    
    UIAlertView* alertView =
    [[UIAlertView alloc] initWithTitle:title
                               message:message
                              delegate:self
                     cancelButtonTitle:@"Retry"
                     otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    return;
  }
  // Service errors.
  NSObject* result = [results objectAtIndex:0];
  if ([result isKindOfClass:[ServiceError class]]) {
    UIAlertView* alertView = 
    [[UIAlertView alloc] initWithTitle:@"Account change error"
                               message:[(ServiceError*)result message]
                              delegate:self
                     cancelButtonTitle:@"Retry"
                     otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    return;
  }

  // Update succeeded... replace activation information.
  NSAssert([result isKindOfClass:[User class]],
           @"Non-error result should be a User instance");
  RegistrationState* activation = [RegistrationState sharedState];
  User* newUser = [[User alloc] initWithUser:(User*)result
                                    password:newPasswordText.text];
  [activation setUser:newUser];
  [newUser release];
  [activation save];
  
  [self.navigationController popViewControllerAnimated:YES];
}

@end

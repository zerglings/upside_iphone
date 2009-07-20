//
//  BaseAccountViewController.h
//  upside
//
//  Created by Victor Costan on 7/19/09.
//  Copyright 2009 MIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserUpdateCommController;  


// Common functionality for the view controllers related to the user's account.
@interface BaseAccountViewController : UIViewController <UITextFieldDelegate> {
  // Displays the user's name.
  IBOutlet UILabel* userNameLabel;
  // Allows for a user name input.
  IBOutlet UITextField* userNameText;
  
  // The user's current/old password.
  IBOutlet UITextField* currentPasswordText;
  // The user's new password.
  IBOutlet UITextField* newPasswordText;
  // If set, the passwords on the form are visible.
  // Not important when logging in, definitely useful when setting a password.
  IBOutlet UISwitch* passwordsVisibleSwitch;
  
  // Indicates if the chosen user name is available.
  IBOutlet UILabel* nameAvailabilityLabel;
  // Indicates if the chosen user name is available.
  IBOutlet UIImageView* nameAvailabilityImage;
  
  // Becomes visible when an asynchronous request is in process.
  IBOutlet UIView* progressIndicatorView;
  
  // Performs user account updates.
  UserUpdateCommController* updateCommController;
}
// Fired when the "Show Passwords" switch is toggled.
-(IBAction)passwordsVisibleChanged;

// Changes the UI to reflect that the user name availability is unknown.
-(void)setNameAvailabilityUnknown;
// Changes the UI to reflect whether the chosen user name is available or not.
-(void)setNameAvailability:(BOOL)isNameAvailable;

// Designated initializer.
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
@end

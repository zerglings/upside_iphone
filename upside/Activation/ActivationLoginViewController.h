//
//  ActivationLoginViewController.h
//  upside
//
//  Created by Victor Costan on 1/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActivationState;
@class LoginCommController;

@interface ActivationLoginViewController : UIViewController {
	IBOutlet UILabel* userNameLabel;
	IBOutlet UILabel* passwordLabel;
	IBOutlet UITextField* userNameText;
	IBOutlet UITextField* passwordText;
	IBOutlet UIButton* loginButton;
	
	IBOutlet UILabel* activityLabel;
	IBOutlet UIActivityIndicatorView* activityIndicator;
	
	IBOutlet LoginCommController* commController;
	ActivationState* activationState;
}

@property (nonatomic, retain) ActivationState* activationState;

- (IBAction) loginTapped: (id)sender;

@end

//
//  ActivationUserChoiceViewController.h
//  upside
//
//  Created by Victor Costan on 1/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActivationState;

@interface ActivationUserChoiceViewController : UIViewController {
	IBOutlet UIButton* loginButton;
	IBOutlet UIButton* newAccountButton;
	
	ActivationState* activationState;
}

@property (nonatomic, retain) ActivationState* activationState;

- (IBAction) loginTapped: (id)sender;
- (IBAction) newAccountTapped: (id)sender;

@end

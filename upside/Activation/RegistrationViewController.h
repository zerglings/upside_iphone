//
//  RegistrationViewController.h
//  Upside
//
//  Created by Victor Costan on 1/2/09.
//  Copyright Zergling.Net 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RegistrationCommController;
@class ActivationState;

@interface RegistrationViewController : UIViewController {
	IBOutlet UIButton* abortButton;
	
	IBOutlet RegistrationCommController* commController;
	ActivationState* activationState;
}

@property (nonatomic, retain) ActivationState* activationState;

-(IBAction)abortTapped: (id)sender;

@end

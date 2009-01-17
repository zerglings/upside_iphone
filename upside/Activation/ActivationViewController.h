//
//  ActivationViewController.h
//  Upside
//
//  Created by Victor Costan on 1/2/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActivationCommController;

@interface ActivationViewController : UIViewController {
	IBOutlet UIButton* activateButton;
	
	ActivationCommController* activationCommController;
}

- (IBAction) activateButtonWasTapped;

@end

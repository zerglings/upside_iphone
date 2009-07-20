//
//  RegistrationViewController.h
//  Upside
//
//  Created by Victor Costan on 1/2/09.
//  Copyright Zergling.Net 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RegistrationCommController;
@class RegistrationState;

@interface RegistrationViewController : UIViewController {
  IBOutlet UIButton* abortButton;

  IBOutlet RegistrationCommController* commController;
  RegistrationState* activationState;
}

@property (nonatomic, retain) RegistrationState* activationState;

-(IBAction)abortTapped:(id)sender;

@end

//
//  ActivationUserChoiceViewController.h
//  StockPlay
//
//  Created by Victor Costan on 1/19/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RegistrationState;

@interface ActivationUserChoiceViewController : UIViewController {
  IBOutlet UIButton* loginButton;
  IBOutlet UIButton* newAccountButton;

  RegistrationState* activationState;
}

@property (nonatomic, retain) RegistrationState* activationState;

-(IBAction)loginTapped:(id)sender;
-(IBAction)newAccountTapped:(id)sender;

@end

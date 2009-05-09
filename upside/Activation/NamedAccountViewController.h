//
//  NamedAccountViewController.h
//  upside
//
//  Created by Victor Costan on 5/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserQueryCommController;
@class UserQueryResponse;


@interface NamedAccountViewController : UIViewController {
  IBOutlet UITextField* userNameText;
  IBOutlet UITextField* passwordText;
  IBOutlet UISwitch* passwordVisibleSwitch;
  IBOutlet UILabel* nameAvailabilityLabel;
  IBOutlet UIImageView* nameAvailabilityImage;
  
  UserQueryCommController* queryCommController;
  UserQueryResponse* lastQueryResponse;
  NSString* lastQueryName;
  NSTimeInterval lastQueryTime;
}
@property (nonatomic, readwrite, retain) UserQueryResponse* lastQueryResponse;
@property (nonatomic, readwrite, retain) NSString* lastQueryName;

-(IBAction)passwordVisibleChanged;
-(IBAction)claimNameTapped;
@end

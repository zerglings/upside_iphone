//
//  NamedAccountViewController.h
//  StockPlay
//
//  Created by Victor Costan on 5/9/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserQueryCommController;
@class UserQueryResponse;
@class UserUpdateCommController;


@interface NamedAccountViewController : UIViewController {
  IBOutlet UITextField* userNameText;
  IBOutlet UITextField* passwordText;
  IBOutlet UISwitch* passwordVisibleSwitch;
  IBOutlet UILabel* nameAvailabilityLabel;
  IBOutlet UIImageView* nameAvailabilityImage;
  IBOutlet UIView* progressIndicatorView;

  UserQueryCommController* queryCommController;
  UserQueryResponse* lastQueryResponse;
  UserUpdateCommController* updateCommController;
  NSString* lastQueryName;
  NSTimeInterval lastQueryTime;
}
@property (nonatomic, readwrite, retain) UserQueryResponse* lastQueryResponse;
@property (nonatomic, readwrite, retain) NSString* lastQueryName;

-(IBAction)passwordVisibleChanged;
-(IBAction)claimNameTapped;
@end

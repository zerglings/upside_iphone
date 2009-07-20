//
//  NamedAccountViewController.h
//  StockPlay
//
//  Created by Victor Costan on 5/9/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "BaseAccountViewController.h"

@class UserQueryCommController;
@class UserQueryResponse;

@interface NamedAccountViewController : BaseAccountViewController {
  UserQueryCommController* queryCommController;
  UserQueryResponse* lastQueryResponse;
  NSString* lastQueryName;
  NSTimeInterval lastQueryTime;
}
@property (nonatomic, readwrite, retain) UserQueryResponse* lastQueryResponse;
@property (nonatomic, readwrite, retain) NSString* lastQueryName;

-(IBAction)claimNameTapped;
@end

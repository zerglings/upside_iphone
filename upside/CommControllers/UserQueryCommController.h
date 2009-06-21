//
//  UserQueryCommController.h
//  StockPlay
//
//  Created by Victor Costan on 5/9/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ControllerSupport.h"
#import "ModelSupport.h"


@interface UserQueryCommController : ZNHttpJsonCommController {
}
-(void)startQueryForName:(NSString*)userName;
@end


// Definition for the response to user queries.
@interface UserQueryResponse : ZNModel {
  NSString* name;
  BOOL taken;
}
@property (nonatomic, readonly, retain) NSString* name;
@property (nonatomic, readonly, assign) BOOL taken;

@end

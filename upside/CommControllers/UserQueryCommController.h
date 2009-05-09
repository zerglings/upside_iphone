//
//  UserQueryCommController.h
//  upside
//
//  Created by Victor Costan on 5/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ModelSupport.h"


@interface UserQueryCommController : NSObject {
  NSArray* responseQueries;
  id target;
  SEL action;
}

// Designated initializer.
-(id)initWithTarget:(id)target action:(SEL)action;
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

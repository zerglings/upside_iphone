//
//  UserQueryCommController.m
//  StockPlay
//
//  Created by Victor Costan on 5/9/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "UserQueryCommController.h"

#import "ModelSupport.h"
#import "NetworkProgress.h"
#import "ServerPaths.h"
#import "ServiceError.h"
#import "User.h"
#import "WebSupport.h"


@implementation UserQueryCommController

-(id)initWithTarget:(id)theTarget action:(SEL)theAction {
  if ((self = [super init])) {
    target = theTarget;
    action = theAction;

    responseQueries =
    [[NSArray alloc] initWithObjects:
     [UserQueryResponse class], @"/result",
     [ServiceError class], @"/error", nil];
  }
  return self;
}
-(void)dealoc {
  [responseQueries release];
  [super dealloc];
}

-(void)startQueryForName:(NSString*)userName {
  User* queryUser = [[User alloc] initWithName:userName password:nil];

  NSDictionary* request = [[NSDictionary alloc] initWithObjectsAndKeys:
                           queryUser, @"user", nil];

  [NetworkProgress connectionStarted];
  [ZNJsonHttpRequest callService:[ServerPaths userQueryService]
                          method:[ServerPaths userQueryMethod]
                            data:request
                 responseQueries:responseQueries
                          target:self
                          action:@selector(processResponse:)];
}
-(void)processResponse:(NSArray*)response {
  [NetworkProgress connectionDone];
  [target performSelector:action withObject:response];
}

@end

@implementation UserQueryResponse
@synthesize name, taken;

-(void)dealloc {
  [name release];
  [super dealloc];
}
@end

//
//  LoginCommController.m
//  StockPlay
//
//  Created by Victor Costan on 1/20/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "LoginCommController.h"

#import "ActivationState.h"
#import "ControllerSupport.h"
#import "CryptoSupport.h"
#import "Device.h"
#import "LoginCommController.h"
#import "ServerPaths.h"
#import "ServiceError.h"
#import "User.h"
#import "WebSupport.h"

@implementation LoginCommController

@synthesize delegate;

-(id)init {
  if ((self = [super init])) {
    resposeQueries = [[NSArray alloc] initWithObjects:
                      [User class], @"/user",
                      [ServiceError class], @"/error", nil];
  }
  return self;
}

-(void)dealloc {
  [resposeQueries release];
  [super dealloc];
}


-(void)loginUsing:(ActivationState*)theActivationState {
  activationState = theActivationState;

  NSDictionary* request = [[NSDictionary alloc] initWithObjectsAndKeys:
                           activationState.user.name, @"name",
                           activationState.user.password, @"password",
                           activationState.deviceInfo, @"device",
                           [ZNAppFprint hexAppFprint], @"appSig",
                           nil];
  [ZNNetworkProgress connectionStarted];
  [ZNJsonHttpRequest callService:[ServerPaths loginUrl]
                          method:[ServerPaths loginMethod]
                            data:request
                 responseQueries:resposeQueries
                          target:self
                          action:@selector(serverResponded:)];
  [request release];
}

-(void)serverResponded:(NSArray*)response {
  [ZNNetworkProgress connectionDone];

  if ([response isKindOfClass:[NSError class]]) {
    [delegate loginFailed:(NSError*)response];
    return;
  }
  if ([response count] != 1) {
    [delegate loginFailed:
     [NSError errorWithDomain:@"StockPlay" code:0 userInfo:
      [NSDictionary dictionaryWithObjectsAndKeys:
       @"Login Failure", NSLocalizedDescriptionKey,
       @"Our server returned an invalid response.",
       NSLocalizedFailureReasonErrorKey, nil]]];
    return;
  }
  User* user = [response objectAtIndex:0];
  if ([user isKindOfClass:[ServiceError class]]) {
    [delegate loginFailed:
     [NSError errorWithDomain:@"StockPlay" code:1 userInfo:
      [NSDictionary dictionaryWithObjectsAndKeys:
       @"Login Rejected", NSLocalizedDescriptionKey,
       [(ServiceError*)user message], NSLocalizedFailureReasonErrorKey, nil]]];
    return;
  }
  User* finalUser = [[User alloc] initWithUser:user
                                      password:activationState.user.password];
  [activationState setUser:finalUser];
  [finalUser release];
  [activationState save];
  [delegate loginSucceeded];
}

@end

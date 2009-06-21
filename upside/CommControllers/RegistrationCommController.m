//
//  RegistrationCommController.m
//  StockPlay
//
//  Created by Victor Costan on 1/16/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "RegistrationCommController.h"

#import "ActivationState.h"
#import "ActivationState+Signature.h"
#import "ControllerSupport.h"
#import "Device.h"
#import "ServerPaths.h"
#import "ServiceError.h"
#import "User.h"
#import "WebSupport.h"


@implementation RegistrationCommController

-(id)init {
  if ((self = [super init])) {
    responseQueries = [[NSArray alloc] initWithObjects:
                       [Device class], @"/device",
                       [User class], @"/user",
                       [ServiceError class], @"/error", nil];
  }
  return self;
}

-(void)dealloc {
  [activationState release];
  [responseQueries release];
  [super dealloc];
}


-(void)registerDeviceUsing:(ActivationState*)theActivationState {
  [theActivationState retain];
  [activationState release];
  activationState = theActivationState;

  NSMutableDictionary* request =
      [[NSMutableDictionary alloc] initWithDictionary:[theActivationState
                                                       requestSignature]];
  [request setObject:[Device copyCurrentDevice] forKey:@"device"];
  [ZNNetworkProgress connectionStarted];
  [ZNJsonHttpRequest callService:[ServerPaths registrationUrl]
                          method:[ServerPaths registrationMethod]
                            data:request
                 responseQueries:responseQueries
                          target:self
                          action:@selector(serverResponded:)];
  [request release];
}

-(void)serverResponded:(NSArray*)response {
  [ZNNetworkProgress connectionDone];

  if ([response isKindOfClass:[NSError class]]) {
    [delegate activationFailed:(NSError*)response];
    return;
  }
  if ([response count] != 2) {
    [delegate activationFailed:
     [NSError errorWithDomain:@"StockPlay" code:0 userInfo:
      [NSDictionary dictionaryWithObjectsAndKeys:
       @"Activation Failure",
       NSLocalizedDescriptionKey,
       @"Our server returned an invalid response.",
       NSLocalizedFailureReasonErrorKey,
       nil]]];
    return;
  }

  Device* deviceInfo = [response objectAtIndex:0];
  NSAssert([deviceInfo isKindOfClass:[Device class]],
           @"The server's response did not have a device");
  [activationState setDeviceInfo:deviceInfo];

  User* user = [response objectAtIndex:1];
  NSAssert([user isKindOfClass:[User class]],
           @"The server's response did not have a user");
  [activationState setUser:user];

  [activationState save];
  [delegate activationSucceeded];
}

@end

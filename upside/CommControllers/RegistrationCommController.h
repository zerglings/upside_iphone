//
//  RegistrationCommController.h
//  StockPlay
//
//  Created by Victor Costan on 1/16/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <Foundation/Foundation.h>

// Communication controller for registering the device with the game server.
@protocol RegistrationCommDelegate
-(void)activationFailed:(NSError*)error;
-(void)activationSucceeded;
@end

@class RegistrationState;

@interface RegistrationCommController : NSObject {
  IBOutlet id<RegistrationCommDelegate> delegate;

  NSArray* responseQueries;
  RegistrationState* activationState;
}

// Try to register. Sends outcome via a message to the delegate.
-(void)registerDeviceUsing:(RegistrationState*)activationState;

@end

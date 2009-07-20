//
//  LoginCommController.h
//  StockPlay
//
//  Created by Victor Costan on 1/20/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoginCommDelegate
-(void)loginFailed:(NSError*)error;
-(void)loginSucceeded;
@end

@class RegistrationState;


// Communication controller that performs user logins on the game server.
@interface LoginCommController : NSObject {
  IBOutlet id<LoginCommDelegate> delegate;

  NSArray* resposeQueries;
  RegistrationState* activationState;
}

// Try to login. Sends outcome via a message to the delegate.
-(void)loginUsing:(RegistrationState*)activationState;

@property (nonatomic, assign) id<LoginCommDelegate> delegate;

@end

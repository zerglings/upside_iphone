//
//  ServiceError.h
//  StockPlay
//
//  Created by Victor Costan on 1/23/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelSupport.h"

// This is a model for <error> responses from the server.
@interface ServiceError : ZNModel {
  NSString* message;
  NSString* reason;
}

@property (nonatomic, readonly, retain) NSString* message;
@property (nonatomic, readonly, retain) NSString* reason;

// YES if the error is a "login required" error.
-(BOOL)isLoginError;

// YES if the error is an authentication error (bad login credentials).
-(BOOL)isAuthError;

// YES if the error is a model validation error.
-(BOOL)isValidationError;

// Convenience initializer for testing.
-(id)initWithReason:(NSString*)reason message:(NSString*)error;

@end

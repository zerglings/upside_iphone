//
//  LoginCommController.h
//  upside
//
//  Created by Victor Costan on 1/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoginCommDelegate
- (void)loginFailed: (NSError*)error;
- (void)loginSucceeded;
@end

@class ActivationState;


@interface LoginCommController : NSObject {
	IBOutlet id<LoginCommDelegate> delegate;
	
	NSDictionary* resposeModels;
	ActivationState* activationState;
}

// Try to login. Sends outcome via a message to the delegate.
- (void) loginUsing: (ActivationState*)activationState;

@property (nonatomic, assign) id<LoginCommDelegate> delegate;

@end

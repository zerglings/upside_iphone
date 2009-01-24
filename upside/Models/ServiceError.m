//
//  ServiceError.m
//  upside
//
//  Created by Victor Costan on 1/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ServiceError.h"

@implementation ServiceError

- (BOOL) isLoginError {
	return [reason isEqualToString:@"login"];
}

- (BOOL) isAuthError {
	return [reason isEqualToString:@"auth"];
}

- (id) initWithReason: (NSString*)theReason message: (NSString*)theMessage {
	NSDictionary* props = [[NSDictionary alloc] initWithObjectsAndKeys:
						   theMessage, @"message", theReason, @"reason", nil];
	self = [self initWithModel:nil properties:props];
	[props release];
	return self;
}

@end
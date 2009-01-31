//
//  User.h
//  StockPlay
//
//  Created by Victor Costan on 1/19/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ModelSupport.h"

@class Device;

@interface User : ZNModel {
	NSString* name;
	NSString* password;
	NSUInteger modelId;
	BOOL isPseudoUser;
}

// The user's name, used to login.
@property (nonatomic, readonly, retain) NSString* name;
// The user's password, used to login.
@property (nonatomic, readonly, retain) NSString* password;
// The ID of this user in the server database.
@property (nonatomic, readonly) NSUInteger modelId;
// YES if the user is a pseudo-user, NO if it's a site user.
@property (nonatomic, readonly) BOOL isPseudoUser;

// Initialize a user with the information of a device's pseudo-user.
-(id)initPseudoUser: (Device*)device;

// Initialize a user with information from a login box.
-(id)initWithName: (NSString*)name password: (NSString*)password;

// Initialize with information from an existing user, plus a password.
-(id)initWithUser: (User*)user password: (NSString*)password;

@end

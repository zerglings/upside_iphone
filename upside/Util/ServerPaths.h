//
//  ServerPaths.h
//  upside
//
//  Created by Victor Costan on 1/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ServerPaths : NSObject {
}

// The root server URL.
+ (NSString*) serverUrl;

// Points to the device registration service.
+ (NSString*) registrationUrl;
// Method to use for the registration service.
+ (NSString*) registrationMethod;

// Points to the user login service.
+ (NSString*) loginUrl;
// Method to use for the login service.
+ (NSString*) loginMethod;

@end

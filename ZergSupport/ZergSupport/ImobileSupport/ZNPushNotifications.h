//
//  ZNPushNotifications.h
//  ZergSupport
//
//  Created by Victor Costan on 7/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>


@interface ZNPushNotifications : NSObject {
}

// Asks iPhone OS to enable this application for notifications.
+(void)enableNotifications;
// Called when iPhone OS provides a notification token to this application.
+(void)receivedToken:(NSData*)token;

@end

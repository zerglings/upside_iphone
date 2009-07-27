//
//  ZNPushNotifications.h
//  ZergSupport
//
//  Created by Victor Costan on 7/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

@class ZNTargetActionSet;


@interface ZNPushNotifications : NSObject {
  NSData* pushToken;
  ZNTargetActionSet* pushTokenChangedSite;
  ZNTargetActionSet* notificationSite;
}

// Target-action site that gets activated on push notifications.
//
// Site listeners receive the notification dictionary.
+(ZNTargetActionSet*)notificationSite;

// Asks iPhone OS to enable this application for notifications.
+(void)enableNotifications;

// The notification token for this application.
//
// The method returns nil if the application didn't receive a token This can
// happen if the user didn't accept notifications, or if the device couldn't
// connect to Apple's servers since the user accepted notifications.
+(NSData*)pushToken;

// Target-action site that gets activated on push notifications token changes.
//
// Site listeners receive the new device token as the only call argument.
+(ZNTargetActionSet*)pushTokenChangedSite;

// Called when this application receives a push notification.
+(void)receivedPushNotification:(NSDictionary*)notificationData;

// Called when iPhone OS provides a notification token to this application.
+(void)receivedPushToken:(NSData*)deviceToken;

@end

//
//  ZNPushNotifications.m
//  ZergSupport
//
//  Created by Victor Costan on 7/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNPushNotifications.h"

#import "ZNImobileDevice.h"


@implementation ZNPushNotifications

+(void)enableNotifications {
  UIRemoteNotificationType allTypes = UIRemoteNotificationTypeBadge |
      UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
  
  [[UIApplication sharedApplication]
   registerForRemoteNotificationTypes:allTypes];  
}

+(void)receivedToken:(NSData *)token {
  // If the app is being debugged on a device, log the push notifications token.
  // This is useful for testing server-side notification pushing.
  if ([ZNImobileDevice appProvisioning] == kZNImobileProvisioningDeviceDebug) {
    NSLog(@"Push notifications token: %@", [token description]);
  }
}

@end

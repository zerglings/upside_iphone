//
//  ZNPushNotifcationsDelegate.m
//  ZergSupport
//
//  Created by Victor Costan on 7/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNPushNotifcationsDelegate.h"

#import "ZNPushNotifications.h"


@implementation ZNPushNotifcationsDelegate

-(void)applicationDidFinishLaunching:(UIApplication *)application {
  [ZNPushNotifications enableNotifications];
}
-(void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  [ZNPushNotifications receivedToken:deviceToken];
}
-(void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  NSAssert1(NO, @"Push notification registration failed - %@",
            [error description]);
}

@end

//
//  ZNPushNotifications.m
//  ZergSupport
//
//  Created by Victor Costan on 7/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNPushNotifications.h"

#import "ControllerSupport.h"
#import "ZNExtUIApplication.h"
#import "ZNImobileDevice.h"


@interface ZNPushNotifications ()
@property (nonatomic, retain, readonly) ZNTargetActionSet* notificationSite;
@property (retain, readwrite) NSData* pushToken;
@property (nonatomic, retain, readonly) ZNTargetActionSet* pushTokenChangedSite;
@end


@implementation ZNPushNotifications
@synthesize notificationSite, pushToken, pushTokenChangedSite;

#pragma mark Lifecycle

-(id)init {
  if ((self = [super init])) {
    pushToken = nil;
    notificationSite = [[ZNTargetActionSet alloc] init];
    pushTokenChangedSite = [[ZNTargetActionSet alloc] init];
  }
  return self;
}
-(void)dealloc {
  [pushToken release];

  [super dealloc];
}

#pragma mark Notification Handling

-(void)enableNotifications {
  UIRemoteNotificationType allTypes = UIRemoteNotificationTypeBadge |
  UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;

  [[UIApplication sharedApplication]
   registerForRemoteNotificationTypes:allTypes];
}

-(void)receivedDeviceToken:(NSData*)theDeviceToken {
  self.pushToken = theDeviceToken;
  [pushTokenChangedSite performWithObject:theDeviceToken];

  // If the app is being debugged on a device, log the push notifications token.
  // This is useful for testing server-side notification pushing.
  if ([ZNImobileDevice appProvisioning] == kZNImobileProvisioningDeviceDebug) {
    NSLog(@"Push notifications token: %@", [pushToken description]);
  }
}

-(void)receivedPushNotification:(NSDictionary*)notificationData {
  [notificationSite performWithObject:notificationData];
}

#pragma mark Singleton

static ZNPushNotifications* sharedInstance;

+(ZNPushNotifications*)sharedNotifications {
  @synchronized([ZNPushNotifications class]) {
    if (sharedInstance == nil) {
      sharedInstance = [[ZNPushNotifications alloc] init];
    }
  }
  return sharedInstance;
}

#pragma mark Class Method Delegates

+(NSData*)pushToken {
  return [[ZNPushNotifications sharedNotifications] pushToken];
}
+(void)enableNotifications {
  [[ZNPushNotifications sharedNotifications] enableNotifications];
}
+(void)receivedPushToken:(NSData*)deviceToken {
  [[ZNPushNotifications sharedNotifications] receivedDeviceToken:deviceToken];
}
+(void)receivedPushNotification:(NSDictionary*)notificationData {
  [[ZNPushNotifications sharedNotifications]
   receivedPushNotification:notificationData];
}
+(ZNTargetActionSet*)pushTokenChangedSite {
  return [[ZNPushNotifications sharedNotifications] pushTokenChangedSite];
}
+(ZNTargetActionSet*)notificationSite {
  return [[ZNPushNotifications sharedNotifications] notificationSite];
}
@end


// Chained (secondary) application delegate handling push notifications.
@interface ZNPushNotifcationsDelegate :
    NSObject<UIApplicationDelegate, ZNAutoUIApplicationDelegate> {

}
@end


@implementation ZNPushNotifcationsDelegate

-(void)applicationDidFinishLaunching:(UIApplication *)application {
  [ZNPushNotifications enableNotifications];
}

-(void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  [ZNPushNotifications receivedPushToken:deviceToken];
}

-(void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  if ([ZNImobileDevice inSimulator]) {
    NSLog(@"%@", [error description]);
  }
  else {
    NSAssert1(NO, @"Push notification registration failed - %@",
              [error description]);
  }
}

-(void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
  [ZNPushNotifications receivedPushNotification:userInfo];
}
@end


// Hidden chained application delegate handling push notifications.
@interface ZNPushNotificationsHiddenDelegate :
    NSObject<UIApplicationDelegate, ZNAutoUIHiddenApplicationDelegate> {

}
@end


@implementation ZNPushNotificationsHiddenDelegate

-(BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [ZNPushNotifications enableNotifications];
  NSDictionary* notificationData =
      [launchOptions
       objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
  if (notificationData) {
    [ZNPushNotifications receivedPushNotification:notificationData];
  }
  return YES;
}

@end

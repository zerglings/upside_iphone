//
//  ZNPushNotificationsTest.m
//  ZergSupport
//
//  Created by Victor Costan on 7/26/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ZNPushNotifications.h"

#import "ControllerSupport.h"
#import "CryptoSupport.h"
#import "WebSupport.h"
#import "ZNImobileDevice.h"


@interface ZNPushNotificationsTest : SenTestCase {
  NSDictionary* notificationData;
  NSString* pushCertificate;
  NSString* nonce;
  NSString* testService;
  BOOL receivedResponse;
  BOOL receivedNotification;
}
@end


@implementation ZNPushNotificationsTest

-(void)warmUpHerokuService:(NSString*)herokuService {
  // Issues a request to the testbed, so heroku loads it up on a machine
  [NSString stringWithContentsOfURL:[NSURL URLWithString:herokuService]
                           encoding:NSUTF8StringEncoding
                              error:NULL];
}

-(NSString*)pushCertificate {
  NSString* certificatePath;
  if ([ZNImobileDevice appProvisioning] ==
      kZNImobileProvisioningDeviceDistribution) {
    certificatePath = [[[self testBundle] resourcePath]
                       stringByAppendingPathComponent:
                       @"ZNPushNotificationsTestCertProd.p12"];
  }
  else {
    certificatePath = [[[self testBundle] resourcePath]
                       stringByAppendingPathComponent:
                       @"ZNPushNotificationsTestCertDev.p12"];
  }
  return [NSString stringWithContentsOfFile:certificatePath
                                   encoding:NSISOLatin1StringEncoding
                                      error:NULL];
}

-(void)setUp {
  [[ZNPushNotifications notificationSite]
   addTarget:self
   action:@selector(checkNotification:)];

  nonce = [[NSString alloc] initWithFormat:@"%lf",
           [NSDate timeIntervalSinceReferenceDate]];

  receivedResponse = NO;
  receivedNotification = NO;

  pushCertificate = [[self pushCertificate] retain];

  notificationData =
      [[NSDictionary alloc] initWithObjectsAndKeys:
       [NSDictionary dictionaryWithObjectsAndKeys:
        @"ZergSupport test notification", @"alert",
        nil], @"aps",
       nonce, @"nonce",
       nil];

  testService =
      @"http://zn-testbed.heroku.com/imobile_support/push_notification.json";
  [self warmUpHerokuService:testService];
}
-(void)tearDown {
  [[ZNPushNotifications notificationSite]
   removeTarget:self
   action:@selector(checkNotification:)];
  [nonce release];
  [pushCertificate release];
}


-(void)testPushNotifications {
  if ([ZNImobileDevice inSimulator]) {
    NSLog(@"StoreKit cannot be tested in the Simulator. Please run tests on "
          @"real hardware if you make changes to ZNAppStoreRequest.");
    return;
  }

  // Wait to get a push token.
  for (NSUInteger i = 0; i < 100; i++) {
    [[NSRunLoop currentRunLoop] runUntilDate:
     [NSDate dateWithTimeIntervalSinceNow:0.1]];
    if ([ZNImobileDevice appPushToken]) {
      break;
    }
  }
  STAssertNotNil([ZNImobileDevice appPushToken],
                 @"Device didn't receive a token for push notifications");

  // Ask the Web service to send a push notification.
  NSDictionary* deviceAttributes = [ZNAppFprint copyDeviceAttributes];
  NSDictionary* request = [NSDictionary dictionaryWithObjectsAndKeys:
                           pushCertificate, @"certificate",
                           deviceAttributes, @"device",
                           notificationData, @"notification", nil];
  [deviceAttributes release];
  [ZNJsonHttpRequest callService:testService
                          method:kZNHttpMethodPost
                            data:request
                 responseQueries:[NSArray arrayWithObjects:
                                  [NSNull null], @"/response", nil]
                          target:self
                          action:@selector(checkWebResponse:)];
  for (NSUInteger i = 0; i < 100; i++) {
    [[NSRunLoop currentRunLoop] runUntilDate:
     [NSDate dateWithTimeIntervalSinceNow:0.1]];
    if (receivedResponse) {
      break;
    }
  }
  STAssertEquals(YES, receivedResponse,
                 @"Notification push service didn't respond");

  for (NSUInteger i = 0; i < 600; i++) {
    [[NSRunLoop currentRunLoop] runUntilDate:
     [NSDate dateWithTimeIntervalSinceNow:0.1]];
    if (receivedNotification) {
      break;
    }
  }
  STAssertEquals(YES, receivedNotification,
                 @"Notification push service didn't respond");
}

-(void)checkWebResponse:(NSArray*)response {
  receivedResponse = YES;
  STAssertFalse([response isKindOfClass:[NSError class]],
                @"Push error: %@", [response description]);

  STAssertEqualStrings(@"ok", [[response objectAtIndex:0]
                               objectForKey:@"status"],
                       @"Push service failed");
}

-(void)checkNotification:(NSDictionary*)data {
  if (![nonce isEqualToString:[data objectForKey:@"nonce"]])
    return;

  receivedNotification = YES;
  STAssertEqualObjects(notificationData, data, @"Bad notification data");
}

@end

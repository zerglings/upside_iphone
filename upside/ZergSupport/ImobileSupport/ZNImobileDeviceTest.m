//
//  ZNImobileDeviceTest.m
//  ZergSupport
//
//  Created by Victor Costan on 7/22/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ZNImobileDevice.h"

#import "ZNPushNotifications.h"


// Reaching into private method for testing convenience.
@interface ZNImobileDevice ()
+(NSUInteger)appProvisioningInSimulator:(BOOL)inSimulator
                                inDebug:(BOOL)inDebug
                        encryptedBinary:(BOOL)encryptedBinary;
+(BOOL)isEncryptedBinary:(NSString*)path;
@end


@interface ZNImobileDeviceTest : SenTestCase {
  NSCharacterSet* digits;
}
@end


@implementation ZNImobileDeviceTest

-(void)setUp {
  digits = [NSCharacterSet decimalDigitCharacterSet];
}
-(void)tearDown {
}
-(void)dealloc {
  [super dealloc];
}

-(void)testAppId {
  // NOTE: The appId below is hard-coded in the Info.plist for
  //       ZergSupportTests. The test will probably fail when included in
  //       another suite.
  STAssertEqualStrings(@"us.costan.ZergSupportTests",
                       [ZNImobileDevice appId], @"Hard-coded bundle ID");
}
-(void)testAppVersion {
  // NOTE: The appVersion below is hard-coded in the Info.plist for
  //       ZergSupportTests. The test will probably fail when included in
  //       another suite.
  STAssertEqualStrings(@"1.9.8.3", [ZNImobileDevice appVersion],
                       @"Hard-coded bundle version");
}

-(void)testHardwareModel {
  // NOTE: The checks below make assumptions on Apple's future moves. They
  //       will break if the assumptions are wrong. The main point of the test
  //       is to make sure that the value looks right.

  // hardwareModel should be i386 or somethingX,Y where X and Y are digits.
  NSString* model = [ZNImobileDevice hardwareModel];
  NSRange comma = [model rangeOfString:@","];
  if (comma.length == 0) {
    STAssertEqualStrings(@"i386", model,
                         @"Simulator hardwareModel should be i386");
  }
  else {
    STAssertTrue([digits characterIsMember:
                  [model characterAtIndex:(comma.location - 1)]],
                 @"Device hardwareModel should have a digit before ,");
    STAssertTrue([digits characterIsMember:
                  [model characterAtIndex:(comma.location + 1)]],
                 @"Device hardwareModel should have a digit after ,");
  }
}

-(void)testOsName {
  // NOTE: The checks below make assumptions on Apple's future moves. They
  //       will break if the assumptions are wrong. The main point of the test
  //       is to make sure that the value looks right.

  STAssertEqualObjects(@"iPhone OS", [ZNImobileDevice osName], @"osName");
}
-(void)testOsVersion {
  // NOTE: The checks below make assumptions on Apple's future moves. They
  //       will break if the assumptions are wrong. The main point of the test
  //       is to make sure that the value looks right.

  NSString* osVersion = [ZNImobileDevice osVersion];
  STAssertTrue([digits characterIsMember:[osVersion characterAtIndex:0]],
               @"osVersion should start with a digit");
  STAssertEquals((unichar)'.', [osVersion characterAtIndex:1],
                 @"osVersion should have a . after the first digit");
  STAssertTrue([digits characterIsMember:[osVersion characterAtIndex:2]],
               @"osVersion should have a digit after the first .");
}
-(void)testUniqueDeviceId {
  STAssertEquals(40U, [[ZNImobileDevice uniqueDeviceId] length],
                 @"UDID length");
}

-(void)testAppProvisioning {
  // Logic testing.
  BOOL inSimulator[] =     {NO, NO,  NO,  NO,  YES, YES, YES, YES};
  BOOL inDebug[] =         {NO, YES, NO,  YES, NO,  YES, NO,  YES};
  BOOL encryptedBinary[] = {NO, NO,  YES, YES, NO,  NO,  YES, YES};
  NSUInteger golden[] = {
    kZNImobileProvisioningDeviceRelease,
    kZNImobileProvisioningDeviceDebug,
    kZNImobileProvisioningDeviceDistribution,
    kZNImobileProvisioningDeviceDistribution,
    kZNImobileProvisioningSimulatorRelease,
    kZNImobileProvisioningSimulatorDebug,
    kZNImobileProvisioningSimulatorRelease,
    kZNImobileProvisioningSimulatorDebug
  };
  for (NSUInteger i = 0; i < sizeof(golden) / sizeof(*golden); i++) {
    STAssertEquals(golden[i],
                   [ZNImobileDevice appProvisioningInSimulator:inSimulator[i]
                                                       inDebug:inDebug[i]
                                               encryptedBinary:
                    encryptedBinary[i]],
                   @"Logic test: Simulator %d Debug %d Encrypted %d",
                   inSimulator[i], inDebug[i], encryptedBinary[i]);
  }


  // Integration testing.
  NSUInteger appProvisioning = [ZNImobileDevice appProvisioning];
  STAssertTrue(appProvisioning > 0 &&
               appProvisioning <= kZNImobileProvisioningDeviceDistribution,
               @"App provisioning type out of range: %u", appProvisioning);
}

-(void)testInSimulator {
  STAssertEquals([@"i386" isEqualToString:[ZNImobileDevice hardwareModel]],
                 [ZNImobileDevice inSimulator],
                 @"In-simulator test with hardware model");
}

-(void)testAppPushToken {
  if ([ZNImobileDevice inSimulator]) {
    STAssertNil([ZNImobileDevice appPushToken],
                @"The simulator shouldn't support push notifications");
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

  STAssertEquals(32U, [[ZNImobileDevice appPushToken] length],
                 @"Push token length");
  STAssertEqualObjects([ZNPushNotifications pushToken],
                       [ZNImobileDevice appPushToken],
                       @"Cross-check with the token in ZNPushNotification");
}

-(void)testIsEncryptedBinaryOnPlain {
  NSString* plainBinary = [[[self testBundle] resourcePath]
                           stringByAppendingPathComponent:
                           @"ZNImobileDeviceTestPlain"];
  STAssertFalse([ZNImobileDevice isEncryptedBinary:plainBinary],
                @"False positive in binary encryption detection");
}

-(void)testIsEncryptedBinaryOnEncrypted {
  NSString* encryptedBinary = [[[self testBundle] resourcePath]
                               stringByAppendingPathComponent:
                               @"ZNImobileDeviceTestEncrypted"];
  STAssertTrue([ZNImobileDevice isEncryptedBinary:encryptedBinary],
               @"False negative in binary encryption detection");
}
@end

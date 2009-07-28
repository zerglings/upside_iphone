//
//  RegistrationStateTest.m
//  StockPlay
//
//  Created by Victor Costan on 1/2/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "TestSupport.h"

#import "RegistrationState.h"
#import "CryptoSupport.h"
#import "Device.h"
#import "User.h"

@interface RegistrationStateTest : SenTestCase {
  RegistrationState* activationState;
  Device* testDevice;
  User* testUser;
}

@end


@implementation RegistrationStateTest

-(void)setUp {
  [RegistrationState removeSavedState];
  activationState = [[RegistrationState alloc] init];

  NSDictionary* deviceAttributes = [ZNAppFprint copyDeviceAttributes];
  testDevice = [[Device alloc] initWithProperties:
                [NSDictionary dictionaryWithObjectsAndKeys:
                 [deviceAttributes objectForKey:@"uniqueId"],
                 @"uniqueId", nil]];
  [deviceAttributes release];
  testUser = [[User alloc] initPseudoUser:testDevice];
}

-(void)tearDown {
  [RegistrationState removeSavedState];
  [activationState release];
  [testDevice release];
  [testUser release];
}

-(void)dealloc {
  [super dealloc];
}

-(void)testSingleton {
  STAssertEqualObjects([RegistrationState sharedState],
                       [RegistrationState sharedState],
                       @"+sharedState vends different objects");
}

-(void)testEncoding {
  activationState.deviceInfo = testDevice;
  activationState.user = testUser;
  NSData* encoded = [activationState archiveToData];

  RegistrationState* newActivationState = [[RegistrationState alloc] init];
  [newActivationState unarchiveFromData:encoded];
  STAssertTrue([newActivationState isRegistered],
               @"-decodeFromData did not restore activation state");

  STAssertEqualStrings(testDevice.uniqueId,
                       newActivationState.deviceInfo.uniqueId,
                       @"Device's unique ID restored incorrectly");
  STAssertEqualStrings(testUser.name,
                       newActivationState.user.name,
                       @"User's name restored incorrectly");
  [newActivationState release];
}

-(void)testDecodingNil {
  [activationState unarchiveFromData:nil];
  STAssertFalse([activationState isRegistered],
                @"-decodeFromData with nil did not set de-activation state");
}

-(void)testLoadInitialization {
  activationState.deviceInfo = testDevice;
  [activationState load];

  STAssertEquals(NO, [activationState isRegistered],
                 @"dry -load does not set activated to NO");
}

-(void)testSaving {
  activationState.deviceInfo = testDevice;
  [activationState save];

  RegistrationState* newActivationState = [[RegistrationState alloc] init];
  [newActivationState load];
  STAssertTrue([newActivationState isRegistered],
               @"-load does not restore activated state");
  [newActivationState release];
}

-(void)testUpdateDevice {
  activationState.deviceInfo = testDevice;
  activationState.user = testUser;
  [activationState updateDeviceInfo];
  STAssertTrue([[activationState deviceInfo] isEqualToCurrentDevice],
               @"updateDeviceInfo did not yield a current device");
}

@end

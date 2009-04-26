//
//  ActivationStateTest.m
//  StockPlay
//
//  Created by Victor Costan on 1/2/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "TestSupport.h"

#import "ActivationState.h"
#import "CryptoSupport.h"
#import "Device.h"
#import "User.h"

@interface ActivationStateTest : SenTestCase {
	ActivationState* activationState;
	Device* testDevice;
	User* testUser;
}

@end


@implementation ActivationStateTest

-(void)setUp {
	[ActivationState removeSavedState];
	activationState = [[ActivationState alloc] init];
	
	testDevice = [[Device alloc] initWithProperties:
                [NSDictionary dictionaryWithObjectsAndKeys:
                 [[ZNDeviceFprint deviceAttributes] objectForKey:@"uniqueId"],
                 @"uniqueId", nil]];
	testUser = [[User alloc] initPseudoUser:testDevice];
}

-(void)tearDown {
	[ActivationState removeSavedState];
	[activationState release];
	[testDevice release];
	[testUser release];
}

-(void)dealloc {
	[super dealloc];
}

-(void)testSingleton {
	STAssertEqualObjects([ActivationState sharedState],
                       [ActivationState sharedState],
                       @"+sharedState vends different objects");
}

-(void)testEncoding {
	activationState.deviceInfo = testDevice;
	activationState.user = testUser;
	NSData* encoded = [activationState archiveToData];
	
	ActivationState* newActivationState = [[ActivationState alloc] init];
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
	
	ActivationState* newActivationState = [[ActivationState alloc] init];
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

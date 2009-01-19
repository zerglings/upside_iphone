//
//  ActivationStateTest.m
//  upside
//
//  Created by Victor Costan on 1/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GTMSenTestCase.h"

#import "ActivationState.h"
#import "Device.h"

@interface ActivationStateTest : SenTestCase {
	ActivationState* activationState;
	Device* testDevice;
}

@end


@implementation ActivationStateTest

- (void) setUp {
	[ActivationState removeSavedState];
	activationState = [[ActivationState alloc] init];
	
	testDevice = [[Device alloc] initWithProperties:
				  [NSDictionary dictionaryWithObjectsAndKeys:
				   [Device currentDeviceId], @"uniqueId", nil]];
}

- (void) dealloc {
	[activationState release];
	[testDevice release];
	[super dealloc];
}

- (void) testSingleton {
	STAssertEqualObjects([ActivationState sharedState],
						 [ActivationState sharedState],
						 @"+sharedState vends different objects");
}

- (void) testEncoding {
	[activationState activateWithInfo:testDevice];
	NSData* encoded = [activationState archiveToData];
	
	ActivationState* newActivationState = [[ActivationState alloc] init];
	[newActivationState unarchiveFromData:encoded];	
	STAssertTrue([newActivationState isActivated],
				 @"-decodeFromData did not restore activation state");
	
	STAssertEqualStrings(testDevice.uniqueId,
						 newActivationState.deviceInfo.uniqueId,
						 @"Device's unique ID restored incorrectly");
	[newActivationState release];
}

- (void) testDecodingNil {	
	[activationState unarchiveFromData:nil];
	STAssertFalse([activationState isActivated],
				  @"-decodeFromData with nil did not set de-activation state");
}

- (void) testLoadInitialization {
	[activationState activateWithInfo:testDevice];
	[activationState load];
	
	STAssertEquals(NO, [activationState isActivated],
				   @"dry -load does not set activated to NO");
}

- (void) testSaving {
	[activationState activateWithInfo:testDevice];
	[activationState save];
	
	ActivationState* newActivationState = [[ActivationState alloc] init];
	[newActivationState load];
	STAssertTrue([newActivationState isActivated],
				 @"-load does not restore activated state");
	[newActivationState release];
}

@end

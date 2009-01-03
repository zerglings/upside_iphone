//
//  ActivationStateTest.m
//  upside
//
//  Created by Victor Costan on 1/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GTMSenTestCase.h"
#import "ActivationState.h"

@interface ActivationStateTest: SenTestCase
{
	ActivationState* activationState;
}

@end


@implementation ActivationStateTest

- (void) setUp {
	activationState = [ActivationState sharedState];
}

- (void) testSingleton {
	STAssertEqualObjects([ActivationState sharedState],
						 activationState,
						 @"+sharedState vends different objects");
}

- (void) testEncoding {
	activationState.activated = YES;
	NSData* encoded = [activationState archiveToData];
	activationState.activated = NO;
	[activationState unarchiveFromData:encoded];
	
	STAssertEquals(YES, activationState.activated,
				   @"-decodeFromData does not restore activated state");
}

- (void) testSaving {
	activationState.activated = YES;
	[activationState save];
	activationState.activated = NO;
	[activationState load];
	
	STAssertEquals(YES, activationState.activated,
				   @"-load does not restore activated state");
}

@end

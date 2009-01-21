//
//  UserTest.m
//  upside
//
//  Created by Victor Costan on 1/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TestSupport.h"

#import "Device.h"
#import "User.h"

@interface UserTest : SenTestCase {
	Device* testDevice;
}

@end


@implementation UserTest

- (void) setUp {
	testDevice = [[Device alloc] initWithProperties:
				  [NSDictionary dictionaryWithObjectsAndKeys:
				   @"3141531415314153141531415314153141531415", @"uniqueId",
				   nil]];
}

- (void) tearDown {
	[testDevice release];
}

- (void) dealloc {
	[super dealloc];
}

- (void) testPseudoUserGeneration {
	User* pseudoUser = [[[User alloc] initPseudoUser:testDevice] autorelease];
	
	STAssertEqualStrings(testDevice.uniqueId, pseudoUser.password,
						 @"Pseudo-user password equals its UDID");
	STAssertEqualStrings(@"a5f271f817c04cca75e8e8ae70b2ca1733956aeef8f787de0e3203555db69602",
						 pseudoUser.name,
						 @"Pseudo-user name is the hash of its UDID");
}

@end

//
//  RegistrationCommController.m
//  upside
//
//  Created by Victor Costan on 1/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RegistrationCommController.h"

#import "ActivationState.h"
#import "Device.h"
#import "NetworkProgress.h"
#import "ServerPaths.h"
#import "User.h"
#import "WebSupport.h"


@implementation RegistrationCommController

- (id) init {
	if ((self = [super init])) {
		resposeModels = [[NSDictionary alloc] initWithObjectsAndKeys:
                     [Device class], @"device",
                     [User class], @"user", nil];
	}
	return self;
}

- (void) dealloc {
	[resposeModels release];
	[super dealloc];
}


- (void) registerDeviceUsing: (ActivationState*)theActivationState {
	activationState = theActivationState;
	NSString* deviceID = [Device currentDeviceId];
	
	NSDictionary* request = [[NSDictionary alloc] initWithObjectsAndKeys:
                           deviceID, @"unique_id", nil];
  [NetworkProgress connectionStarted];
	[ZNXmlHttpRequest callService:[ServerPaths registrationUrl]
                         method:[ServerPaths registrationMethod]
                           data:request
                 responseModels:resposeModels
                         target:self
                         action:@selector(serverResponded:)];
	[request release];
}

- (void) serverResponded: (NSArray*)response {
  [NetworkProgress connectionDone];
  
	if ([response isKindOfClass:[NSError class]]) {
		[delegate activationFailed:(NSError*)response];
		return;
	}
	if ([response count] != 2) {
		[delegate activationFailed:
		 [NSError errorWithDomain:@"StockPlay" code:0 userInfo:
		  [NSDictionary dictionaryWithObjectsAndKeys:
		   @"Activation Failure",
		   NSLocalizedDescriptionKey,
		   @"Our server returned an invalid response.",
		   NSLocalizedFailureReasonErrorKey,
		   nil]]];
		return;
	}
	
	Device* deviceInfo = [response objectAtIndex:0];
	NSAssert([deviceInfo isKindOfClass:[Device class]],
           @"The server's response did not have a device");
	[activationState setDeviceInfo:deviceInfo];
  
	User* user = [response objectAtIndex:1];
	NSAssert([user isKindOfClass:[User class]],
           @"The server's response did not have a user");
	[activationState setUser:user];
	
	[activationState save];	
	[delegate activationSucceeded];
}

@end

//
//  ActivationCommController.m
//  upside
//
//  Created by Victor Costan on 1/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ActivationCommController.h"

#import "ActivationState.h"
#import "Device.h"
#import "WebSupport.h"


@implementation ActivationCommController

- (id) init {
	if ((self = [super init])) {
		activationService = @"http://moonstone.local:3000/devices/register.xml";
		resposeModels = [[NSDictionary alloc] initWithObjectsAndKeys:
						 [Device class], @"device", nil];
	}
	return self;
}

- (void) dealloc {
	[activationService release];
	[resposeModels release];
	[super dealloc];
}


- (void) activateDevice {
	NSString* deviceID = [Device currentDeviceId];
	
	NSDictionary* request = [[NSDictionary alloc] initWithObjectsAndKeys:
							 deviceID, @"unique_id", nil];
	[ZNXmlHttpRequest callService:activationService
						   method:kZNHttpMethodPut
							 data:request
				   responseModels:resposeModels
						   target:self
						   action:@selector(serverResponded:)];
	[request release];
}

- (void) serverResponded: (NSArray*)response {
	if ([response isKindOfClass:[NSError class]]) {
		[delegate activationFailed:(NSError*)response];
		return;
	}
	if ([response count] == 0) {
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
			 @"The server's response was not a device");
	[[ActivationState sharedState] activateWithInfo:deviceInfo];
	[[ActivationState sharedState] save];	
	[delegate activationSucceeded];
}

@end

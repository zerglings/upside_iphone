//
//  ActivationCommController.m
//  upside
//
//  Created by Victor Costan on 1/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ActivationCommController.h"

#import "WebSupport.h"


@implementation ActivationCommController

- (void) init {
	if ((self = [super init])) {
		activationService = @"http://moonstone.local:3000/devices/register.xml";
	}
}

- (void) dealloc {
	[activationService release];
	[super dealloc];
}


- (void) activateDevice {
	NSString* uniqueID = [[UIDevice currentDevice] uniqueIdentifier];
	NSURLRequest* request =
	[ZNXmlHttpRequest createURLRequestToService:activationService
										   data:
	[NSDictionary dictionaryWithObjectsAndKeys:
	  uniqueID, @"unique_id", nil]];
		
	NSURLConnection* connection = [[NSURLConnection alloc]
								   initWithRequest:request
								   delegate:self];
	[connection release];
	[request release];
}

@end

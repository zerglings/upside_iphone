//
//  ActivationCommController.m
//  upside
//
//  Created by Victor Costan on 1/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ActivationCommController.h"

#import "ZNFormURLEncoder.h"


@implementation ActivationCommController

- (void) init {
	if ((self = [super init])) {
		activationUrl = [[NSURL alloc] initWithString:
						 @"http://moonstone.local:3000/devices/register.xml"];
	}
}

- (void) dealloc {
	[activationUrl release];
	[super dealloc];
}


- (void) activateDevice {
	NSString* uniqueID = [[UIDevice currentDevice] uniqueIdentifier];
	
	NSMutableURLRequest* request = [[NSMutableURLRequest alloc]
									initWithURL:activationUrl];
	[request setHTTPMethod:@"POST"];
	NSData* encodedBody = [ZNFormURLEncoder createEncodingFor:
						   [NSDictionary dictionaryWithObjectsAndKeys:
							uniqueID, @"unique_id", nil]];
	[request setHTTPBody:encodedBody];
	[request addValue:@"application/x-www-form-urlencoded"
   forHTTPHeaderField:@"Content-Type"];
	[request addValue:[NSString stringWithFormat:@"%u", [encodedBody length]]
   forHTTPHeaderField:@"Content-Length"];
									 
		
	NSURLConnection* connection = [[NSURLConnection alloc]
								   initWithRequest:request
								   delegate:self];
	[connection release];
	[request release];
}

@end

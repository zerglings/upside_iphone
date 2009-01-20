//
//  Device.m
//  upside
//
//  Created by Victor Costan on 1/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Device.h"

@implementation Device

@synthesize modelId, userId, uniqueId;

- (void) dealloc {
	[uniqueId release];
	[super dealloc];
}

+ (NSString*) currentDeviceId {
	NSString* udid = [[UIDevice currentDevice] uniqueIdentifier];
	if ([udid length] == 40)
		return udid;
	return [NSString stringWithFormat:@"sim:%@", udid];
}

@end

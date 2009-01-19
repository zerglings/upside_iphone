//
//  ActivationState.m
//  upside
//
//  Created by Victor Costan on 1/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ActivationState.h"

#import "Device.h"

@implementation ActivationState

# pragma mark I/O

// Key for the activated property.
NSString* kDeviceInfo = @"deviceInfo";

NSString* kStateFileName = @".ActivationState";

- (NSData*)archiveToData {
	if (!deviceInfo)
		return nil;
	
	NSMutableData* stateData = [NSMutableData data];
	NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]
								 initForWritingWithMutableData:stateData];
	[archiver encodeObject:[deviceInfo attributeDictionaryForcingStrings:YES]
					forKey:kDeviceInfo];
	[archiver finishEncoding];
	[archiver release];
	
	return stateData;
}

- (void)unarchiveFromData: (NSData*)data {
	[deviceInfo release];
	
	if (!data) {
		deviceInfo = nil;
		return;
	}
	
	NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]
									 initForReadingWithData:data];
	NSDictionary* deviceProperties = [unarchiver
									  decodeObjectForKey:kDeviceInfo];
	deviceInfo = [[Device alloc] initWithProperties:deviceProperties];
	[unarchiver release];
}

+ (NSString*)filePath {
	NSArray* docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
															NSUserDomainMask,
															YES);
	return [[docPaths objectAtIndex:0]
			stringByAppendingPathComponent:kStateFileName];
}

- (void) load {
	NSData* data = [NSData dataWithContentsOfFile:[ActivationState filePath]];
	[self unarchiveFromData:data];
}

- (void) save {
	NSData* data = [self archiveToData];
	if (!data) {
		[[NSFileManager defaultManager]
		 removeItemAtPath:[ActivationState filePath] error:nil];
	}
	else {
		[data writeToFile:[ActivationState filePath] atomically:YES];
	}
}

+ (void) removeSavedState {
	[[NSFileManager defaultManager] removeItemAtPath:[ActivationState filePath]
											   error:nil];
}

# pragma mark Lifecycle

- (id) init {
	if ((self = [super init])) {
		[self load];
	}
	return self;
}

- (void) dealloc {
	[deviceInfo release];
	[super dealloc];
}

@synthesize deviceInfo;

- (BOOL) isActivated {
	return deviceInfo != nil;
}

- (void) activateWithInfo: (Device*) theDeviceInfo {
	[theDeviceInfo retain];
	[deviceInfo release];
	deviceInfo = theDeviceInfo;
}

#pragma mark Singleton

static ActivationState* sharedState = nil;

+ (ActivationState*) sharedState {
	@synchronized(self) {
		if (sharedState == nil) {
			sharedState = [[ActivationState alloc] init];
		}
	}
	return sharedState;
}

@end

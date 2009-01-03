//
//  ActivationState.m
//  upside
//
//  Created by Victor Costan on 1/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ActivationState.h"


@implementation ActivationState

# pragma mark I/O

// Key for the activated property.
NSString* kActivated = @"activated";

NSString* kStateFileName = @".ActivationState";

- (NSData*)archiveToData {
	NSMutableData* stateData = [NSMutableData data];
	NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]
								 initForWritingWithMutableData:stateData];
	[archiver encodeBool:activated forKey:kActivated];
	[archiver finishEncoding];
	[archiver release];
	
	return stateData;
}

- (void)unarchiveFromData: (NSData*)data {
	NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]
									 initForReadingWithData:data];
	activated = [unarchiver decodeBoolForKey:kActivated];
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
	if (data) {
		[self unarchiveFromData:data];
	}
	else {
		activated = NO;
	}
}

- (void) save {
	NSData* data = [self archiveToData];
	[data writeToFile:[ActivationState filePath] atomically:YES];
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
	[super dealloc];
}

@synthesize activated;

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

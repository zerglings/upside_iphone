//
//  NetworkProgress.m
//  upside
//
//  Created by Victor Costan on 1/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NetworkProgress.h"


@implementation NetworkProgress

#pragma mark Connection Accounting

- (void) connectionStarted {
	@synchronized (self) {
		if (workingConnections == 0) {
			app.networkActivityIndicatorVisible = YES;
		}
		workingConnections++;
	}
}

- (void) connectionDone {
	@synchronized (self) {
		workingConnections--;
		if (workingConnections == 0) {
			app.networkActivityIndicatorVisible = NO;
		}
	}
}

#pragma mark Lifecycle

- (id) init {
	if ((self = [super init])) {
		app = [[UIApplication sharedApplication] retain];
	}
	return self;
}

- (void) dealloc {
	[app release];
	[super dealloc];
}

#pragma mark Singleton
static NetworkProgress* sharedInstance = nil;

+ (NetworkProgress*) sharedInstance {
	@synchronized ([NetworkProgress class]) {
		if (sharedInstance == nil)
			sharedInstance = [[NetworkProgress alloc] init];
	}
	return sharedInstance;
}

+ (void) connectionStarted {
	return [[self sharedInstance] connectionStarted];
}
+ (void) connectionDone {
	return [[self sharedInstance] connectionDone];
}

@end

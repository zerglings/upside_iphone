//
//  NetworkProgress.h
//  upside
//
//  Created by Victor Costan on 1/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NetworkProgress : NSObject {
	UIApplication* app;
	NSUInteger workingConnections;
}

// Called when a new network connection starts.
+ (void) connectionStarted;
// Called when a network connection has done its work.
+ (void) connectionDone;

// The singleton NetworkProgress instance.
+ (NetworkProgress*) sharedInstance;

// Called when a new network connection starts.
- (void) connectionStarted;
// Called when a network connection has done its work.
- (void) connectionDone;

@end

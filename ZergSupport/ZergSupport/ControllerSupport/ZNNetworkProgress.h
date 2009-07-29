//
//  ZNNetworkProgress.h
//  ZergSupport
//
//  Created by Victor Costan on 1/11/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

@class UIApplication;


// Manages the network progress indicator (spinning wheel on the status bar).
//
// Communication controllers should announce when they start and finish issuing
// network requests by calling +connectionStarted and +connectionDone. The
// methods are thread-safe.
@interface ZNNetworkProgress : NSObject {
  UIApplication* app;
  NSUInteger workingConnections;
}

// Called when a new network connection starts.
+(void)connectionStarted;
// Called when a network connection has done its work.
+(void)connectionDone;

// The singleton NetworkProgress instance.
+(ZNNetworkProgress*)sharedInstance;

// Called when a new network connection starts.
-(void)connectionStarted;
// Called when a network connection has done its work.
-(void)connectionDone;
@end

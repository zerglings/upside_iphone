//
//  ActivationState.h
//  upside
//
//  Created by Victor Costan on 1/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Device;

@interface ActivationState : NSObject {
	Device* deviceInfo;
}

@property (nonatomic, readonly, retain) Device* deviceInfo;

// Activate the device with the given data from the server.
- (void) activateWithInfo: (Device*)deviceFromServer;

// YES if the device is activated, NO if it needs to be activated.
- (BOOL) isActivated;

# pragma mark Singleton

// The singleton ActivationState instance.
+ (ActivationState*) sharedState;

#pragma mark I/O

// Archives state into an NSData instance.
- (NSData*) archiveToData;

// Restores previously archived state from an NSData instance.
- (void) unarchiveFromData: (NSData*)data;

// Saves state on disk.
- (void) save;

// Loads state from disk.
- (void) load;

// Removes the state saved on disk. Intended for testing.
+ (void) removeSavedState;

@end

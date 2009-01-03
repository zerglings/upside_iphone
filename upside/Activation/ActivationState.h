//
//  ActivationState.h
//  upside
//
//  Created by Victor Costan on 1/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ActivationState : NSObject {
	BOOL activated;
}

# pragma mark Singleton

// The singleton ActivationState instance.
+ (ActivationState*) sharedState;

#pragma mark Properties

@property (nonatomic) BOOL activated;

#pragma mark I/O

// Archives state into an NSData instance.
- (NSData*) archiveToData;

// Restores previously archived state from an NSData instance.
- (void) unarchiveFromData: (NSData*)data;

// Saves state on disk.
- (void) save;

// Loads state from disk.
- (void) load;

@end

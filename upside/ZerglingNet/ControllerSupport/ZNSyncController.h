//
//  ZNSyncController.h
//  upside
//
//  Created by Victor Costan on 1/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZNModel;

// Generic superclass for controllers that synchronize some cached data with a
// server periodically, using a communication controller.
@interface ZNSyncController : NSObject {
  Class errorModelClass;
  NSTimeInterval syncInterval;

 @private
  BOOL needsSyncScheduling;
  BOOL paused;
  BOOL stopped;
}

@property (nonatomic) NSTimeInterval syncInterval;

// Designated initializer.
- (id) initWithErrorModelClass: (Class)errorModelClass
                  syncInterval: (NSTimeInterval)syncInterval;

// Called by cache clients to start the periodic syncing.
- (void) startSyncing;

// Called by cache clients to stop the periodic syncing.
- (void) stopSyncing;

// Called by cache clients to force a one-time sync.
- (void) syncOnce;

// Subclasses should configure their communication controllers to invoke this
// method to report results.
- (void) receivedResults: (NSObject*)results;

// Subclasses should override this method to issue a communication request.
- (void) sync;

// Subclasses should override this method to update the cache. Implementations
// can return NO to indicate an error has occured, and periodic syncing should
// stop. In that case, implementations must call -resumeSyncing to resume
// periodic syncing once the error is handled.
- (BOOL) integrateResults: (NSArray*)results;

// Subclasses can override this method to handle an error returned by the
// service. The return value has the same semantics as for the
// -integrateResults: method.
- (BOOL) handleServiceError: (ZNModel*)error;

// Subclasses should override this method to handle a system error.
- (void) handleSystemError: (NSError*)error;

// Called by subclasses to resume periodic syncing stopped when
// -integrateResults: returns false.
- (void) resumeSyncing;

@end

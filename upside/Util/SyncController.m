//
//  SyncController.m
//  upside
//
//  Created by Victor Costan on 1/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <objc/runtime.h>

#import "SyncController.h"

@interface SyncController ()
- (void) doScheduledSync;
- (BOOL) processResults: (NSObject*)results;
@end


@implementation SyncController

@synthesize syncInterval;

- (id) initWithErrorModelClass: (Class)theErrorModelClass
                  syncInterval: (NSTimeInterval)theSyncInterval {
  if ((self = [super init])) {
    errorModelClass = theErrorModelClass;
    syncInterval = theSyncInterval;
    needsSyncScheduling = NO;
    paused = NO;
    stopped = NO;
  }
  return self;
}

- (void) dealloc {
  [super dealloc];
}

- (void) startSyncing {
  stopped = NO;
  [self doScheduledSync];
}

- (void) stopSyncing {
  stopped = YES;
  paused = NO;
}

- (void) resumeSyncing {
  paused = NO;
  [self sync];
}

- (void) doScheduledSync {
  if (paused || stopped)
    return;
  
  needsSyncScheduling = YES;
  [self sync];
}

- (void) syncOnce {
  if (paused || stopped)
    return;
  [self sync];
}

- (BOOL) processResults: (NSObject*)results {
  if (![results isKindOfClass:[NSArray class]]) {
    // communication error -- try again later
    NSError* error = [results isKindOfClass:[NSError class]] ?
        (NSError*)results : nil;
    [self handleSystemError:error];
    return YES;
  }
  if ([(NSArray*)results count] == 1) {
    // check for service error
    ZNModel* maybeError = [(NSArray*)results objectAtIndex:0];
    if ([maybeError isKindOfClass:errorModelClass])
      return [self handleServiceError:(ZNModel*)maybeError];
  }
  return [self integrateResults:(NSArray*)results];
}

- (void) receivedResults: (NSObject*)results {
  if ([self processResults:results]) {
    if (!paused && !stopped && needsSyncScheduling) {
      needsSyncScheduling = NO;
      [self performSelector:@selector(doScheduledSync)
                 withObject:nil
                 afterDelay:syncInterval];
    }
  }
  else
    paused = YES;
}


#pragma mark Subclass Methods.

- (void) sync {
  NSAssert1(NO, @"CacheController %s did not implement -integrateResults:",
            class_getName([self class]));  
}

- (BOOL) integrateResults: (NSArray*)results {
  NSAssert1(NO, @"CacheController %s did not implement -integrateResults:",
            class_getName([self class]));  
  return YES;
}
- (BOOL) handleServiceError: (ZNModel*)error {
  // by default assume service errors are temporary in nature
  return YES;
}
- (void) handleSystemError: (NSError*)error {
  return;
}

@end

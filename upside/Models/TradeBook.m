//
//  TradeBook.m
//  upside
//
//  Created by Victor Costan on 1/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TradeBook.h"

#import "TradeOrder.h"

@implementation TradeBook

#pragma mark I/O

- (void) load {
	// TODO(overmind): real I/O
}

- (void) save {
	// TODO(overmind): real I/O
}

#pragma mark Synchronizing

- (void) loadData: (NSArray*)newTradeOrders {
  NSMutableArray* theFilledOrders = [[NSMutableArray alloc] init];
  NSMutableArray* theSubmittedOrders = [[NSMutableArray alloc] init];
  
  for (TradeOrder* order in newTradeOrders) {
    if ([order isFilled])
      [theFilledOrders addObject:order];
    else
      [theSubmittedOrders addObject:order];
  }
  
  [filledOrders release];
  filledOrders = [[NSArray alloc] initWithArray:theFilledOrders];
  [theFilledOrders release];
  [submittedOrders release];
  submittedOrders = [[NSArray alloc] initWithArray:theSubmittedOrders];
  [theSubmittedOrders release];
}

#pragma mark Lifecycle

- (id) init {
	if ((self = [super init])) {
		[self load];
    pendingOrders = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void) dealloc {
	[filledOrders release];
  [submittedOrders release];
  [pendingOrders release];
	[super dealloc];
}

#pragma mark Properties

- (NSUInteger) filledCount {
  return [filledOrders count];
}

- (NSUInteger) submittedCount {
  return [submittedOrders count];
}

- (NSUInteger) pendingCount {
  return [pendingOrders count];
}

- (TradeOrder*) filledAtIndex: (NSUInteger)index {
  return [filledOrders objectAtIndex:index];
}

- (TradeOrder*) submittedAtIndex: (NSUInteger)index {
  return [submittedOrders objectAtIndex:index];
}

- (TradeOrder*) pendingAtIndex: (NSUInteger)index {
  return [pendingOrders objectAtIndex:index];
}

#pragma mark Order Submission Queue

- (void) queuePendingOrder: (TradeOrder*)order {
  [pendingOrders addObject:order];
}

- (TradeOrder*) firstPendingOrder {
  TradeOrder* firstOrder = [pendingOrders objectAtIndex:0];
  [pendingOrders removeObjectAtIndex:0];
  return firstOrder;
}

- (BOOL) dequeuePendingOrder: (TradeOrder*)order {
  NSUInteger orderIndex = [pendingOrders indexOfObject:order];
  if (orderIndex == NSNotFound)
    return NO;
  [pendingOrders removeObjectAtIndex:orderIndex];
  return YES;
}

- (NSArray*) copyPendingOrders {
  return [[NSArray alloc] initWithArray:pendingOrders];
}

@end

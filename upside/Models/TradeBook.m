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
  [tradeOrders release];
  tradeOrders = [newTradeOrders retain];
}

#pragma mark Lifecycle

- (id) init {
	if ((self = [super init])) {
		[self load];
	}
	return self;
}

- (void) dealloc {
	[tradeOrders release];
	[super dealloc];
}

#pragma mark Properties

- (NSUInteger) count {
	return [tradeOrders count];
}

- (TradeOrder*) orderAtIndex: (NSUInteger)index {
	return [tradeOrders objectAtIndex:index];
}

@end

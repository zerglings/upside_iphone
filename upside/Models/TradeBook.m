//
//  TradeBook.m
//  upside
//
//  Created by Victor Costan on 1/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TradeBook.h"

#import "TradeOrder.h"

@interface TradeBook ()

- (void) loadMockData;

@end


@implementation TradeBook

#pragma mark I/O

- (void) load {
	[self loadMockData];
}

- (void) save {
}

#pragma mark Testing

- (void) loadMockData {
	NSArray* mockOrders =
	    [NSArray arrayWithObjects:
		 [[[TradeOrder alloc] initWithTicker:@"AAPL"
									quantity:150
							  quantityFilled:0
								  isBuyOrder:YES
									serverId:kTradeOrderInvalidServerId]
		  autorelease],
		 [[[TradeOrder alloc] initWithTicker:@"GOOG"
									quantity:10000
							  quantityFilled:3500
								  isBuyOrder:NO
								  limitCents:29505
									serverId:332]
		  autorelease],
		 [[[TradeOrder alloc] initWithTicker:@"MSFT"
									quantity:32
							  quantityFilled:32
								  isBuyOrder:NO
								  limitCents:2300
									serverId:kTradeOrderInvalidServerId]
		  autorelease],
		 nil];
	
	tradeOrders = [mockOrders retain];
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

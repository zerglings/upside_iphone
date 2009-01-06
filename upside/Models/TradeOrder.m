//
//  MarketOrder.m
//  upside
//
//  Created by Victor Costan on 1/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TradeOrder.h"


@implementation TradeOrder

- (NSString*) ticker {
	return [props objectForKey:kTradeOrderTicker];
}

- (NSUInteger) quantity {
	return [[props objectForKey:kTradeOrderQuantity] unsignedIntValue];
}

- (BOOL) isBuyOrder {
	return [[props objectForKey:kTradeOrderIsBuyOrder] unsignedIntValue];
}

- (BOOL) isLimitOrder {
	return [[props objectForKey:kTradeOrderIsLimitOrder] unsignedIntValue];
}

- (NSUInteger) limitCents {
	return [[props objectForKey:kTradeOrderLimitCents] unsignedIntValue];
}

- (double) limitPrice {
	return [self limitCents] / 100.0;
}

- (NSUInteger) serverId {
	return [[props objectForKey:kTradeOrderServerId] unsignedIntValue];
}

- (BOOL) isSubmitted {
	return ([self serverId] != kTradeOrderInvalidServerId);
}

#pragma mark Convenience Constructors

- (TradeOrder*) initWithTicker:(NSString*)ticker
					  quantity:(NSUInteger)quantity
					isBuyOrder:(BOOL)isBuyOrder
					limitCents:(NSUInteger)limitCents
					  serverId:(NSUInteger)serverId {
	NSDictionary* properties = 
	    [[[NSDictionary alloc] initWithObjectsAndKeys:
		  ticker, kTradeOrderTicker,
		  [NSNumber numberWithUnsignedInt:limitCents],
		  kTradeOrderLimitCents,
		  [NSNumber numberWithUnsignedInt:quantity],
		  kTradeOrderQuantity,
		  [NSNumber numberWithBool:isBuyOrder], kTradeOrderIsBuyOrder,
		  [NSNumber numberWithBool:YES], kTradeOrderIsLimitOrder,
		  [NSNumber numberWithUnsignedInt:serverId],
		  kTradeOrderServerId,
		  nil] autorelease];
	return [super initWithProperties:properties];
}

// Convenience constructor for market orders.
- (TradeOrder*) initWithTicker:(NSString*)ticker
					  quantity:(NSUInteger)quantity
					isBuyOrder:(BOOL)isBuyOrder
					  serverId:(NSUInteger)serverId {
	NSDictionary* properties = 
	[[[NSDictionary alloc] initWithObjectsAndKeys:
	  ticker, kTradeOrderTicker,
	  [NSNumber numberWithUnsignedInt:kTradeOrderInvalidLimit],
	  kTradeOrderLimitCents,
	  [NSNumber numberWithUnsignedInt:quantity],
	  kTradeOrderQuantity,
	  [NSNumber numberWithBool:isBuyOrder], kTradeOrderIsBuyOrder,
	  [NSNumber numberWithBool:NO], kTradeOrderIsLimitOrder,
	  [NSNumber numberWithUnsignedInt:serverId],
	  kTradeOrderServerId,
	  nil] autorelease];
	return [super initWithProperties:properties];
}

@end

#pragma mark Order Properties Keys

const NSString* kTradeOrderTicker = @"ticker";
const NSString* kTradeOrderQuantity = @"quantity";
const NSString* kTradeOrderIsBuyOrder = @"is_buy";
const NSString* kTradeOrderIsLimitOrder = @"is_limit";
const NSString* kTradeOrderLimitCents = @"limit_cents";
const NSString* kTradeOrderServerId = @"id";
const NSUInteger kTradeOrderInvalidServerId = 0;
const NSUInteger kTradeOrderInvalidLimit = 0;

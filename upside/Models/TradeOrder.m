//
//  MarketOrder.m
//  upside
//
//  Created by Victor Costan on 1/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TradeOrder.h"


@implementation TradeOrder

- (void) dealloc {
	[ticker release];	
	[super dealloc];
}

@synthesize ticker, quantity, quantityFilled, isBuyOrder, limitCents, serverId;

- (double) fillRatio {
	return (double)[self quantityFilled] / [self quantity];
}

- (double) limitPrice {
	return limitCents / 100.0;
}

- (BOOL) isLimitOrder {
	return (limitCents != kTradeOrderInvalidLimit);
}

- (BOOL) isSubmitted {
	return (serverId != kTradeOrderInvalidServerId);
}

#pragma mark Convenience Constructors

- (TradeOrder*) initWithTicker:(NSString*)theTicker
					  quantity:(NSUInteger)theQuantity
				quantityFilled:(NSUInteger)theQuantityFilled
					isBuyOrder:(BOOL)theIsBuyOrder
					limitCents:(NSUInteger)theLimitCents
					  serverId:(NSUInteger)theServerId {
	if ((self = [self initWithProperties:nil])) {
		ticker = [theTicker retain];
		quantity = theQuantity;
		quantityFilled = theQuantityFilled;
		isBuyOrder = theIsBuyOrder;
		limitCents = theLimitCents;
		serverId = theServerId;
	}
	return self;	
}

- (TradeOrder*) initWithTicker:(NSString*)theTicker
					  quantity:(NSUInteger)theQuantity
				quantityFilled:(NSUInteger)theQuantityFilled
					isBuyOrder:(BOOL)theIsBuyOrder
					  serverId:(NSUInteger)theServerId {
	if ((self = [self initWithProperties:nil])) {
		ticker = [theTicker retain];
		quantity = theQuantity;
		quantityFilled = theQuantityFilled;
		isBuyOrder = theIsBuyOrder;
		limitCents = kTradeOrderInvalidLimit;
		serverId = theServerId;
	}
	return self;	
}

@end

#pragma mark Order Properties Keys

const NSUInteger kTradeOrderInvalidServerId = 0;
const NSUInteger kTradeOrderInvalidLimit = 0;

//
//  MarketOrder.h
//  upside
//
//  Created by Victor Costan on 1/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ModelSupport.h"

@interface TradeOrder : ZNModel {
	NSString* ticker;
	NSUInteger quantity;
	NSUInteger quantityFilled;
	BOOL isBuyOrder;
	NSUInteger limitCents;
	NSUInteger serverId;
}

// The ticker of the stock. 
@property (nonatomic, readonly, retain) NSString* ticker;

// The number of stocks in the order.
@property (nonatomic, readonly) NSUInteger quantity;

// The number of stocks in the order.
@property (nonatomic, readonly) NSUInteger quantityFilled;

// YES for buy orders, NO for sell orders.
@property (nonatomic, readonly) BOOL isBuyOrder;

// The limit on the order, in cents.
@property (nonatomic, readonly) NSUInteger limitCents;

// The ID assigned by the server when the order is submitted. 
@property (nonatomic, readonly)  NSUInteger serverId;

#pragma mark Convenience Constructors

// Convenience constructor for limit orders.
- (TradeOrder*) initWithTicker:(NSString*)ticker
					  quantity:(NSUInteger)quantity
				quantityFilled:(NSUInteger)quantityFilled
					isBuyOrder:(BOOL)isBuyOrder
					limitCents:(NSUInteger)limitCents
					  serverId:(NSUInteger)serverId;

// Convenience constructor for market orders.
- (TradeOrder*) initWithTicker:(NSString*)ticker
					  quantity:(NSUInteger)quantity
				quantityFilled:(NSUInteger)quantityFilled
					isBuyOrder:(BOOL)isBuyOrder
					  serverId:(NSUInteger)serverId;

#pragma mark Conveience Accessors

// The ratio of filled to ordered stocks in this order.
- (double) fillRatio;

// The limit on the order, in dollars.
- (double) limitPrice;

// YES for limit orders, NO for market orders. 
- (BOOL) isLimitOrder;

// YES for submitted orders, NO for orders pending submission.
- (BOOL) isSubmitted;

@end

#pragma mark Special Values

// The value of serverId for orders that are not on the server yet.
const NSUInteger kTradeOrderInvalidServerId;

// The value of limitCents for market orders.
const NSUInteger kTradeOrderInvalidLimit;

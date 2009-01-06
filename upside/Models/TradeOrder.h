//
//  MarketOrder.h
//  upside
//
//  Created by Victor Costan on 1/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DictionaryBackedModel.h"

@interface TradeOrder : DictionaryBackedModel {
}

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

#pragma mark Accessors

// The ticker of the stock. 
- (NSString*) ticker;

// The number of stocks in the order.
- (NSUInteger) quantity;

// The number of stocks in the order.
- (NSUInteger) quantityFilled;

// The ratio of filled to ordered stocks in this order.
- (double) fillRatio;

// YES for buy orders, NO for sell orders.
- (BOOL) isBuyOrder;

// YES for limit orders, NO for market orders. 
- (BOOL) isLimitOrder;

// The limit on the order, in cents.
- (NSUInteger) limitCents;

// The limit on the order, in dollars.
- (double) limitPrice;

// The ID assigned by the server when the order is submitted. 
- (NSUInteger) serverId;

// YES for submitted orders, NO for orders pending submission.
- (BOOL) isSubmitted;

@end

#pragma mark Order Properties Keys

// An NSString with the stock's ticker, e.g. @"AAPL".
const NSString* kTradeOrderTicker;

// An NSNumber with the amount of stocks to be traded. 
const NSString* kTradeOrderQuantity;

// An NSNumber storing a boolean YES for buy orders or a NO for sell orders. 
const NSString* kTradeOrderIsBuyOrder;

// An NSNumber storing a boolean YES for limit orders or a NO for market orders. 
const NSString* kTradeOrderIsLimitOrder;

// An NSNumber with the price limit, in cents, for limit orders, or
// kTradeOrderInvalidLimit for market orders.
const NSString* kTradeOrderLimitCents;

// An NSNumber with the server-assigned order id, or kTradeOrderInvalidLimit for
// unsubmitted orders.
const NSString* kTradeOrderServerId;

// An NSNumber with the amount of stocks that were filled in this order.
const NSString* kTradeOrderQuantityFilled;

// The value returned by -serverId for orders that are not on the server yet.
const NSUInteger kTradeOrderInvalidServerId;

// The value returned by -limitCents for market orders.
const NSUInteger kTradeOrderInvalidLimit;

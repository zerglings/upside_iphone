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
	BOOL isBuy;
  BOOL isLong;
  BOOL isLimit;
  double limitPrice;
	NSUInteger modelId;
	NSUInteger quantityUnfilled;
}

// The ticker of the stock. 
@property (nonatomic, readonly, retain) NSString* ticker;

// The number of stocks in the order.
@property (nonatomic, readonly) NSUInteger quantity;

// YES for buy orders, NO for sell orders.
@property (nonatomic, readonly) BOOL isBuy;

// YES for long (buy, sell) orders, NO for short (or buy to cover) orders.
@property (nonatomic, readonly) BOOL isLong;

// The limit on the order, in cents.
@property (nonatomic, readonly) double limitPrice;

// The ID assigned by the server when the order is submitted.
@property (nonatomic, readonly)  NSUInteger modelId;

// The number of stocks in the order that are not yet filled.
@property (nonatomic, readonly) NSUInteger quantityUnfilled;

#pragma mark Convenience Initializers

// Convenience initializer for limit orders.
- (TradeOrder*) initWithTicker:(NSString*)ticker
                      quantity:(NSUInteger)quantity
              quantityUnfilled:(NSUInteger)quantityUnfilled
                         isBuy:(BOOL)isBuy
                        isLong:(BOOL)isLong
                    limitPrice:(double)limitPrice
                       modelId:(NSUInteger)modelId;

// Convenience initializer for market orders.
- (TradeOrder*) initWithTicker:(NSString*)ticker
                      quantity:(NSUInteger)quantity
              quantityUnfilled:(NSUInteger)quantityUnfilled
                         isBuy:(BOOL)isBuy
                        isLong:(BOOL)isLong
                       modelId:(NSUInteger)modelId;

// Convenience initializer for new orders.
- (TradeOrder*) initWithTicker:(NSString*)ticker
                      quantity:(NSUInteger)quantity
                         isBuy:(BOOL)isBuy
                        isLong:(BOOL)isLong
                    limitPrice:(double)limitPrice;

#pragma mark Conveience Accessors

// The numebr of unfilled stocks in this order.
- (NSUInteger) quantityFilled;

// The ratio of filled to ordered stocks in this order.
- (double) fillRatio;

// The limit on the order, in dollars.
- (double) limitPrice;

// YES for limit orders, NO for market orders. 
- (BOOL) isLimitOrder;

// YES for submitted orders, NO for orders pending submission.
- (BOOL) isSubmitted;

// YES for filled orders, NO for orders that have not been filled.
- (BOOL) isFilled;

@end

#pragma mark Special Values

// The value of modelId for orders that are not on the server yet.
const NSUInteger kTradeOrderInvalidModelId;

// The value of limitCents for market orders.
const double kTradeOrderInvalidLimit;

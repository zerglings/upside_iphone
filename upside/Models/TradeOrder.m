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

@synthesize ticker, quantity, quantityUnfilled, isBuy, isLong, limitPrice;
@synthesize modelId;

- (NSUInteger) quantityFilled {
  return quantity - quantityUnfilled;
}

- (double) fillRatio {
	return (double)[self quantityFilled] / quantity;
}

- (BOOL) isLimitOrder {
	return (limitPrice != kTradeOrderInvalidLimit);
}

- (BOOL) isSubmitted {
	return (modelId != kTradeOrderInvalidModelId);
}

#pragma mark Convenience Constructors

- (TradeOrder*) initWithTicker:(NSString*)theTicker
                      quantity:(NSUInteger)theQuantity
              quantityUnfilled:(NSUInteger)theQuantityUnfilled
                         isBuy:(BOOL)theIsBuy
                        isLong:(BOOL)theIsLong
                    limitPrice:(double)theLimitPrice
                       modelId:(NSUInteger)theModelId {
  NSNumber* quantityNum = [[NSNumber alloc] initWithUnsignedInteger:
                           theQuantity];
  NSNumber* quantityUnfilledNum = [[NSNumber alloc] initWithUnsignedInteger:
                                   theQuantityUnfilled];
  NSNumber* isBuyNum = [[NSNumber alloc] initWithBool:theIsBuy];
  NSNumber* isLongNum = [[NSNumber alloc] initWithBool:theIsLong];
  NSNumber* limitPriceNum = [[NSNumber alloc] initWithDouble:theLimitPrice];
  NSNumber* modelIdNum = [[NSNumber alloc] initWithUnsignedInteger:theModelId];
  NSDictionary* properties = [[NSDictionary alloc] initWithObjectsAndKeys:
                              theTicker, @"ticker",
                              quantityNum, @"quantity",
                              quantityUnfilledNum, @"quantityUnfilled",
                              isBuyNum, @"isBuy",
                              isLongNum, @"isLong",
                              limitPriceNum, @"limitPrice",
                              modelIdNum, @"modelId", nil];
  [quantityNum release];
  [quantityUnfilledNum release];
  [isBuyNum release];
  [isLongNum release];
  [limitPriceNum release];
  [modelIdNum release];
  
	self = [self initWithModel:nil properties:properties];
  [properties release];
  return self;
}

- (TradeOrder*) initWithTicker:(NSString*)theTicker
                      quantity:(NSUInteger)theQuantity
              quantityUnfilled:(NSUInteger)theQuantityUnfilled
                         isBuy:(BOOL)theIsBuy
                        isLong:(BOOL)theIsLong
                       modelId:(NSUInteger)theModelId {
  return [self initWithTicker:theTicker
                     quantity:theQuantity
             quantityUnfilled:theQuantityUnfilled
                        isBuy:theIsBuy
                       isLong:theIsLong
                   limitPrice:kTradeOrderInvalidLimit
                      modelId:theModelId];
}

@end

#pragma mark Order Properties Keys

const NSUInteger kTradeOrderInvalidModelId = 0;
const double kTradeOrderInvalidLimit = 0.0;

//
//  MarketOrder.m
//  StockPlay
//
//  Created by Victor Costan on 1/4/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "TradeOrder.h"


@implementation TradeOrder

-(void)dealloc {
	[ticker release];	
	[super dealloc];
}

@synthesize ticker, quantity, unfilledQuantity, isBuy, isLong, limitPrice;
@synthesize modelId;

-(NSUInteger)filledQuantity {
  return quantity - unfilledQuantity;
}

-(double)fillRatio {
	return (double)[self filledQuantity] / quantity;
}

-(BOOL)isLimitOrder {
	return (limitPrice != kTradeOrderInvalidLimit);
}

-(BOOL)isSubmitted {
	return (modelId != kTradeOrderInvalidModelId);
}

-(BOOL)isFilled {
  return (unfilledQuantity == 0);
}


#pragma mark Convenience Constructors

-(TradeOrder*)initWithTicker:(NSString*)theTicker
                      quantity:(NSUInteger)theQuantity
              unfilledQuantity:(NSUInteger)theUnfilledQuantity
                         isBuy:(BOOL)theIsBuy
                        isLong:(BOOL)theIsLong
                    limitPrice:(double)theLimitPrice
                       modelId:(NSUInteger)theModelId {
  NSNumber* quantityNum = [[NSNumber alloc] initWithUnsignedInteger:
                           theQuantity];
  NSNumber* unfilledQuantityNum = [[NSNumber alloc] initWithUnsignedInteger:
                                   theUnfilledQuantity];
  NSNumber* isBuyNum = [[NSNumber alloc] initWithBool:theIsBuy];
  NSNumber* isLongNum = [[NSNumber alloc] initWithBool:theIsLong];
  NSNumber* limitPriceNum = [[NSNumber alloc] initWithDouble:theLimitPrice];
  NSNumber* modelIdNum = [[NSNumber alloc] initWithUnsignedInteger:theModelId];
  NSDictionary* properties = [[NSDictionary alloc] initWithObjectsAndKeys:
                              theTicker, @"ticker",
                              quantityNum, @"quantity",
                              unfilledQuantityNum, @"unfilledQuantity",
                              isBuyNum, @"isBuy",
                              isLongNum, @"isLong",
                              limitPriceNum, @"limitPrice",
                              modelIdNum, @"modelId", nil];
  [quantityNum release];
  [unfilledQuantityNum release];
  [isBuyNum release];
  [isLongNum release];
  [limitPriceNum release];
  [modelIdNum release];
  
	self = [self initWithModel:nil properties:properties];
  [properties release];
  return self;
}

-(TradeOrder*)initWithTicker:(NSString*)theTicker
                      quantity:(NSUInteger)theQuantity
              unfilledQuantity:(NSUInteger)theUnfilledQuantity
                         isBuy:(BOOL)theIsBuy
                        isLong:(BOOL)theIsLong
                       modelId:(NSUInteger)theModelId {
  return [self initWithTicker:theTicker
                     quantity:theQuantity
             unfilledQuantity:theUnfilledQuantity
                        isBuy:theIsBuy
                       isLong:theIsLong
                   limitPrice:kTradeOrderInvalidLimit
                      modelId:theModelId];
}

-(TradeOrder*)initWithTicker:(NSString*)theTicker
                      quantity:(NSUInteger)theQuantity
                         isBuy:(BOOL)theIsBuy
                        isLong:(BOOL)theIsLong
                    limitPrice:(double)theLimitPrice {
  return [self initWithTicker:theTicker
                     quantity:theQuantity
             unfilledQuantity:0
                        isBuy:theIsBuy
                       isLong:theIsLong
                   limitPrice:theLimitPrice
                      modelId:kTradeOrderInvalidModelId];
}

@end

#pragma mark Order Properties Keys

const NSUInteger kTradeOrderInvalidModelId = 0;
const double kTradeOrderInvalidLimit = 0.0;

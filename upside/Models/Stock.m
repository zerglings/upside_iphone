//
//  Stock.m
//  StockPlay
//
//  Created by Victor Costan on 1/4/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "Stock.h"

@implementation Stock

@synthesize ticker, name, market, askPrice, bidPrice;
@synthesize lastTradePrice, previousClosePrice;


-(void)dealloc {
	[ticker release];
	[name release];

	[super dealloc];
}

#pragma mark Convenience Initializers

-(id)initWithTicker:(NSString*)theTicker
                 name:(NSString*)theName
               market:(NSString*)theMarket
             askPrice:(double)theAskPrice
             bidPrice:(double)theBidPrice
       lastTradePrice:(double)theLastTradePrice
   previousClosePrice:(double)thePreviousClosePrice {
	return [self initWithModel:nil properties:
          [NSDictionary dictionaryWithObjectsAndKeys:
           theTicker, @"ticker",
           theName, @"name",
           theMarket, @"market",
           [NSNumber numberWithDouble:theAskPrice], @"askPrice",
           [NSNumber numberWithDouble:theBidPrice], @"bidPrice",
           [NSNumber numberWithDouble:theLastTradePrice], @"lastTradePrice",
           [NSNumber numberWithDouble:thePreviousClosePrice],
           @"previousClosePrice", nil]];
}

-(BOOL)isValid {
  return [market isEqualToString:@"N/A"] ? NO : YES;
}

@end

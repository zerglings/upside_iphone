//
//  Stock.m
//  upside
//
//  Created by Victor Costan on 1/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Stock.h"

@implementation Stock

@synthesize ticker, name, askPrice, bidPrice;
@synthesize lastTradePrice, previousClosePrice;


- (void) dealloc {
	[ticker release];
	[name release];

	[super dealloc];
}

#pragma mark Convenience Initializers

- (id) initWithTicker: (NSString*)theTicker
				 name: (NSString*)theName
			 askPrice: (double)theAskPrice
			 bidPrice: (double)theBidPrice
	   lastTradePrice: (double)theLastTradePrice
   previousClosePrice: (double)thePreviousClosePrice {
	return [self initWithModel:nil properties:
			[NSDictionary dictionaryWithObjectsAndKeys:
			 theTicker, @"ticker",
			 theName, @"name",
			 [NSNumber numberWithDouble:theAskPrice], @"askPrice",
			 [NSNumber numberWithDouble:theBidPrice], @"bidPrice",
			 [NSNumber numberWithDouble:theLastTradePrice], @"lastTradePrice",
			 [NSNumber numberWithDouble:thePreviousClosePrice],
			 @"previousClosePrice", nil]];
}

@end

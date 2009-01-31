//
//  Position.m
//  StockPlay
//
//  Created by Victor Costan on 1/22/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "Position.h"


@implementation Position

-(id)initWithTicker: (NSString*)theTicker
			 quantity: (NSUInteger)theQuantity
			   isLong: (BOOL)theIsLong {
	return [self initWithModel:nil properties:
			[NSDictionary dictionaryWithObjectsAndKeys:
			 theTicker, @"ticker",
			 [NSNumber numberWithUnsignedInteger:theQuantity], @"quantity",
			 [NSNumber numberWithBool:theIsLong], @"isLong", nil]];
}

@synthesize ticker, quantity, isLong;

-(void)dealloc {
	[ticker release];
	[super dealloc];
}

-(NSComparisonResult)compare: (Position*)other {
	NSComparisonResult tickerCompare = [ticker localizedCompare:[other ticker]];
	if (tickerCompare != NSOrderedSame)
		return tickerCompare;
	
	return ([other isLong] - isLong);
}

@end

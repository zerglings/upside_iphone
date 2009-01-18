//
//  Stock.m
//  upside
//
//  Created by Victor Costan on 1/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Stock.h"

@implementation Stock

@synthesize ticker, name, askCents, bidCents, lastAskCents, lastBidCents;

- (void) dealloc {
	[ticker release];
	[name release];

	[super dealloc];
}

#pragma mark Accessors

- (double)askPrice {
	return askCents / 100.0;
}
- (double)bidPrice {
	return bidCents / 100.0;
}

#pragma mark Convenience Initializers

- (id) initWithTicker: (NSString*)theTicker
				 name: (NSString*)theName
			 askCents: (NSUInteger)theAskCents
			 bidCents: (NSUInteger)theBidCents
		 lastAskCents: (NSUInteger)theLastAskCents
		 lastBidCents: (NSUInteger)theLastBidCents {
	if ((self = [self initWithProperties:nil])) {
		ticker = theTicker;
		name = theName;
		askCents = theAskCents;
		bidCents = theBidCents;
		lastAskCents = theLastAskCents;
		lastBidCents = theLastBidCents;
	}
	return self;
}

@end

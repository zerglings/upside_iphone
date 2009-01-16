//
//  StockCache.m
//  upside
//
//  Created by Victor Costan on 1/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StockCache.h"

#import "Stock.h"

@interface StockCache ()

- (void) loadMockData;

@end


@implementation StockCache

#pragma mark I/O

- (void) load {
	[self loadMockData];
}

- (void) save {
}

#pragma mark Testing

- (void) loadMockData {
	NSDictionary* mockStocks = [NSDictionary dictionaryWithObjectsAndKeys:
								[[[Stock alloc] initWithTicker:@"AAPL"
														  name:@"Apple Inc"
													  askCents:9100
													  bidCents:9050
												  lastAskCents:9050
												  lastBidCents:9030]
								 autorelease],
								@"AAPL",
								[[[Stock alloc] initWithTicker:@"GOOG"
														  name:@"Google Inc"
													  askCents:30000
													  bidCents:29800
												  lastAskCents:30100
												  lastBidCents:29900]
								 autorelease],
								@"GOOG",
								[[[Stock alloc] initWithTicker:@"MSFT"
														  name:@"Microsoft Inc"
													  askCents:2100
													  bidCents:1995
												  lastAskCents:2150
												  lastBidCents:1950]
								 autorelease],
								@"MSFT",
								nil];
	
	stocks = [mockStocks retain];
}

#pragma mark Lifecycle

- (id)init {
	if ((self = [super init])) {
		[self load];
	}
	return self;
}

- (void)dealloc {
	[stocks release];
	[super dealloc];
}

#pragma mark Cache Access

- (Stock*)stockForTicker:(NSString*)stockTicker {
	return [stocks objectForKey:stockTicker];
}

@end

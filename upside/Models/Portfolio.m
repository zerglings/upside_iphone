//
//  Portfolio.m
//  Upside
//
//  Created by Victor Costan on 1/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Portfolio.h"


@implementation Portfolio

#pragma mark I/O

- (void) load {
	[self loadMockData];
}

- (void) save {
}

#pragma mark Testing

- (void) loadMockData {
	NSArray* mockStockTickers = [NSArray arrayWithObjects:@"AAPL", @"GOOG",
								 @"MSFT", nil];
	
	NSDictionary* mockStocks = [NSDictionary dictionaryWithObjectsAndKeys:
								[[Stock alloc] initWithProperties:
								 [NSDictionary dictionaryWithObjectsAndKeys:
								 @"Apple Inc", kStockName,
								 @"AAPL", kStockTicker,
								 [NSNumber numberWithInt:10000], kStockHeld,
								 [NSNumber numberWithInt:9100], kStockAskCents,
								 [NSNumber numberWithInt:9050], kStockBidCents,
								 [NSNumber numberWithInt:9050], kStockLastAskCents,
								 [NSNumber numberWithInt:9030], kStockLastBidCents,
								 nil]],
								@"AAPL",
								[[Stock alloc] initWithProperties:
								 [NSDictionary dictionaryWithObjectsAndKeys:
								 @"Google Inc", kStockName,
								 @"GOOG", kStockTicker,
								 [NSNumber numberWithInt:31415], kStockHeld,
								 [NSNumber numberWithInt:30000], kStockAskCents,
								 [NSNumber numberWithInt:29800], kStockBidCents,
								 [NSNumber numberWithInt:30100], kStockLastAskCents,
								 [NSNumber numberWithInt:29900], kStockLastBidCents,
								 nil]],
								@"GOOG",
								[[Stock alloc] initWithProperties:
								 [NSDictionary dictionaryWithObjectsAndKeys:
								 @"Microsoft Corp", kStockName,
								 @"MSFT", kStockTicker,
								 [NSNumber numberWithInt:666], kStockHeld,
								 [NSNumber numberWithInt:2100], kStockAskCents,
								 [NSNumber numberWithInt:1995], kStockBidCents,
								 [NSNumber numberWithInt:2150], kStockLastAskCents,
								 [NSNumber numberWithInt:1950], kStockLastBidCents,
								 nil]],
								@"MSFT",
								nil];
	
	stockTickers = [mockStockTickers retain];
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
	[stockTickers release];
	[super dealloc];
}

#pragma mark Properties

- (NSUInteger)count {
	return [stockTickers count];
}

- (NSString*)stockTickerAtIndex:(NSUInteger)index {
	return [stockTickers objectAtIndex:index];
}

- (Stock*)stockWithTicker:(NSString*)stockTicker {
	return [stocks objectForKey:stockTicker];
}

#pragma mark Singleton

static Portfolio* sharedPortfolio = nil;

+ (Portfolio*) sharedPortfolio {
	@synchronized(self) {
		if (sharedPortfolio == nil) {
			sharedPortfolio = [[Portfolio alloc] init];
		}
	}
	return sharedPortfolio;
}

@end

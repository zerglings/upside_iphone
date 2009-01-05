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
	NSArray* mockStockIds = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],
							 [NSNumber numberWithInt:2],
							 [NSNumber numberWithInt:3],
							 nil];
	
	
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
								[NSNumber numberWithInt:1],
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
								[NSNumber numberWithInt:2],
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
								[NSNumber numberWithInt:3],
								nil];
	
	stockIds = [mockStockIds retain];
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
	[stockIds release];
	[super dealloc];
}

#pragma mark Properties

- (NSUInteger)count {
	return [stockIds count];
}

- (NSUInteger)stockIdAtIndex:(NSUInteger)index {
	return [[stockIds objectAtIndex:index] unsignedIntValue];
}

- (Stock*)stockWithStockId:(NSUInteger)stockId {
	return [stocks objectForKey:[NSNumber numberWithUnsignedInt:stockId]];
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

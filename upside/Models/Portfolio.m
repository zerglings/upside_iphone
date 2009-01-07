//
//  Portfolio.m
//  Upside
//
//  Created by Victor Costan on 1/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Portfolio.h"

@interface Portfolio ()
- (void) loadMockData;
@end

@implementation Portfolio

#pragma mark I/O

- (void) load {
	[self loadMockData];
}

- (void) save {
}

#pragma mark Testing

- (void) loadData: (NSDictionary*)newStocksHeld {
	[newStocksHeld retain];
	[stockHeld release];
	stockHeld = newStocksHeld;
	
	[stockTickers release];
	stockTickers = [[[stockHeld allKeys] sortedArrayUsingSelector:
					 @selector(localizedCompare:)] retain];
}

- (void) loadMockData {
	[self loadData:[NSDictionary dictionaryWithObjectsAndKeys:
					[NSNumber numberWithUnsignedInt:10000],
					@"AAPL",
					[NSNumber numberWithUnsignedInt:31415],
					@"GOOG",
					[NSNumber numberWithUnsignedInt:666],
					@"MSFT",
					nil]];
}

#pragma mark Lifecycle

- (id)init {
	if ((self = [super init])) {
		[self load];
	}
	return self;
}

- (void)dealloc {
	[stockTickers release];
	[stockHeld release];
	[super dealloc];
}

#pragma mark Properties

- (NSUInteger)count {
	return [stockTickers count];
}

- (NSString*)stockTickerAtIndex:(NSUInteger)index {
	return [stockTickers objectAtIndex:index];
}

- (NSUInteger)stockOwnedForTicker: (NSString*)stockTicker {
	return [[stockHeld objectForKey:stockTicker] unsignedIntValue];
}

@end

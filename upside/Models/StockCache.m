//
//  StockCache.m
//  upside
//
//  Created by Victor Costan on 1/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StockCache.h"

#import "Stock.h"
#import "StockInfoCommController.h"

@interface StockCache ()
- (void) startUpdating;
@end


@implementation StockCache

#pragma mark I/O

- (void) load {
	// TODO(overmind): code this up
}

- (void) save {
	// TODO(overmind): code this up
}

#pragma mark Lifecycle

- (id)init {
	if ((self = [super init])) {
		stocks = [[NSMutableDictionary alloc] init];
		commController = [[StockInfoCommController alloc]
						  initWithTarget:self action:@selector(mergeStocks:)];
		refreshPeriod = 60.0;
	}
	return self;
}

- (void)dealloc {
	[stocks release];
	[super dealloc];
}

#pragma mark Update Cycle

- (void) update {
	[commController fetchInfoForTickers:[stocks allKeys]];
}

- (void) mergeStocks: (NSArray*)newStocks {
	if (![newStocks isKindOfClass:[NSError class]]) {
		for (Stock* stock in newStocks) {
			// TODO(overmind): merge new model info with what was there before
			[stocks setObject:stock forKey:[stock ticker]];
		}
	}
	
	[self performSelector:@selector(update)
			   withObject:nil
			   afterDelay:refreshPeriod];
}

- (void) startUpdating {
	[self update];
}

#pragma mark Cache Access

- (Stock*)stockForTicker:(NSString*)stockTicker {
	Stock* stockInfo = [stocks objectForKey:stockTicker];
	if (stockInfo) {
		if ([stockInfo isKindOfClass:[NSNull class]])
			return nil;
		else
			return stockInfo;
	}
	
	// We don't have stock information, so let's queue it up.
	[stocks setObject:[NSNull null] forKey:stockTicker];
	return nil;
}

@end

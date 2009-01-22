//
//  Portfolio+StockCache.m
//  upside
//
//  Created by Victor Costan on 1/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Portfolio+StockCache.h"

#import "StockCache.h"

@implementation Portfolio (StockCache)

- (void) loadTickersIntoStockCache: (StockCache*)stockCache {
	for (NSString* ticker in stockTickers) {
		[stockCache stockForTicker:ticker];
	}
}

@end

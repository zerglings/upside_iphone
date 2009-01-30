//
//  AssetBook+StockCache.h
//  upside
//
//  Created by Victor Costan on 1/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AssetBook.h"

@class StockCache;

@interface AssetBook (StockCache)

- (void) loadTickersIntoStockCache: (StockCache*)stockCache;
@end

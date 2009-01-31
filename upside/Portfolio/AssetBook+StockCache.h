//
//  AssetBook+StockCache.h
//  StockPlay
//
//  Created by Victor Costan on 1/22/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "AssetBook.h"

@class StockCache;

@interface AssetBook (StockCache)

-(void)loadTickersIntoStockCache: (StockCache*)stockCache;
@end

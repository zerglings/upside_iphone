//
//  AssetBook+StockCache.m
//  StockPlay
//
//  Created by Victor Costan on 1/22/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "AssetBook+StockCache.h"

#import "Position.h"
#import "StockCache.h"

@implementation AssetBook (StockCache)

-(void)loadTickersIntoStockCache: (StockCache*)stockCache {
  BOOL needsSync = NO;
	for (Position* position in positions) {
		if(![stockCache stockForTicker:[position ticker]])
      needsSync = YES;
	}
  if (needsSync)
    [stockCache syncOnce];
}

@end

//
//  AssetBook+NetWorth.m
//  StockPlay
//
//  Created by Victor Costan on 2/4/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "AssetBook+NetWorth.h"

#import "Portfolio.h"
#import "Position.h"
#import "Stock.h"
#import "StockCache.h"


@implementation AssetBook (NetWorth)

-(double)stockWorth: (BOOL*)succeeded usingStockCache:(StockCache*)stockCache {
  double stockWorth = 0;
  if (succeeded)
    *succeeded = YES;
  for (Position* position in positions) {
    Stock* stockInfo = [stockCache stockForTicker:[position ticker]];
    if (!stockInfo && succeeded)
      *succeeded = NO;
    double contribution = [stockInfo lastTradePrice] * [position quantity];
    if ([position isLong])
      stockWorth += contribution;
    else
      stockWorth -= contribution;
  }
  return stockWorth;
}

-(double)netWorth: (BOOL*)succeeded usingStockCache:(StockCache*)stockCache {
  return [self stockWorth: succeeded usingStockCache:stockCache] +
      [portfolio cash];
}

@end

//
//  AssetBook+NetWorth.h
//  StockPlay
//
//  Created by Victor Costan on 2/4/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AssetBook.h"

@class PortfolioStat;
@class StockCache;

@interface AssetBook (NetWorth)

// The net worth of all the player's stocks.
-(double)stockWorth:(BOOL*)succeeded usingStockCache:(StockCache*)stockCache;

// The net worth of all the player's assets.
-(double)netWorth:(BOOL*)succeeded usingStockCache:(StockCache*)stockCache;

@end

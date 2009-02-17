//
//  AssetBook+NetWorth.h
//  StockPlay
//
//  Created by Victor Costan on 2/4/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AssetBook.h"

@class StockCache;

@interface AssetBook (NetWorth)

-(double)stockWorth: (BOOL*)succeeded usingStockCache:(StockCache*)stockCache;

-(double)netWorth: (BOOL*)succeeded usingStockCache:(StockCache*)stockCache;

@end

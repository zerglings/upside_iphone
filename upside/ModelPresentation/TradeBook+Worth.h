//
//  TradeBook+Worth.h
//  StockPlay
//
//  Created by Victor Costan on 2/17/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TradeBook.h"


@class StockCache;

@interface TradeBook (Worth)

// The expected proceeds from the currently placed orders.
-(double)orderProceeds:(BOOL*)succeeded usingStockCache:(StockCache*)stockCache;

@end

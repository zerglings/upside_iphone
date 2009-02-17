//
//  TradeBook+Formatting.h
//  StockPlay
//
//  Created by Victor Costan on 2/17/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "TradeBook.h"


@class StockCache;

// Presentation aspect for overall orders.
@interface TradeBook (Formatting)

// Format the expected proceeds from orders.
-(NSString*)formattedOrderProceedsWithCache:(StockCache*)stockCache;

@end

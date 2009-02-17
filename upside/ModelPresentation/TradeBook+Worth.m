//
//  TradeBook+Worth.m
//  StockPlay
//
//  Created by Victor Costan on 2/17/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "TradeBook+Worth.h"

#import "Stock.h"
#import "StockCache.h"
#import "TradeOrder.h"

@implementation TradeBook (Worth)

-(double)orderProceeds:(BOOL*)succeeded
       usingStockCache:(StockCache*)stockCache {
  double proceeds = 0;
  if (succeeded)
    *succeeded = YES;
  NSArray* orderArrays[2] = {submittedOrders, pendingOrders};
  for (size_t i = 0; i < sizeof(orderArrays) / sizeof(*orderArrays); i++) {
    for (TradeOrder* order in orderArrays[i]) {
      Stock* stockInfo = [stockCache stockForTicker:[order ticker]];
      if (!stockInfo && succeeded)
        *succeeded = NO;
      double contribution =
          [stockInfo lastTradePrice] * [order unfilledQuantity];
      if ([order isBuy])
        proceeds -= contribution;
      else
        proceeds += contribution;
    }    
  }
  return proceeds;  
}

@end

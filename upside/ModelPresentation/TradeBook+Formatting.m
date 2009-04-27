//
//  TradeBook+Formatting.m
//  StockPlay
//
//  Created by Victor Costan on 2/17/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "TradeBook+Formatting.h"

#import "TradeBook+Worth.h"

static NSNumberFormatter* worthFormatter = nil;

static void SetupFormatters() {
  @synchronized([TradeBook class]) {
    if (worthFormatter == nil) {
      worthFormatter = [[NSNumberFormatter alloc] init];
      [worthFormatter setPositiveFormat:@"$#,##0.00"];
      [worthFormatter setNegativeFormat:@"$-#,##0.00"];
    }
  }
}

@implementation TradeBook (Formatting)

-(NSString*)formattedOrderProceedsWithCache:(StockCache*)stockCache {
  SetupFormatters();

  BOOL proceedsSucceeded;
  double proceeds = [self orderProceeds:&proceedsSucceeded
                        usingStockCache:stockCache];
  if (proceedsSucceeded)
    return [worthFormatter stringFromNumber:[NSNumber
                                             numberWithDouble:proceeds]];
  else
    return @"N/A";
}

@end

//
//  AssetBook+Formatting.m
//  StockPlay
//
//  Created by Victor Costan on 2/16/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "AssetBook+Formatting.h"

#import "AssetBook+NetWorth.h"
#import "Portfolio+Formatting.h"
#import "PortfolioStat.h"

static NSNumberFormatter* worthFormatter = nil;

static void SetupFormatters() {
  @synchronized([AssetBook class]) {
    if (worthFormatter == nil) {
      worthFormatter = [[NSNumberFormatter alloc] init];
      [worthFormatter setPositiveFormat:@"$#,##0.00"];
      [worthFormatter setNegativeFormat:@"$-#,##0.00"];
    }
  }
}

@implementation AssetBook (Formatting)

-(NSString*)formattedCash {
  return [portfolio formattedCash];
}

-(UIColor*)colorForCash;  {
  return [portfolio colorForCash];
}

-(NSString*)formattedWorth:(double)worth succeeded:(BOOL)succeeded {
  SetupFormatters();
  if (succeeded)
    return [worthFormatter stringFromNumber:[NSNumber numberWithDouble:worth]];
  else
    return @"N/A";
}

-(NSString*)formattedStockWorthWithCache:(StockCache*)stockCache {
  BOOL worthSucceeded;
  double netWorth = [self stockWorth:&worthSucceeded
                     usingStockCache:stockCache];
  return [self formattedWorth:netWorth succeeded:worthSucceeded];
}

-(NSString*)formattedNetWorthWithCache:(StockCache*)stockCache {
  BOOL worthSucceeded;
  double stockWorth = [self netWorth:&worthSucceeded
                     usingStockCache:stockCache];
  return [self formattedWorth:stockWorth succeeded:worthSucceeded];
}

-(UIImage*)imageForNetWorthChangeFrom:(PortfolioStat*)stat
                           stockCache:(StockCache*)stockCache {
  BOOL succeeded;
  double netWorth = [self netWorth:&succeeded usingStockCache:stockCache];
  if (!succeeded || !stat) {
    return nil;
  }
  double oldNetWorth = [stat netWorth];
  if (oldNetWorth < netWorth) {
    return [UIImage imageNamed:@"GreenUpArrow.png"];
  }
  else if (oldNetWorth > netWorth) {
    return [UIImage imageNamed:@"RedDownArrow.png"];
  }
  return nil;
}

@end

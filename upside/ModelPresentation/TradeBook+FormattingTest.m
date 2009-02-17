//
//  TradeBook+FormattingTest.m
//  StockPlay
//
//  Created by Victor Costan on 2/17/09.
//  Copyright Zergling.Net. All rights reserved.
//


#import "TestSupport.h"

#import "StockCache.h"
#import "TradeBook+Formatting.h"


@interface TradeBookFormattingTest : SenTestCase {
  TradeBook* cachedBook;
  TradeBook* uncachedBook;
  StockCache* stockCache;
}
@end

@implementation TradeBookFormattingTest

-(void)setUp {
  stockCache = [[StockCache alloc] init];
  [stockCache integrateResults:[self fixturesFrom:@"AssetBookStocks.xml"]];
  
  uncachedBook = [[TradeBook alloc] init];
  [uncachedBook loadData:[self fixturesFrom:@"TradeBookOrders.xml"]];
  cachedBook = [[TradeBook alloc] init];
  [cachedBook loadData:
   [[self fixturesFrom:@"TradeBookOrders.xml"]
    objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:
                      NSMakeRange(1, 2)]]];
}
-(void)tearDown {
  [stockCache release];
  [cachedBook release];
  [uncachedBook release];
}
-(void)dealloc {
  [super dealloc];
}

-(void)testKnownWorthFormatting {
  // Computed values stolen from TradeBook+WorthTest.m
  STAssertEqualStrings(@"$-840,546.25",
                       [cachedBook formattedOrderProceedsWithCache:stockCache],
                       @"Known order proceeds");
}

-(void)testUnknownWorthFormatting {
  STAssertEqualStrings(@"N/A",
                       [uncachedBook formattedOrderProceedsWithCache:stockCache],
                       @"Unknown order proceeds");
} 

@end

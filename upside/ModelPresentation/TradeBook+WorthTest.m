//
//  TradeBook+WorthTest.m
//  StockPlay
//
//  Created by Victor Costan on 2/17/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "TestSupport.h"

#import "StockCache.h"
#import "TradeBook+Worth.h"
#import "TradeOrder.h"

@interface TradeBookWorthTest : SenTestCase {
  StockCache* stockCache;
  TradeBook* cachedBook;
  TradeBook* uncachedBook;
}
@end

@implementation TradeBookWorthTest

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

-(void)testComputations {  
  double proceeds = [cachedBook orderProceeds:NULL usingStockCache:stockCache];
  // - 9000 * 93.50 + 35 * 27.25 = -840546.25
  STAssertEqualsWithAccuracy(-840546.25, proceeds, 0.001,
                             @"Order proceeds with full information");
}

-(void)testSuccess {
  BOOL success;
  [cachedBook orderProceeds:&success usingStockCache:stockCache];
  STAssertTrue(success, @"Order proceeds with full information");
  [uncachedBook orderProceeds:&success usingStockCache:stockCache];
  STAssertFalse(success, @"Order proceeds with incomplete information");
}

@end

//
//  AssetBook+NetWorthTest.m
//  StockPlay
//
//  Created by Victor Costan on 2/4/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "TestSupport.h"

#import "AssetBook+NetWorth.h"
#import "Portfolio.h"
#import "Position.h"
#import "Stock.h"
#import "StockCache.h"

@interface AssetBookNetWorthTest : SenTestCase {
  StockCache* stockCache;
  AssetBook* cachedBook;
  AssetBook* uncachedBook;
}

@end



@implementation AssetBookNetWorthTest 

-(void)setUp {
  stockCache = [[StockCache alloc] init];
  [stockCache integrateResults:[self fixturesFrom:@"AssetBookStocks.xml"]];

  cachedBook = [[AssetBook alloc] init];
  [cachedBook loadData:
   [[self fixturesFrom:@"AssetBookPortfolio.xml"]
    objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 3)]]];
  uncachedBook = [[AssetBook alloc] init];
  [uncachedBook loadData:[self fixturesFrom:@"AssetBookPortfolio.xml"]];   
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
  double stockWorth = [cachedBook stockWorth:NULL usingStockCache:stockCache];
  // 35 * 93.50 - 21 * 27.25 = 2700.25
  STAssertEqualsWithAccuracy(2700.25, stockWorth, 0.001,
                             @"Stock worth with full information");
  double netWorth = [cachedBook netWorth:NULL usingStockCache:stockCache];
  // 35 * 93.50 - 21 * 27.25 + 730.51 = 3430.76
  STAssertEqualsWithAccuracy(3430.76, netWorth, 0.001,
                             @"Net worth with full information");
}

-(void)testSuccess {
  BOOL success;
  [cachedBook stockWorth:&success usingStockCache:stockCache];
  STAssertTrue(success, @"Stock worth with full information");
  [cachedBook netWorth:&success usingStockCache:stockCache];
  STAssertTrue(success, @"Net worth with full information");
  [uncachedBook stockWorth:&success usingStockCache:stockCache];
  STAssertFalse(success, @"Stock worth with incomplete information");
  [uncachedBook netWorth:&success usingStockCache:stockCache];
  STAssertFalse(success, @"Net worth with incomplete information");
}

@end

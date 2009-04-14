//
//  AssetBook+FormattingTest.m
//  StockPlay
//
//  Created by Victor Costan on 2/16/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "TestSupport.h"

#import "AssetBook+Formatting.h"
#import "StockCache.h"

@interface AssetBookFormattingTest : SenTestCase {
  AssetBook* cachedBook;
  AssetBook* uncachedBook;
  StockCache* stockCache;
  PortfolioStat* dailyStat;
  PortfolioStat* hourlyStat;
}
@end


@implementation AssetBookFormattingTest

-(void)setUp {
  stockCache = [[StockCache alloc] init];
  [stockCache integrateResults:[self fixturesFrom:@"AssetBookStocks.xml"]];
  
  cachedBook = [[AssetBook alloc] init];
  [cachedBook loadData:
   [[self fixturesFrom:@"AssetBookPortfolio.xml"]
    objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 5)]]];
  uncachedBook = [[AssetBook alloc] init];
  [uncachedBook loadData:[self fixturesFrom:@"AssetBookPortfolio.xml"]];  
  
  dailyStat = [cachedBook dailyStat];
  hourlyStat = [cachedBook hourlyStat];  
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
  // Computed values stolen from AssetBook+NetWorthTest.m
  STAssertEqualStrings(@"$2,700.25",
                       [cachedBook formattedStockWorthWithCache:stockCache],
                       @"Easy stock worth");
  STAssertEqualStrings(@"$3,430.76",
                       [cachedBook formattedNetWorthWithCache:stockCache],
                       @"Easy net worth");
}

-(void)testUnknownWorthFormatting {
  STAssertEqualStrings(@"N/A",
                       [uncachedBook formattedStockWorthWithCache:stockCache],
                       @"Unknown stock worth");
  STAssertEqualStrings(@"N/A",
                       [uncachedBook formattedNetWorthWithCache:stockCache],
                       @"Unknown net worth");  
} 

-(void)testNetworthChangeImages {
  UIImage* downArrow = [UIImage imageNamed:@"RedDownArrow.png"];
  UIImage* upArrow = [UIImage imageNamed:@"GreenUpArrow.png"];
  STAssertEquals(upArrow, [cachedBook imageForNetWorthChangeFrom:dailyStat
                                                      stockCache:stockCache],
                 @"Net worth rise should be depicted with an up arrow");
  STAssertEquals(downArrow, [cachedBook imageForNetWorthChangeFrom:hourlyStat
                                                        stockCache:stockCache],
                 @"Net worth drop should be depicted with a down arrow");
  STAssertNil([uncachedBook imageForNetWorthChangeFrom:hourlyStat
                                            stockCache:stockCache],
              @"Net worth change with incomplete information");
}

@end

//
//  AssetBook+FormattingTest.m
//  upside
//
//  Created by Victor Costan on 2/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TestSupport.h"

#import "AssetBook+Formatting.h"
#import "StockCache.h"

@interface AssetBookFormattingTest : SenTestCase {
  AssetBook* cachedBook;
  AssetBook* uncachedBook;
  StockCache* stockCache;
}
@end


@implementation AssetBookFormattingTest

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

@end

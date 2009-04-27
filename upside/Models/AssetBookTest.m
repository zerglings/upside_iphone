//
//  AsserBookTest.m
//  StockPlay
//
//  Created by Victor Costan on 1/7/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "TestSupport.h"

#import "AssetBook.h"
#import "Position.h"
#import "Portfolio.h"

@interface AsserBookTest : SenTestCase {
  AssetBook* assetBook;
  Portfolio* portfolio;
  Position* aaplLong;
  Position* cShort;
  Position* eneShort;
  Position* googLong;
  Position* msftShort;
}

@end

@implementation AsserBookTest

-(void)setUp {
  assetBook = [[AssetBook alloc] init];
  [assetBook loadData:[self fixturesFrom:@"AssetBookTest.xml"]];
}

-(void)tearDown {
  [assetBook release];
}

-(void)dealloc {
  [super dealloc];
}

-(void)testCounts {
  STAssertEquals(2U, [assetBook longPositionCount],
                 @"-longPositionCount called right after -loadData");
  STAssertEquals(3U, [assetBook shortPositionCount],
                 @"-shortPositionCount called right after -loadData");
}

-(void)testCash {
  STAssertEqualsWithAccuracy(31415.92, [assetBook cash], 0.001,
                             @"Cash in portfolio");
}

-(void)testTickersAreSortedAndFiltered {
  for (NSUInteger i = 0; i < [assetBook longPositionCount]; i++) {
    Position* position = [assetBook longPositionAtIndex:i];
    STAssertTrue([position isLong],
                 @"Long position %@ at %u isn't actually long",
                 [position ticker], i);
    if (i > 0) {
      Position* prevPosition = [assetBook longPositionAtIndex:(i - 1)];
      STAssertTrue([[position ticker] compare:[prevPosition ticker]] > 0,
                   @"Long positions %u and %u aren't sorted", i - 1, i);

    }
  }
  for (NSUInteger i = 0; i < [assetBook shortPositionCount]; i++) {
    Position* position = [assetBook shortPositionAtIndex:i];
    STAssertTrue(![position isLong],
                 @"Short position %@ at %u isn't actually short",
                 [position ticker], i);
    if (i > 0) {
      Position* prevPosition = [assetBook shortPositionAtIndex:(i - 1)];
      STAssertTrue([[position ticker] compare:[prevPosition ticker]] > 0,
                   @"Short positions %u and %u aren't sorted", i - 1, i);
    }
  }
}

-(void)testPositionForTicker {
  STAssertEqualStrings(@"GOOG",
                       [[assetBook longPositionWithTicker:@"GOOG"] ticker],
                       @"Searched for long GOOG");
  STAssertNil([assetBook longPositionWithTicker:@"MSFT"],
              @"Searched for long MSFT, but we're shorting it");
  STAssertNil([assetBook longPositionWithTicker:@"YYYY"],
              @"Searched for long position for invalid ticker");

  STAssertEqualStrings(@"C", [[assetBook shortPositionWithTicker:@"C"] ticker],
                       @"Searched for short C");
  STAssertNil([assetBook shortPositionWithTicker:@"GOOG"],
              @"Searched for short GOOG, but we have a long there");
  STAssertNil([assetBook shortPositionWithTicker:@"YYYY"],
              @"Searched for short position for invalid ticker");
}

@end

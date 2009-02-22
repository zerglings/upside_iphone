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
  portfolio = [[Portfolio alloc] initWithCash:31415.92];

	aaplLong = [[Position alloc] initWithTicker:@"AAPL"
                                     quantity:10000
                                       isLong:YES];
	cShort = [[Position alloc] initWithTicker:@"C"
                                   quantity:2009
                                     isLong:NO];
	eneShort = [[Position alloc] initWithTicker:@"ENE"
                                     quantity:141
                                       isLong:NO];
	googLong = [[Position alloc] initWithTicker:@"GOOG"
                                     quantity:31415
                                       isLong:YES];
	msftShort = [[Position alloc] initWithTicker:@"MSFT"
                                      quantity:666
                                        isLong:NO];
	
	assetBook = [[AssetBook alloc] init];
	[assetBook loadData:[NSArray arrayWithObjects: portfolio,
                       eneShort, googLong, msftShort, cShort, aaplLong, nil]];
}

-(void)tearDown {
  
  [aaplLong release];
  [cShort release];
  [eneShort release];
  [googLong release];
  [msftShort release];
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
  STAssertEquals(aaplLong, [assetBook longPositionAtIndex:0],
                 @"First long position");
  STAssertEquals(googLong, [assetBook longPositionAtIndex:1],
                 @"Second long position");
  STAssertEquals(cShort, [assetBook shortPositionAtIndex:0],
                 @"First short position");
  STAssertEquals(eneShort, [assetBook shortPositionAtIndex:1],
                 @"Second short position");
  STAssertEquals(msftShort, [assetBook shortPositionAtIndex:2],
                 @"Third short position");
}

-(void)testPositionForTicker {
  STAssertEquals(googLong, [assetBook longPositionWithTicker:@"GOOG"],
                 @"Searched for long GOOG");
  STAssertNil([assetBook longPositionWithTicker:@"MSFT"],
              @"Searched for long MSFT, but we're shorting it");
  STAssertNil([assetBook longPositionWithTicker:@"YYYY"],
              @"Searched for long position for invalid ticker");  

  STAssertEquals(cShort, [assetBook shortPositionWithTicker:@"C"],
                 @"Searched for short C");
  STAssertNil([assetBook shortPositionWithTicker:@"GOOG"],
              @"Searched for short GOOG, but we have a long there");
  STAssertNil([assetBook shortPositionWithTicker:@"YYYY"],
              @"Searched for short position for invalid ticker");  
}

@end

//
//  PortfolioTest.m
//  upside
//
//  Created by Victor Costan on 1/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TestSupport.h"

#import "Portfolio.h"

@interface PortfolioTest : SenTestCase {
	Portfolio* portfolio;
}

@end

@implementation PortfolioTest

- (void) setUp {
	portfolio = [[Portfolio alloc] init];
	[portfolio loadData:[NSDictionary dictionaryWithObjectsAndKeys:
						 [NSNumber numberWithUnsignedInt:666],
	   				     @"MSFT",
						 [NSNumber numberWithUnsignedInt:10000],
						 @"AAPL",
						 [NSNumber numberWithUnsignedInt:31415],
						 @"GOOG",
						 nil]];
}

- (void) tearDown {
	[portfolio release];
}

- (void) dealloc {
	[super dealloc];
}

- (void) testCount {
	STAssertEquals(3U, [portfolio count],
				   @"-count called right after -loadData");
}

- (void) testTickersAreSorted {
	NSString* goldenTickers[] = {@"AAPL", @"GOOG", @"MSFT"};
	
	for (size_t i = 0;
		 i < sizeof(goldenTickers) / sizeof(*goldenTickers);
		 i++) {
		STAssertEqualStrings(goldenTickers[i],
							 [portfolio stockTickerAtIndex:i],
							 @"Sorting failed at the %dth element", 1);
	}
}

- (void) testStockOwnedForAbsentStock {
	STAssertEquals(0U, [portfolio stockOwnedForTicker:@"NASDAQ"],
				   @"Called -stockOwnedForTicker on unowned stock");
}

- (void) testStockOwnedForPresentStock {
	STAssertEquals(666U, [portfolio stockOwnedForTicker:@"MSFT"],
				   @"Called -stockOwnedForTicker for MSFT");
	STAssertEquals(31415U, [portfolio stockOwnedForTicker:@"GOOG"],
				   @"Called -stockOwnedForTicker for GOOG");
}

@end

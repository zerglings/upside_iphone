//
//  PortfolioTest.m
//  upside
//
//  Created by Victor Costan on 1/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TestSupport.h"

#import "Portfolio.h"
#import "Position.h"

@interface PortfolioTest : SenTestCase {
	Portfolio* portfolio;
	Position* aaplLong;
	Position* cShort;
	Position* eneShort;
	Position* googLong;
	Position* msftShort;
}

@end

@implementation PortfolioTest

- (void) setUp {
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
	
	portfolio = [[Portfolio alloc] init];
	[portfolio loadData:[NSArray arrayWithObjects:
						 eneShort, googLong, msftShort, cShort, aaplLong, nil]];
}

- (void) tearDown {
	[aaplLong release];
	[cShort release];
	[eneShort release];
	[googLong release];
	[msftShort release];
	[portfolio release];
}

- (void) dealloc {
	[super dealloc];
}

- (void) testCounts {
	STAssertEquals(2U, [portfolio longPositionCount],
				   @"-longPositionCount called right after -loadData");
	STAssertEquals(3U, [portfolio shortPositionCount],
				   @"-shortPositionCount called right after -loadData");
}

- (void) testTickersAreSortedAndFiltered {
	STAssertEquals(aaplLong, [portfolio longPositionAtIndex:0],
				   @"First long position");
	STAssertEquals(googLong, [portfolio longPositionAtIndex:1],
				   @"Second long position");
	STAssertEquals(cShort, [portfolio shortPositionAtIndex:0],
				   @"First short position");
	STAssertEquals(eneShort, [portfolio shortPositionAtIndex:1],
				   @"Second short position");
	STAssertEquals(msftShort, [portfolio shortPositionAtIndex:2],
				   @"Third short position");
}

@end

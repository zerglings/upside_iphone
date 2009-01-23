//
//  Position+FormattingTest.m
//  upside
//
//  Created by Victor Costan on 1/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TestSupport.h"

#import "Position+Formatting.h"

@interface PortfolioFormattingTest : SenTestCase {
	Position* smallPosition;
	Position* largePosition;
}
@end

@implementation PortfolioFormattingTest

- (void) setUp {
	smallPosition = [[Position alloc] initWithTicker:@"MSFT"
											quantity:35
											  isLong:YES];
	largePosition = [[Position alloc] initWithTicker:@"AAPL"
											quantity:10000
											  isLong:YES];	
}

- (void) tearDown {
	[smallPosition release];
	[largePosition release];
}

- (void) dealloc {
	[super dealloc];
}

- (void) testQuantities {
	STAssertEqualStrings(@"35", [smallPosition formattedQuantity],
						 @"Easy quantity formatting");
	STAssertEqualStrings(@"10,000", [largePosition formattedQuantity],
						 @"Large quantity formatting");
}

@end

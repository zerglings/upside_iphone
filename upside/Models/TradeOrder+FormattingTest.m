//
//  TradeOrder+FormattingTest.m
//  upside
//
//  Created by Victor Costan on 1/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GTMSenTestCase.h"
#import "TradeOrder.h"
#import "TradeOrder+Formatting.h"

@interface TradeOrderFormattingTest : SenTestCase {
	TradeOrder* buyOrder;
	TradeOrder* sellOrder;
}
@end

@implementation TradeOrderFormattingTest

- (void) setUp {
	buyOrder = [[TradeOrder alloc] initWithTicker:@"AAPL"
										 quantity:1000
									   isBuyOrder:YES
									   limitCents:131050
										 serverId:kTradeOrderInvalidServerId];

	sellOrder = [[TradeOrder alloc] initWithTicker:@"MSFT"
										  quantity:35
										isBuyOrder:NO
										  serverId:6];
}

- (void) testQuantities {
	STAssertEqualStrings(@"35", [sellOrder formattedQuantity],
						 @"Easy quantity");
	STAssertEqualStrings(@"1,000", [buyOrder formattedQuantity],
						 @"Large quantity");
}

- (void) testLimits {
	STAssertEqualStrings(@"$1,310.50", [buyOrder formattedLimitPrice],
						 @"Large limit");
	STAssertEqualStrings(@"mkt", [sellOrder formattedLimitPrice],
						 @"Market order limit");
}

@end

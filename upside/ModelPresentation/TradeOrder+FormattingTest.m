//
//  TradeOrder+FormattingTest.m
//  StockPlay
//
//  Created by Victor Costan on 1/5/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "TestSupport.h"

#import "TradeOrder.h"
#import "TradeOrder+Formatting.h"

@interface TradeOrderFormattingTest : SenTestCase {
  TradeOrder* buyOrder;
  TradeOrder* sellOrder;
}
@end

@implementation TradeOrderFormattingTest

-(void)setUp {
  NSArray* orders = [self fixturesFrom:@"TradeBookOrders.xml"];
  buyOrder = [[orders objectAtIndex:1] retain];
  sellOrder = [[orders objectAtIndex:2] retain];
}

-(void)tearDown {
  [buyOrder release];
  [sellOrder release];
}

-(void)dealloc {
  [super dealloc];
}

-(void)testQuantities {
  STAssertEqualStrings(@"35", [sellOrder formattedQuantity],
                       @"Easy quantity");
  STAssertEqualStrings(@"10,000", [buyOrder formattedQuantity],
                       @"Large quantity");

  STAssertEqualStrings(@"0", [sellOrder formattedQuantityFilled],
                       @"Zero filled quantity");
  STAssertEqualStrings(@"1,000", [buyOrder formattedQuantityFilled],
                       @"Large filled quantity");
}

-(void)testFillPercentages {
  STAssertEqualStrings(@"10.00%", [buyOrder formattedPercentFilled],
                       @"Easy fill percent");
  STAssertEqualStrings(@"0.00%", [sellOrder formattedPercentFilled],
                       @"Zero fill percent");
}

-(void)testLimits {
  STAssertEqualStrings(@"$1,310.50", [buyOrder formattedLimitPrice],
                       @"Large limit");
  STAssertEqualStrings(@"mkt", [sellOrder formattedLimitPrice],
                       @"Market order limit");
}

@end

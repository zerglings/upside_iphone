//
//  StockFormatterTest.m
//  upside
//
//  Created by Victor Costan on 1/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GTMSenTestCase.h"
#import "Stock.h"
#import "Stock+Formatting.h"

@interface StockFormattingTest : SenTestCase {
	Stock* risingStock;
	Stock* fallingStock;
}

@end


@implementation StockFormattingTest

- (void) setUp {	
	risingStock = [[Stock alloc] initWithTicker:@"AAPL"
										   name:@"Apple Inc"
									   askCents:109100
									   bidCents:9050
								   lastAskCents:9000
								   lastBidCents:8500];
	
	fallingStock = [[Stock alloc] initWithTicker:@"MSFT"
											name:@"Microsoft Inc"
										askCents:90
										bidCents:9
									lastAskCents:281
									lastBidCents:11];
}

- (void) tearDown {
	[risingStock release];
	[fallingStock release];
}

- (void) dealloc {
	[super dealloc];
}

- (void) testPrices {
	STAssertEqualStrings(@"$90.50", [risingStock formattedBidPrice],
						 @"Easy price formatting");
	STAssertEqualStrings(@"$1,091.00", [risingStock formattedAskPrice],
						 @"Large price formatting");

	STAssertEqualStrings(@"$0.90", [fallingStock formattedAskPrice],
						 @"Small price formatting");
	STAssertEqualStrings(@"$0.09", [fallingStock formattedBidPrice],
						 @"Tiny price formatting");	
}

- (void) testNetChanges {
	STAssertEqualStrings(@"+5.50", [risingStock formattedNetBidChange],
						 @"Easy net change formatting");
	STAssertEqualStrings(@"+1,001.00", [risingStock formattedNetAskChange],
						 @"Large net change formatting");
	
	STAssertEqualStrings(@"-1.91", [fallingStock formattedNetAskChange],
						 @"Negative net change formatting");
	STAssertEqualStrings(@"-0.02", [fallingStock formattedNetBidChange],
						 @"Tiny net change formatting");	
}

- (void) testPointChanges {
	STAssertEqualStrings(@"+6.47%", [risingStock formattedPointBidChange],
						 @"Easy point change formatting");
	STAssertEqualStrings(@"+1,112.22%",
						 [risingStock formattedPointAskChange],
						 @"Large point change formatting");
	
	STAssertEqualStrings(@"-67.97%", [fallingStock formattedPointAskChange],
						 @"Negative point change formatting");
	STAssertEqualStrings(@"-18.18%", [fallingStock formattedPointBidChange],
						 @"Negative point change formatting");	
}

- (void) testChangeColors {
	STAssertEqualObjects([UIColor colorWithRed:0.5f green:0.0f
										  blue:0.0f alpha:1.0f],
						 [fallingStock colorForBidChange],
						 @"Falling stocks should be red");
	STAssertEqualObjects([UIColor colorWithRed:0.0f green:0.5f
										  blue:0.0f alpha:1.0f],
						 [risingStock colorForBidChange],
						 @"Rising stocks should be green");	
}

- (void) testChangeImages {
	STAssertEqualObjects([UIImage imageNamed:@"RedDownArrow.png"],
						 [fallingStock imageForBidChange],
						 @"Falling stocks should have a red down arrow");
	STAssertEqualObjects([UIImage imageNamed:@"RedDownArrow.png"],
						 [fallingStock imageForAskChange],
						 @"Falling stocks should have a red down arrow");
	STAssertEqualObjects([UIImage imageNamed:@"GreenUpArrow.png"],
						 [risingStock imageForBidChange],
						 @"Rising stocks should have a green up arrow");
	STAssertEqualObjects([UIImage imageNamed:@"GreenUpArrow.png"],
						 [risingStock imageForAskChange],
						 @"Rising stocks should have a green up arrow");
}

@end

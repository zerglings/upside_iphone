//
//  StockFormatterTest.m
//  StockPlay
//
//  Created by Victor Costan on 1/4/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "TestSupport.h"

#import "Stock.h"
#import "Stock+Formatting.h"

@interface StockFormattingTest : SenTestCase {
	Stock* risingStock;
	Stock* fallingStock;
  Stock* invalidStock;
}

@end


@implementation StockFormattingTest

-(void)setUp {	
	risingStock = [[Stock alloc] initWithTicker:@"AAPL"
                                         name:@"Apple Inc"
                                       market:@"NasdaqNM"
                                     askPrice:1091.50
                                     bidPrice:90.50
                               lastTradePrice:90.00
                           previousClosePrice:85.00];
	
	fallingStock = [[Stock alloc] initWithTicker:@"MSFT"
                                          name:@"Microsoft Corp"
                                        market:@"NasdaqNM"
                                      askPrice:0.90
                                      bidPrice:0.09
                                lastTradePrice:2.79
                            previousClosePrice:2.81];
  invalidStock = [[Stock alloc] initWithTicker:@"YYYY"
                                          name:@"YYYY"
                                        market:@"N/A"
                                      askPrice:0
                                      bidPrice:0
                                lastTradePrice:0
                            previousClosePrice:0];
}

-(void)tearDown {
	[risingStock release];
	[fallingStock release];
  [invalidStock release];
}

-(void)dealloc {
	[super dealloc];
}

-(void)testPrices {
	STAssertEqualStrings(@"$90.50", [risingStock formattedBidPrice],
                       @"Easy price formatting");
	STAssertEqualStrings(@"$1,091.50", [risingStock formattedAskPrice],
                       @"Large price formatting");
	STAssertEqualStrings(@"$90.00", [risingStock formattedTradePrice],
                       @"Integer price formatting");
  
	STAssertEqualStrings(@"$0.90", [fallingStock formattedAskPrice],
                       @"Small price formatting");
	STAssertEqualStrings(@"$0.09", [fallingStock formattedBidPrice],
                       @"Tiny price formatting");	
}

-(void)testNetChanges {
	STAssertEqualStrings(@"+5.50", [risingStock formattedNetBidChange],
                       @"Easy net change formatting");
	STAssertEqualStrings(@"+1,006.50", [risingStock formattedNetAskChange],
                       @"Large net change formatting");
	STAssertEqualStrings(@"+5.00", [risingStock formattedNetTradeChange],
                       @"Integer net change formatting");
	
	STAssertEqualStrings(@"-1.91", [fallingStock formattedNetAskChange],
                       @"Negative net change formatting");
	STAssertEqualStrings(@"-0.02", [fallingStock formattedNetTradeChange],
                       @"Tiny net change formatting");	
}

-(void)testPointChanges {
	STAssertEqualStrings(@"+6.47%", [risingStock formattedPointBidChange],
                       @"Easy point change formatting");
	STAssertEqualStrings(@"+1,184.12%",
                       [risingStock formattedPointAskChange],
                       @"Large point change formatting");
	
	STAssertEqualStrings(@"-67.97%", [fallingStock formattedPointAskChange],
                       @"Negative point change formatting");
	STAssertEqualStrings(@"-96.80%", [fallingStock formattedPointBidChange],
                       @"Negative point change formatting");	
	STAssertEqualStrings(@"-0.71%", [fallingStock formattedPointTradeChange],
                       @"Tiny negative point change formatting");	
}

-(void)testChangeColors {
	STAssertEqualObjects([UIColor colorWithRed:0.5f green:0.0f
                                        blue:0.0f alpha:1.0f],
                       [fallingStock colorForBidChange],
                       @"Falling stocks should be red");
	STAssertEqualObjects([UIColor colorWithRed:0.0f green:0.5f
                                        blue:0.0f alpha:1.0f],
                       [risingStock colorForBidChange],
                       @"Rising stocks should be green");	
}

-(void)testChangeImages {
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

-(void)testValidityImages {
	STAssertEqualObjects([UIImage imageNamed:@"GreenTick.png"],
                       [fallingStock imageForValidity],
                       @"Valid stocks should have a green tick");
	STAssertEqualObjects([UIImage imageNamed:@"RedX.png"],
                       [invalidStock imageForValidity],
                       @"Invalid stocks should have a red X");  
}

@end

//
//  StockFormatterTest.m
//  upside
//
//  Created by Victor Costan on 1/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GTMSenTestCase.h"
#import "StockFormatter.h"

@interface StockFormatterTest : SenTestCase {
	StockFormatter* formatter;
	Stock* risingStock;
	Stock* fallingStock;
}

@end


@implementation StockFormatterTest

- (void) setUp {
	formatter = [StockFormatter sharedFormatter];
	
	risingStock = [NSDictionary dictionaryWithObjectsAndKeys:
				   @"Apple Inc", kStockName,
				   @"AAPL", kStockTicker,
				   [NSNumber numberWithInt:10000], kStockHeld,
				   [NSNumber numberWithInt:109100], kStockAskCents,
				   [NSNumber numberWithInt:9050], kStockBidCents,
				   [NSNumber numberWithInt:9000], kStockLastAskCents,
				   [NSNumber numberWithInt:8500], kStockLastBidCents,
				   nil];

	fallingStock = [NSDictionary dictionaryWithObjectsAndKeys:
					@"Microsoft Corp", kStockName,
					@"MSFT", kStockTicker,
					[NSNumber numberWithInt:10000], kStockHeld,
					[NSNumber numberWithInt:90], kStockAskCents,
					[NSNumber numberWithInt:9], kStockBidCents,
					[NSNumber numberWithInt:281], kStockLastAskCents,
					[NSNumber numberWithInt:11], kStockLastBidCents,
					nil];
}

- (void) testPrices {
	STAssertEqualStrings(@"$90.50", [formatter bidPriceFor:risingStock],
						 @"Easy bidding price formatting");
	STAssertEqualStrings(@"$1,091.00", [formatter askPriceFor:risingStock],
						 @"Large asking price formatting");

	STAssertEqualStrings(@"$0.90", [formatter askPriceFor:fallingStock],
						 @"Small asking price formatting");
	STAssertEqualStrings(@"$0.09", [formatter bidPriceFor:fallingStock],
						 @"Tiny bidding price formatting");	
}

- (void) testNetChanges {
	STAssertEqualStrings(@"+5.50", [formatter netBidChangeFor:risingStock],
						 @"Easy net change formatting");
	STAssertEqualStrings(@"+1,001.00", [formatter netAskChangeFor:risingStock],
						 @"Large net change formatting");
	
	STAssertEqualStrings(@"-1.91", [formatter netAskChangeFor:fallingStock],
						 @"Negative net change formatting");
	STAssertEqualStrings(@"-0.02", [formatter netBidChangeFor:fallingStock],
						 @"Tiny net change formatting");	
}

- (void) testPointChanges {
	STAssertEqualStrings(@"+6.47%", [formatter pointBidChangeFor:risingStock],
						 @"Easy point change formatting");
	STAssertEqualStrings(@"+1,112.22%",
						 [formatter pointAskChangeFor:risingStock],
						 @"Large point change formatting");
	
	STAssertEqualStrings(@"-67.97%", [formatter pointAskChangeFor:fallingStock],
						 @"Negative point change formatting");
	STAssertEqualStrings(@"-18.18%", [formatter pointBidChangeFor:fallingStock],
						 @"Negative point change formatting");	
}

- (void) testChangeColors {
	STAssertEqualObjects([UIColor colorWithRed:0.5f green:0.0f
										  blue:0.0f alpha:1.0f],
						 [formatter askChangeColorFor:fallingStock],
						 @"Falling stocks should be red");
	STAssertEqualObjects([UIColor colorWithRed:0.0f green:0.5f
										  blue:0.0f alpha:1.0f],
						 [formatter askChangeColorFor:risingStock],
						 @"Rising stocks should be green");	
}

- (void) testChangeImages {
	STAssertEqualObjects([UIImage imageNamed:@"RedDownArrow.png"],
						 [formatter askChangeImageFor:fallingStock],
						 @"Falling stocks should have a red down arrow");
	STAssertEqualObjects([UIImage imageNamed:@"GreenUpArrow.png"],
						 [formatter askChangeImageFor:risingStock],
						 @"Rising stocks should have a green up arrow");
}

@end

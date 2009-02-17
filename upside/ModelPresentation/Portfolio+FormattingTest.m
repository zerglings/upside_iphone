//
//  Portfolio+FormattingTest.m
//  StockPlay
//
//  Created by Victor Costan on 1/30/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "TestSupport.h"

#import "Portfolio+Formatting.h"


@interface PortfolioFormattingTest : SenTestCase {
  Portfolio* tinyPortfolio;
  Portfolio* smallPortfolio;
  Portfolio* largePortfolio;
  Portfolio* negativePortfolio;
}

@end

@implementation PortfolioFormattingTest

-(void)setUp {
  tinyPortfolio = [[Portfolio alloc] initWithCash:0.20];
  smallPortfolio = [[Portfolio alloc] initWithCash:35.98];
  largePortfolio = [[Portfolio alloc] initWithCash:12000.00];
  negativePortfolio = [[Portfolio alloc] initWithCash:-533.90];
}

-(void)tearDown {
  [tinyPortfolio release];
  [smallPortfolio release];
  [largePortfolio release];
  [negativePortfolio release];
}

-(void)dealloc {
  [super dealloc];
}

-(void)testCashFormatting {
  STAssertEqualStrings(@"$35.98", [smallPortfolio formattedCash],
                       @"Easy cash amount");
  STAssertEqualStrings(@"$12,000.00", [largePortfolio formattedCash],
                       @"Large cash amount");
  STAssertEqualStrings(@"$0.20", [tinyPortfolio formattedCash],
                       @"Tiny cash amount");
  STAssertEqualStrings(@"$-533.90", [negativePortfolio formattedCash],
                       @"Negative cash amount");
}

-(void)testCashColor {
  UIColor* greenColor = [UIColor colorWithRed:0.0f green:0.5f blue:0.0f
                                        alpha:1.0f];
  UIColor* redColor = [UIColor colorWithRed:0.5f green:0.0f blue:0.0f
                                      alpha:1.0f];
  STAssertEqualObjects(greenColor, [tinyPortfolio colorForCash],
                       @"Positive cash amounts should show in green");
  STAssertEqualObjects(redColor, [negativePortfolio colorForCash],
                       @"Negative cash amounts should show in red");
}

@end

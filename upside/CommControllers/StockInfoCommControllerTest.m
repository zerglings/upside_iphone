//
//  StockInfoCommControllerTest.m
//  upside
//
//  Created by Victor Costan on 1/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TestSupport.h"

#import "Stock.h"
#import "StockInfoCommController.h"

@interface StockInfoCommControllerTest : SenTestCase {
	StockInfoCommController* commController;
	NSArray* tickers;
  BOOL validStocksExpected;
	BOOL receivedResponse;
}

@end

@implementation StockInfoCommControllerTest

- (void) setUp {
	commController = [[StockInfoCommController alloc]
					  initWithTarget:self action:@selector(checkResponse:)];
  validStocksExpected = YES;
	receivedResponse = NO;
}

- (void) tearDown {
	[tickers release];
	[commController release];
}

- (void) dealloc {
	[super dealloc];
}

- (void) waitForResponse {
	for (int i = 0; i < 15; i++) {
		[[NSRunLoop currentRunLoop] runUntilDate:
		 [NSDate dateWithTimeIntervalSinceNow:1.0]];
		if (receivedResponse)
			break;
	}
}

- (void) testTechStocks {
	tickers = [[NSArray alloc] initWithObjects: @"AAPL", @"MSFT", @"GOOG", nil];
	[commController fetchInfoForTickers:tickers];
	[self waitForResponse];
	STAssertTrue(receivedResponse, @"Did not receive response");
}

- (void) testTenStocks {
	tickers = [[NSArray alloc] initWithObjects:
			   @"CSCO", @"EWJ", @"F", @"INTC", @"IWN", @"JPM",
			   @"MSFT", @"SPY", @"SNE", @"BAC", nil];
	[commController fetchInfoForTickers:tickers];
	[self waitForResponse];
	STAssertTrue(receivedResponse, @"Did not receive response");
}

- (void) testInvalidStock {
  validStocksExpected = NO;
	tickers = [[NSArray alloc] initWithObjects:@"QWERTY", nil];
	[commController fetchInfoForTickers:tickers];
	[self waitForResponse];
	STAssertTrue(receivedResponse, @"Did not receive response");
}

- (void) checkResponse: (NSArray*)response {
	receivedResponse = YES;
	STAssertFalse([response isKindOfClass:[NSError class]],
				  @"Fetching stocks failed: %@", [response description]);
	STAssertEquals([tickers count], [response count],
				   @"Wrong number of stocks in the response");
	for (NSUInteger i = 0; i < [response count]; i++) {
		Stock* stock = [response objectAtIndex:i];
		STAssertEqualStrings([tickers objectAtIndex:i], [stock ticker],
							 @"Response ticker doesn't match request");

    STAssertEquals(validStocksExpected, [stock isValid],
                   @"Is stock valid when it's supposed to be");
    
    if (!validStocksExpected)
      continue;
    
		STAssertTrue([[stock name] length] != 0,
					 @"Response did not contain company name");
		
		/*
		STAssertGreaterThan(0.0, [stock askPrice],
							@"Response did not contain ask price");
		STAssertGreaterThan(0.0, [stock bidPrice],
							@"Response did not contain bid price");
		 */
		STAssertGreaterThan([stock lastTradePrice], 0.0,
							@"Response did not contain last trade price");
		STAssertGreaterThan([stock previousClosePrice], 0.0,
							@"Response did not contain previous close price");
	}
}

@end

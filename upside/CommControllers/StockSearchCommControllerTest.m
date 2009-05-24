//
//  StockSearchCommControllerTest.m
//  StockPlay
//
//  Created by Victor Costan on 5/3/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "TestSupport.h"

#import "StockSearchCommController.h"


@interface StockSearchCommControllerTest : SenTestCase {
  StockSearchCommController* commController;
  StockSearchData* expectedData;
  BOOL receivedResponse;
}

@end

@implementation StockSearchCommControllerTest

-(void)setUp {
  commController = [[StockSearchCommController alloc]
                    initWithTarget:self action:@selector(checkResponse:)];
  receivedResponse = NO;
}
-(void)tearDown {
  [commController release];
}
-(void)dealloc {
  [super dealloc];
}

-(void)waitForResponse {
  for (int i = 0; i < 15; i++) {
    [[NSRunLoop currentRunLoop] runUntilDate:
     [NSDate dateWithTimeIntervalSinceNow:1.0]];
    if (receivedResponse)
      break;
  }
}

-(void)testSearchTicker {
  expectedData = [[StockSearchData alloc] initWithJson:
      @"{'symbol':'GOOG','name':'Google Inc.','exch':'NMS','type':'S','exchDisp':'NASDAQ'}"];
  [commController startTickerSearch:@"GOOG"];
  [self waitForResponse];
  STAssertTrue(receivedResponse, @"Did not receive response");
  [expectedData release];
}

-(void)testSearchWithSpaces {
  expectedData = [[StockSearchData alloc] initWithJson:
      @"{'symbol':'CSCO','name': 'Cisco Systems, Inc.','exch': 'NMS','type': 'S','exchDisp':'NASDAQ'}"];
  [commController startTickerSearch:@"cisco sy"];
  [self waitForResponse];
  STAssertTrue(receivedResponse, @"Did not receive response");
  [expectedData release];
}

-(void)checkResponse:(NSArray*)response {
  receivedResponse = YES;
  STAssertFalse([response isKindOfClass:[NSError class]],
                @"Fetching stocks failed: %@", [response description]);

  BOOL foundStock = NO;
  for (NSUInteger i = 0; i < [response count]; i++) {
    StockSearchData* stockData = [response objectAtIndex:i];
    STAssertTrue([stockData isKindOfClass:[StockSearchData class]],
                 @"StockSearchData model not instantiated for result %d", i);

    if ([expectedData.symbol isEqualToString:stockData.symbol]) {
      STAssertEqualStrings(expectedData.name, stockData.name, @"name");
      STAssertEqualStrings(expectedData.exch, stockData.exch, @"exch");
      STAssertEqualStrings(expectedData.exchDisp, stockData.exchDisp,
                           @"exchDisp");
      STAssertEqualStrings(expectedData.type, stockData.type, @"type");
      foundStock = YES;
      break;
    }
  }
  STAssertTrue(foundStock,
               @"Response does not contain %@", expectedData.symbol);
}

@end

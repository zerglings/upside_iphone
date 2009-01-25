//
//  StockInfoCommController.m
//  upside
//
//  Created by Victor Costan on 1/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StockInfoCommController.h"

#import "NetworkProgress.h"
#import "Stock.h"
#import "WebSupport.h"

@implementation StockInfoCommController

- (id)initWithTarget: (id)theTarget action: (SEL)theAction {
	if ((self = [super init])) {
		target = theTarget;
		action = theAction;
		
		service = @"http://download.finance.yahoo.com/d/";
		formatString = @"snxb2b3l1p";
		responseProperties = [[NSArray alloc] initWithObjects:
                          @"ticker", @"name", @"market", @"askPrice",
                          @"bidPrice", @"lastTradePrice", @"previousClosePrice",
                          nil];
	}
	return self;
}

- (void) dealloc {
	[responseProperties release];
	[formatString release];
	[super dealloc];
}

- (void)fetchInfoForTickers: (NSArray*)tickers {
	if ([tickers count] == 0) {
		// short-circuit
		[target performSelector:action withObject:tickers];
		return;
	}
	
	NSString* tickerQuery = [tickers componentsJoinedByString:@"+"];
	NSDictionary* requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                               tickerQuery, @"s", formatString, @"f", nil];
  [NetworkProgress connectionStarted];
	[ZNCsvHttpRequest callService:service
                         method:kZNHttpMethodPost
                           data:requestData
                  responseClass:[Stock class]
             responseProperties:responseProperties
                         target:self
                         action:@selector(processResponse:)];
	[tickerQuery release];
}

- (void)processResponse: (NSObject*)response {
  [NetworkProgress connectionDone];
  [target performSelector:action withObject:response];  
}

@end

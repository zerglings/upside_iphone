//
//  StockInfoCommController.h
//  StockPlay
//
//  Created by Victor Costan on 1/22/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <Foundation/Foundation.h>

// Communication controller for fetching stock data.
//
// Currently uses Yahoo finance.
@interface StockInfoCommController : NSObject {
	NSString* service;
	NSArray* responseProperties;
	NSString* formatString;
	SEL action;
	id target;
}

-(id)initWithTarget: (id)target action: (SEL)action;

-(void)fetchInfoForTickers: (NSArray*)tickers;

@end

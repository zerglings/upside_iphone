//
//  Portfolio.h
//  upside
//
//  Created by Victor Costan on 1/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Stock.h"

@interface Portfolio : NSObject {
	NSArray* stockTickers;
	NSDictionary* stockHeld;
}

// How many stocks in this portfolio.
- (NSUInteger)count;

// The numeric stock ID for the stock at the given index.
- (NSString*)stockTickerAtIndex: (NSUInteger)index;

// How many stocks of a certain ticker are owned.
- (NSUInteger)stockOwnedForTicker: (NSString*)stockTicker;

// Reloads the portfolio with the given data.
- (void) loadData: (NSDictionary*)newStocksHeld;

@end

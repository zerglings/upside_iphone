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
	NSDictionary* stocks;
}

// How many stocks in this portfolio.
- (NSUInteger)count;

// The numeric stock ID for the stock at the given index.
- (NSString*)stockTickerAtIndex: (NSUInteger)index;

// Information for the stock at the given index.
- (Stock*)stockWithTicker: (NSString*)stockTicker;
@end

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
	NSArray* stockIds;
	NSDictionary* stocks;
}

// The singleton Portfolio instance.
+ (Portfolio*)sharedPortfolio;

// How many stocks in this portfolio.
- (NSUInteger)count;

// The numeric stock ID for the stock at the given index.
- (NSUInteger)stockIdAtIndex: (NSUInteger)index;

// Information for the stock at the given index.
- (Stock*)stockWithStockId: (NSUInteger)stockId;
@end

//
//  TradeBook.h
//  upside
//
//  Created by Victor Costan on 1/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TradeOrder;

@interface TradeBook : NSObject {
	NSArray* tradeOrders;
}

// How many trade orders in this trade book.
- (NSUInteger) count;

// Information for the trade order at the given index.
- (TradeOrder*) orderAtIndex: (NSUInteger)index;

@end

//
//  TradeBook.h
//  StockPlay
//
//  Created by Victor Costan on 1/6/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TradeOrder;

@interface TradeBook : NSObject {
  NSArray* serverOrders;
  NSArray* filledOrders;
	NSArray* submittedOrders;
  NSMutableArray* pendingOrders;
}

// How many filled trade orders there are in this trade book.
-(NSUInteger)filledCount;

// How many submitted trade orders there are in this trade book.
-(NSUInteger)submittedCount;

// How many trade orders pending submission there are in this trade book.
-(NSUInteger)pendingCount;

// Information for the filled trade order at the given index.
-(TradeOrder*)filledAtIndex:(NSUInteger)index;

// Information for the submitted trade order at the given index.
-(TradeOrder*)submittedAtIndex:(NSUInteger)index;

// Information for the trade order pending submission at the given index.
-(TradeOrder*)pendingAtIndex:(NSUInteger)index;

// Integrates new trade order data from the game server.
-(void)loadData:(NSArray*) tradeOrders;

// Adds a trade order to the submit queue queue.
-(void)queuePendingOrder:(TradeOrder*)order;

// The "topmost" pending order (first to be submitted).
-(TradeOrder*)firstPendingOrder;

// Dequeues a pending order, when the order has been submitted.
-(BOOL)dequeuePendingOrder:(TradeOrder*)pendingOrder
                   submitted:(TradeOrder*)submittedOrder;

// Creates a copy of the pending orders array.
-(NSArray*)copyPendingOrders;

@end

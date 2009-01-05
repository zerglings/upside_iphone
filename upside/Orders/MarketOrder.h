//
//  MarketOrder.h
//  upside
//
//  Created by Victor Costan on 1/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MarketOrder : NSObject {
	NSDictionary* props;
}

// The raw properties behind this order.
// Prefer accessor methods to reaching inside the properties directly.
// Use the strings in this file as keys in the properties dictionary.
@property (nonatomic, readonly) NSDictionary* props;

#pragma mark Accessors

// YES for limit orders, NO for market orders. 
- (BOOL) isLimitOrder;

// 
- (BOOL) isBuyOrder;

// The limit on the order, in cents.
- (NSUInteger) limitCents;

// The ID assigned by the server when the order is submitted. 
- (NSUInteger) serverId;

// The number of stocks in the order.
- (NSUInteger) quantity;

// The ticker of the 
- (NSString*) ticker;

@end

#pragma mark Order Properties Keys

const NSString* kMarketOrderTicker;

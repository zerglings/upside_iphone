//
//  Stock.m
//  upside
//
//  Created by Victor Costan on 1/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Stock.h"

@implementation Stock

#pragma mark Accessors

- (NSString*)ticker {
	return [props objectForKey:kStockTicker];
}
- (NSString*)name {
	return [props objectForKey:kStockName];
}

- (NSUInteger)ownCount {
	return [[props objectForKey:kStockHeld] unsignedIntValue];
}
- (NSUInteger)askCents {
	return [[props objectForKey:kStockAskCents] unsignedIntValue];
}
- (NSUInteger)bidCents {
	return [[props objectForKey:kStockBidCents] unsignedIntValue];
}

- (double)askPrice {
	return [[props objectForKey:kStockAskCents] unsignedIntValue] / 100.0;
}
- (double)bidPrice {
	return [[props objectForKey:kStockBidCents] unsignedIntValue] / 100.0;
}

- (NSUInteger)lastAskCents {
	return [[props objectForKey:kStockLastAskCents] unsignedIntValue];
}

- (NSUInteger)lastBidCents {
	return [[props objectForKey:kStockLastBidCents] unsignedIntValue];
}

@end

#pragma mark Stock Properties Keys

const NSString* kStockTicker = @"ticker";
const NSString* kStockName = @"name";
const NSString* kStockHeld = @"owns";
const NSString* kStockAskCents = @"askCents";
const NSString* kStockBidCents = @"bidCents";
const NSString* kStockLastAskCents = @"lastAskCents";
const NSString* kStockLastBidCents = @"lastBidCents";

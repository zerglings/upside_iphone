//
//  Stock.m
//  upside
//
//  Created by Victor Costan on 1/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Stock.h"

@implementation Stock

#pragma mark Lifecycle

- (id)initWithProperties:(NSDictionary*)properties {
	if ((self = [super init])) {
		props = [NSDictionary dictionaryWithDictionary:properties];
		[props retain];
	}
	return self;
}

- (void) dealloc {
	[props release];
	[super dealloc];
}

#pragma mark Accessors

@dynamic properties;

- (NSDictionary*)properties {
	return props;
}

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

#pragma mark Stock Information Keys

const NSString* kStockTicker = @"ticker";
const NSString* kStockName = @"name";
const NSString* kStockHeld = @"held";
const NSString* kStockAskCents = @"askCents";
const NSString* kStockBidCents = @"bidCents";
const NSString* kStockLastAskCents = @"lastAskCents";
const NSString* kStockLastBidCents = @"lastBidCents";

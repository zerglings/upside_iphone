//
//  Stock.h
//  upside
//
//  Created by Victor Costan on 1/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ModelSupport.h"

// Data about a single stock.
@interface Stock : ZNModel {
	NSString* ticker;
	NSString* name;
	NSUInteger askCents;
	NSUInteger bidCents;
	NSUInteger lastAskCents;
	NSUInteger lastBidCents;	
}

// The stock's ticker, e.g. @"AAPL" for Apple.
@property (nonatomic, readonly, retain) NSString* ticker;

// The stock's name, e.g. @"Apple Inc."
@property (nonatomic, readonly, retain) NSString* name;

// The stock's asking price, in cents.
@property (nonatomic, readonly) NSUInteger askCents;

// The stock's bidding price, in cents.
@property (nonatomic, readonly) NSUInteger bidCents;

// The stock's last closing bidding price, in cents.
@property (nonatomic, readonly) NSUInteger lastAskCents;

// The stock's last closing asking price, in cents.
@property (nonatomic, readonly) NSUInteger lastBidCents;

#pragma mark Convenience Accessors

// The stock's asking price, in dollars.
- (double) askPrice;

// The stock's bidding price, in dollars.
- (double) bidPrice;

#pragma mark Convenience Constructors

- (id) initWithTicker: (NSString*)ticker
				 name: (NSString*)name
			 askCents: (NSUInteger)askCents
			 bidCents: (NSUInteger)bidCents
		 lastAskCents: (NSUInteger)lastAskCents
		 lastBidCents: (NSUInteger)lastBidCents;
@end

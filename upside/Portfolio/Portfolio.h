//
//  Portfolio.h
//  upside
//
//  Created by Victor Costan on 1/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


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
- (NSDictionary*)stockWithStockId: (NSUInteger)stockId;
@end

#pragma mark Stock Information Keys

// A NSString with the stock's ticker, e.g. @"AAPL" for Apple.
const NSString* kStockTicker;

// A NSString with the stock's name, e.g. @"Apple Inc."
const NSString* kStockName;

// A NSNumber with the stock's asking price, in cents.
const NSString* kStockAskCents;

// A NSNumber with the stock's bidding price, in cents.
const NSString* kStockBidCents;

// A NSNumber with the stock's last clsoing asking price, in cents.
const NSString* kStockLastAskCents;

// A NSNumber with the stock's last closing bidding price, in cents.
const NSString* kStockLastBidCents;

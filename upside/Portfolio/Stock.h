//
//  Stock.h
//  upside
//
//  Created by Victor Costan on 1/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Data about a single stock.
@interface Stock : NSObject {
	NSDictionary* props;
}

// Initializes the stock's state from a dictionary of properties.
- (id)initWithProperties:(NSDictionary*)properties;

#pragma mark Accessors

// The raw properties behind this stock.
// Prefer accessor methods to reaching inside the properties directly.
// Use the strings in this file as keys in the properties dictionary.
@property (nonatomic, readonly) NSDictionary* properties;

// The stock's ticker, e.g. @"AAPL" for Apple.
- (NSString*)ticker;
// The stock's name, e.g. @"Apple Inc."
- (NSString*)name;

// The number of stocks held in a portfolio.
- (NSUInteger)ownCount;
// The stock's asking price, in cents.
- (NSUInteger)askCents;
// The stock's bidding price, in cents.
- (NSUInteger)bidCents;

// The stock's asking price, in dollars.
- (double)askPrice;
// The stock's bidding price, in dollars.
- (double)bidPrice;

// The stock's last closing bidding price, in cents.
- (NSUInteger)lastAskCents;

// The stock's last closing asking price, in cents.
- (NSUInteger)lastBidCents;

@end

#pragma mark Stock Properties Keys

// A NSString with the stock's ticker, e.g. @"AAPL" for Apple.
const NSString* kStockTicker;

// A NSString with the stock's name, e.g. @"Apple Inc."
const NSString* kStockName;

// A NSNumber with the number of stocks held in the portfolio.
const NSString* kStockHeld;

// A NSNumber with the stock's asking price, in cents.
const NSString* kStockAskCents;

// A NSNumber with the stock's bidding price, in cents.
const NSString* kStockBidCents;

// A NSNumber with the stock's last clsoing asking price, in cents.
const NSString* kStockLastAskCents;

// A NSNumber with the stock's last closing bidding price, in cents.
const NSString* kStockLastBidCents;

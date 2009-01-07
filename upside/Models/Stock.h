//
//  Stock.h
//  upside
//
//  Created by Victor Costan on 1/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DictionaryBackedModel.h"

// Data about a single stock.
@interface Stock : DictionaryBackedModel {
}

#pragma mark Accessors

// The stock's ticker, e.g. @"AAPL" for Apple.
- (NSString*) ticker;
// The stock's name, e.g. @"Apple Inc."
- (NSString*) name;

// The stock's asking price, in cents.
- (NSUInteger) askCents;
// The stock's bidding price, in cents.
- (NSUInteger) bidCents;

// The stock's asking price, in dollars.
- (double) askPrice;
// The stock's bidding price, in dollars.
- (double) bidPrice;

// The stock's last closing bidding price, in cents.
- (NSUInteger) lastAskCents;

// The stock's last closing asking price, in cents.
- (NSUInteger) lastBidCents;

@end

#pragma mark Stock Properties Keys

// An NSString with the stock's ticker, e.g. @"AAPL" for Apple.
const NSString* kStockTicker;

// An NSString with the stock's name, e.g. @"Apple Inc."
const NSString* kStockName;

// An NSNumber with the stock's asking price, in cents.
const NSString* kStockAskCents;

// An NSNumber with the stock's bidding price, in cents.
const NSString* kStockBidCents;

// An NSNumber with the stock's last clsoing asking price, in cents.
const NSString* kStockLastAskCents;

// An NSNumber with the stock's last closing bidding price, in cents.
const NSString* kStockLastBidCents;

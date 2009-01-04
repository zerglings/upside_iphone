//
//  Stock.h
//  upside
//
//  Created by Victor Costan on 1/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Data about a single stock.
typedef NSDictionary Stock;

#pragma mark Stock Information Keys

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

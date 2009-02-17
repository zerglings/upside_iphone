//
//  Stock.h
//  StockPlay
//
//  Created by Victor Costan on 1/4/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ModelSupport.h"

// Data about a single stock.
@interface Stock : ZNModel {
	NSString* ticker;
	NSString* name;
  NSString* market;
	double askPrice;
	double bidPrice;
	double lastTradePrice;
	double previousClosePrice;
}

// The stock's ticker, e.g. @"AAPL" for Apple.
@property (nonatomic, readonly, retain) NSString* ticker;

// The stock's name, e.g. @"Apple Inc."
@property (nonatomic, readonly, retain) NSString* name;

// The market that the stock is trading on, e.g. @"NYSE".
@property (nonatomic, readonly, retain) NSString* market;

// The stock's asking price.
@property (nonatomic, readonly) double askPrice;

// The stock's bidding price.
@property (nonatomic, readonly) double bidPrice;

// The closing price for the last trade involving the stock.
@property (nonatomic, readonly) double lastTradePrice;

// The stock's price (last trade) at the previous stock closing.
@property (nonatomic, readonly) double previousClosePrice;

#pragma mark Convenience Accessors

// NO if the stock represents Yahoo's "can't find this" answer.
-(BOOL)isValid;

#pragma mark Convenience Constructors

-(id)initWithTicker:(NSString*)ticker
                 name:(NSString*)name
               market:(NSString*)market
             askPrice:(double)askPrice
             bidPrice:(double)bidPrice
       lastTradePrice:(double)lastTradePrice
   previousClosePrice:(double)previousClosePrice;
@end

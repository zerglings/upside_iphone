//
//  StockFormatter.h
//  upside
//
//  Created by Victor Costan on 1/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Stock.h"

@interface StockFormatter : NSObject {
	NSNumberFormatter* countFormatter;
	NSNumberFormatter* priceFormatter;
	NSNumberFormatter* netChangeFormatter;
	NSNumberFormatter* pointChangeFormatter;
}

// The singleton StockFormatter instance.
+ (StockFormatter*) sharedFormatter;

// Format the number of stocks owned.
- (NSString*) ownCountFor:(Stock*)stock;
// Format the stock's ask price.
- (NSString*) askPriceFor:(Stock*)stock;
// Format the stock's bid price.
- (NSString*) bidPriceFor:(Stock*)stock;
// Format the stock's value in the portfolio, using the ask price.
- (NSString*) valueUsingAskPriceFor:(Stock*)stock;
// Format the stock's value in the portfolio, using the bid price.
- (NSString*) valueUsingBskPriceFor:(Stock*)stock;


// Format the net change in the stock's ask price.
- (NSString*) netAskChangeFor:(Stock*)stock;
// Format the net change in the stock's bid price.
- (NSString*) netBidChangeFor:(Stock*)stock;
// Format the point change in the stock's ask price.
- (NSString*) pointAskChangeFor:(Stock*)stock;
// Format the point change in the stock's bid price.
- (NSString*) pointBidChangeFor:(Stock*)stock;

// The color showing the change in the stock's ask price. 
- (UIColor*) askChangeColorFor:(Stock*)stock;
// The color showing the change in the stock's bid price. 
- (UIColor*) bidChangeColorFor:(Stock*)stock;
// The image showing the change in the stock's ask price. 
- (UIImage*) askChangeImageFor:(Stock*)stock;
// The image showing the change in the stock's bid price. 
- (UIImage*) bidChangeImageFor:(Stock*)stock;

@end

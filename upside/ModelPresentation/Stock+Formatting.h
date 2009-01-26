//
//  StockFormatter.h
//  upside
//
//  Created by Victor Costan on 1/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Stock.h"

@interface Stock (Formatting)

// Format the stock's ask price.
- (NSString*) formattedAskPrice;
// Format the stock's bid price.
- (NSString*) formattedBidPrice;
// Format the stock's last trade price.
- (NSString*) formattedTradePrice;

// Format the value of some stocks, using the ask price.
- (NSString*) formattedValueUsingAskPriceFor: (NSUInteger)stockCount;
// Format the value of some stocks, using the bid price.
- (NSString*) formattedValueUsingBidPriceFor: (NSUInteger)stockCount;
// Format the value of some stocks, using the stock's last trade price.
- (NSString*) formattedValueUsingTradePriceFor: (NSUInteger)stockCount;


// Format the net change in the stock's ask price.
- (NSString*) formattedNetAskChange;
// Format the net change in the stock's bid price.
- (NSString*) formattedNetBidChange;
// Format the net change in the stock's trade price.
- (NSString*) formattedNetTradeChange;
// Format the point change in the stock's ask price.
- (NSString*) formattedPointAskChange;
// Format the point change in the stock's bid price.
- (NSString*) formattedPointBidChange;
// Format the net change in the stock's trade price.
- (NSString*) formattedPointTradeChange;

// The color showing the change in the stock's ask price. 
- (UIColor*) colorForAskChange;
// The color showing the change in the stock's bid price. 
- (UIColor*) colorForBidChange;
// The color showing the change in the stock's bid price. 
- (UIColor*) colorForTradeChange;
// The image showing the change in the stock's ask price. 
- (UIImage*) imageForAskChange;
// The image showing the change in the stock's bid price. 
- (UIImage*) imageForBidChange;
// The color showing the change in the stock's bid price. 
- (UIImage*) imageForTradeChange;

// The image showing the stock's validity.
- (UIImage*) imageForValidity;

@end

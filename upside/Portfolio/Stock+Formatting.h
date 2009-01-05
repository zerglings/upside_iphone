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

// Format the number of stocks owned.
- (NSString*) formattedOwnCount;
// Format the stock's ask price.
- (NSString*) formattedAskPrice;
// Format the stock's bid price.
- (NSString*) formattedBidPrice;
// Format the stock's value in the portfolio, using the ask price.
- (NSString*) formattedValueUsingAskPrice;
// Format the stock's value in the portfolio, using the bid price.
- (NSString*) formattedValueUsingBidPrice;


// Format the net change in the stock's ask price.
- (NSString*) formattedNetAskChange;
// Format the net change in the stock's bid price.
- (NSString*) formattedNetBidChange;
// Format the point change in the stock's ask price.
- (NSString*) formattedPointAskChange;
// Format the point change in the stock's bid price.
- (NSString*) formattedPointBidChange;

// The color showing the change in the stock's ask price. 
- (UIColor*) colorForAskChange;
// The color showing the change in the stock's bid price. 
- (UIColor*) colorForBidChange;
// The image showing the change in the stock's ask price. 
- (UIImage*) imageForAskChange;
// The image showing the change in the stock's bid price. 
- (UIImage*) imageForBidChange;

@end

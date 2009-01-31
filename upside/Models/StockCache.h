//
//  StockCache.h
//  StockPlay
//
//  Created by Victor Costan on 1/6/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "ControllerSupport.h"

@class Stock;
@class StockInfoCommController;

@interface StockCache : ZNSyncController {
	NSMutableDictionary* stocks;
	StockInfoCommController* commController;
	NSTimeInterval refreshPeriod;
}

// Information for the stock with the given ticker.
- (Stock*)stockForTicker: (NSString*)stockTicker;

@end

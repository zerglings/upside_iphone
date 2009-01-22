//
//  StockCache.h
//  upside
//
//  Created by Victor Costan on 1/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Stock;
@class StockInfoCommController;

@interface StockCache : NSObject {
	NSMutableDictionary* stocks;
	StockInfoCommController* commController;
	NSTimeInterval refreshPeriod;
}

// Information for the stock with the given ticker.
- (Stock*)stockForTicker: (NSString*)stockTicker;

// Instructs the stock cache to start updating its contents periodically.
- (void) startUpdating;

@end

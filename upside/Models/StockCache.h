//
//  StockCache.h
//  upside
//
//  Created by Victor Costan on 1/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Stock;

@interface StockCache : NSObject {
	NSDictionary* stocks;
}

// Information for the stock with the given ticker.
- (Stock*)stockForTicker: (NSString*)stockTicker;

@end

//
//  AssetBook+Formatting.h
//  upside
//
//  Created by Victor Costan on 2/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AssetBook.h"

@class StockCache;

// Presentation aspect for overall assets.
@interface AssetBook (Formatting)
  // Format the available cash.
  - (NSString*)formattedCash;
  
  // The color showing the available cash.
  - (UIColor*)colorForCash;  

  // Format the stock worth.
  - (NSString*)formattedStockWorthWithCache: (StockCache*)stockCache;

  // Format the net worth.
  - (NSString*)formattedNetWorthWithCache: (StockCache*)stockCache;
@end

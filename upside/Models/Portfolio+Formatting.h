//
//  Portfolio+Formatting.h
//  upside
//
//  Created by Victor Costan on 1/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Portfolio (Formatting)

+ (NSString*) formatStockOwned: (NSUInteger) stockOwned;

- (NSString*) formattedStockOwnedForTicker: (NSString*) ticker;

@end

//
//  TradeOrder+Formatting.h
//  upside
//
//  Created by Victor Costan on 1/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TradeOrder (Formatting)

- (NSString*) formattedQuantity;

- (NSString*) formattedQuantityFilled;

- (NSString*) formattedLimitPrice;

@end

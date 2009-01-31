//
//  TradeOrder+Formatting.h
//  StockPlay
//
//  Created by Victor Costan on 1/5/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TradeOrder (Formatting)

-(NSString*)formattedQuantity;

-(NSString*)formattedQuantityFilled;

-(NSString*)formattedPercentFilled;

-(NSString*)formattedLimitPrice;

@end

//
//  TradeOrder+Formatting.m
//  StockPlay
//
//  Created by Victor Costan on 1/5/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "TradeOrder.h"
#import "TradeOrder+Formatting.h"


@implementation TradeOrder (Formatting)

#pragma mark Lifecycle

static NSNumberFormatter* quantityFormatter = nil;
static NSNumberFormatter* priceFormatter = nil;
static NSNumberFormatter* percentFormatter = nil;

#pragma mark Formatting

static void SetupFormatters() {
  @synchronized([TradeOrder class]) {
    if (quantityFormatter == nil) {
      quantityFormatter = [[NSNumberFormatter alloc] init];
      [quantityFormatter setPositiveFormat:@"#,##0"];

      priceFormatter = [[NSNumberFormatter alloc] init];
      [priceFormatter setPositiveFormat:@"$#,##0.00"];

      percentFormatter = [[NSNumberFormatter alloc] init];
      [percentFormatter setPositiveFormat:@"##0.00%"];
    }
  }
}

-(NSString*)formattedQuantity {
  SetupFormatters();
  return [quantityFormatter stringFromNumber:[NSNumber numberWithUnsignedInt:
                        quantity]];
}

-(NSString*)formattedQuantityFilled {
  SetupFormatters();
  return [quantityFormatter stringFromNumber:[NSNumber numberWithUnsignedInt:
                                              [self filledQuantity]]];
}

-(NSString*)formattedPercentFilled {
  SetupFormatters();
  return [percentFormatter stringFromNumber:[NSNumber numberWithDouble:
                         [self fillRatio]]];
}


-(NSString*)formattedLimitPrice {
  SetupFormatters();

  if(![self isLimitOrder]) {
    return @"mkt";
  }

  return [priceFormatter stringFromNumber:[NSNumber numberWithDouble:
                       [self limitPrice]]];
}

@end

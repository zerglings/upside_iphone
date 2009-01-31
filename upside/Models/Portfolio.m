//
//  Portfolio.m
//  StockPlay
//
//  Created by Victor Costan on 1/29/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "Portfolio.h"


@implementation Portfolio
@synthesize cash;

- (id)initWithCash: (double)theCash {
  return [super initWithModel:nil properties:
          [NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:theCash]
                                      forKey:@"cash"]];
}

@end

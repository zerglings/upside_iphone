//
//  Portfolio.m
//  upside
//
//  Created by Victor Costan on 1/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
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

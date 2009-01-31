//
//  Portfolio.h
//  StockPlay
//
//  Created by Victor Costan on 1/29/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "ModelSupport.h"


// Mirrors server-side Portfolio model.
@interface Portfolio : ZNModel {
  double cash;
}

// The cash balance in a portfolio, in USD.
@property (nonatomic, readonly) double cash;

// Convenience initializer for testing.
- (id)initWithCash: (double)cash;

@end

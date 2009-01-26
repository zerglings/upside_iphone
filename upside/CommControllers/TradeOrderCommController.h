//
//  TradeOrderCommController.h
//  upside
//
//  Created by Victor Costan on 1/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TradeOrder;

// Submits trade orders.
@interface TradeOrderCommController : NSObject {
  NSDictionary* responseModels;
  SEL action;
  id target;
}

- (id)initWithTarget: (id)target action: (SEL)action;

- (void)submitOrder: (TradeOrder*)order;
@end

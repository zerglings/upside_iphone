//
//  TradeOrderCommController.h
//  StockPlay
//
//  Created by Victor Costan on 1/26/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TradeOrder;

// Submits trade orders.
@interface TradeOrderCommController : NSObject {
  NSArray* responseQueries;
  SEL action;
  id target;
}

-(id)initWithTarget:(id)target action:(SEL)action;

-(void)submitOrder:(TradeOrder*)order;
@end

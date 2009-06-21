//
//  TradeOrderCommController.h
//  StockPlay
//
//  Created by Victor Costan on 1/26/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ControllerSupport.h"


@class TradeOrder;

// Submits trade orders.
@interface TradeOrderCommController : ZNHttpJsonCommController {
}
-(void)submitOrder:(TradeOrder*)order;
@end

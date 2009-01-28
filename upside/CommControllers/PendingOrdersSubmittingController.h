//
//  PendingOrdersSubmittingController.h
//  upside
//
//  Created by Victor Costan on 1/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ControllerSupport.h"

@class LoginCommController;
@class TradeBook;
@class TradeOrder;
@class TradeOrderCommController;

// Submits pending orders to the game server.
@interface PendingOrdersSubmittingController : ZNSyncController {
  TradeBook* tradeBook;
  TradeOrder* lastSubmittedOrder;
  TradeOrderCommController* commController;
  LoginCommController* loginCommController;
}

- (id)initWithTradeBook: (TradeBook*)tradeBook;

@end

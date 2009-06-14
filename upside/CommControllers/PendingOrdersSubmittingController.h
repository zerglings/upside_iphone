//
//  PendingOrdersSubmittingController.h
//  StockPlay
//
//  Created by Victor Costan on 1/26/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "ControllerSupport.h"

@class LoginCommController;
@class TradeBook;
@class TradeOrder;
@class TradeOrderCommController;

// Submits pending orders to the game server.
@interface PendingOrdersSubmittingController : ZNSyncController {
  TradeBook* tradeBook;
  TradeOrderCommController* commController;
  LoginCommController* loginCommController;
}

-(id)initWithTradeBook:(TradeBook*)tradeBook;

@end

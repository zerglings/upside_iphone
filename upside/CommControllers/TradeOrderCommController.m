//
//  TradeOrderCommController.m
//  StockPlay
//
//  Created by Victor Costan on 1/26/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "TradeOrderCommController.h"

#import "ControllerSupport.h"
#import "ServerPaths.h"
#import "ServiceError.h"
#import "TradeOrder.h"
#import "WebSupport.h"

@implementation TradeOrderCommController

-(id)initWithTarget:(id)theTarget action:(SEL)theAction {
  if ((self = [super init])) {
    target = theTarget;
    action = theAction;

    responseQueries = [[NSArray alloc] initWithObjects:
                       [TradeOrder class], @"/tradeOrder",
                       [ServiceError class], @"/error",
                       nil];
  }
  return self;
}

-(void)dealloc {
  [responseQueries release];
  [super dealloc];
}

-(void)submitOrder:(TradeOrder*)order {
  NSDictionary* request = [[NSDictionary alloc] initWithObjectsAndKeys:
                           order, @"trade_order", nil];
  [ZNNetworkProgress connectionStarted];
  [ZNJsonHttpRequest callService:[ServerPaths orderSubmissionUrl]
                          method:[ServerPaths orderSubmissionMethod]
                            data:request
                 responseQueries:responseQueries
                          target:self
                          action:@selector(processResponse:)];
  [request release];
}

-(void)processResponse:(NSObject*)response {
  [ZNNetworkProgress connectionDone];
  [target performSelector:action withObject:response];
}

@end

//
//  TradeOrderCommController.m
//  StockPlay
//
//  Created by Victor Costan on 1/26/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "TradeOrderCommController.h"

#import "NetworkProgress.h"
#import "ServerPaths.h"
#import "ServiceError.h"
#import "TradeOrder.h"
#import "WebSupport.h"

@implementation TradeOrderCommController

-(id)initWithTarget:(id)theTarget action:(SEL)theAction {
  if ((self = [super init])) {
    target = theTarget;
    action = theAction;

    responseModels = [[NSDictionary alloc] initWithObjectsAndKeys:
                      [TradeOrder class], @"trade_order",
                      [ServiceError class], @"error",
                      nil];
  }
  return self;
}

-(void)dealloc {
  [responseModels release];
  [super dealloc];
}

-(void)submitOrder:(TradeOrder*)order {
  NSDictionary* request = [[NSDictionary alloc] initWithObjectsAndKeys:
                           order, @"trade_order", nil];
  [NetworkProgress connectionStarted];
  [ZNXmlHttpRequest callService:[ServerPaths orderSubmissionUrl]
                         method:[ServerPaths orderSubmissionMethod]
                           data:request
                 responseModels:responseModels
                         target:self
                         action:@selector(processResponse:)];
  [request release];
}

-(void)processResponse:(NSObject*)response {
  [NetworkProgress connectionDone];
  [target performSelector:action withObject:response];
}

@end

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

+(NSArray*)copyResponseQueries {
  return [[NSArray alloc] initWithObjects:
          [TradeOrder class], @"/tradeOrder",
          [ServiceError class], @"/error",
          nil];
}
-(void)submitOrder:(TradeOrder*)order {
  NSDictionary* request = [[NSDictionary alloc] initWithObjectsAndKeys:
                           order, @"trade_order", nil];
  [self callService:[ServerPaths orderSubmissionUrl]
             method:[ServerPaths orderSubmissionMethod]
               data:request];
  [request release];
}

@end

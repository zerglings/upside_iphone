//
//  PortfolioCommController.m
//  StockPlay
//
//  Created by Victor Costan on 1/23/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "PortfolioCommController.h"

#import "NetworkProgress.h"
#import "Portfolio.h"
#import "PortfolioStat.h"
#import "Position.h"
#import "TradeOrder.h"
#import "ServiceError.h"
#import "ServerPaths.h"
#import "WebSupport.h"

@implementation PortfolioCommController

-(id)initWithTarget:(id)theTarget action:(SEL)theAction {
  if ((self = [super init])) {
    target = theTarget;
    action = theAction;

    responseQueries = [[NSArray alloc] initWithObjects:
                       [Position class], @"/positions/?",
                       [Portfolio class], @"/portfolio",
                       [PortfolioStat class], @"/stats/?",
                       [TradeOrder class], @"/tradeOrders/?",
                       [ServiceError class], @"/error",
                       nil];
  }
  return self;
}

-(void)dealloc {
  [responseQueries release];
  [super dealloc];
}

-(void)sync {
  [NetworkProgress connectionStarted];
  [ZNJsonHttpRequest callService:[ServerPaths portfolioSyncUrl]
                          method:[ServerPaths portfolioSyncMethod]
                            data:nil
                 responseQueries:responseQueries
                          target:self
                          action:@selector(processResponse:)];
}

-(void)processResponse:(NSArray*)response {
  [NetworkProgress connectionDone];
  [target performSelector:action withObject:response];
}

@end

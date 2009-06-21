//
//  PortfolioCommController.m
//  StockPlay
//
//  Created by Victor Costan on 1/23/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "PortfolioCommController.h"

#import "ControllerSupport.h"
#import "Portfolio.h"
#import "PortfolioStat.h"
#import "Position.h"
#import "TradeOrder.h"
#import "ServiceError.h"
#import "ServerPaths.h"
#import "WebSupport.h"

@implementation PortfolioCommController
+(NSArray*)copyResponseQueries {
  return [[NSArray alloc] initWithObjects:
          [Position class], @"/positions/?",
          [Portfolio class], @"/portfolio",
          [PortfolioStat class], @"/stats/?",
          [TradeOrder class], @"/tradeOrders/?",
          [ServiceError class], @"/error",
          nil];
}

-(void)sync {
  [self callService:[ServerPaths portfolioSyncUrl]
             method:[ServerPaths portfolioSyncMethod]
               data:nil];
}
@end

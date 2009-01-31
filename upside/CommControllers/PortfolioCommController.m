//
//  PortfolioCommController.m
//  StockPlay
//
//  Created by Victor Costan on 1/23/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "PortfolioCommController.h"

#import "NetworkProgress.h"
#import "Position.h"
#import "Portfolio.h"
#import "TradeOrder.h"
#import "ServiceError.h"
#import "ServerPaths.h"
#import "WebSupport.h"

@implementation PortfolioCommController

-(id)initWithTarget: (id)theTarget action: (SEL)theAction {
	if ((self = [super init])) {
		target = theTarget;
		action = theAction;
		
		responseModels = [[NSDictionary alloc] initWithObjectsAndKeys:
                      [Position class], @"position",
                      [Portfolio class], @"portfolio",
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

-(void)sync {
  [NetworkProgress connectionStarted];
	[ZNXmlHttpRequest callService:[ServerPaths portfolioSyncUrl]
                         method:[ServerPaths portfolioSyncMethod]
                           data:nil
                 responseModels:responseModels
                         target:self
                         action:@selector(processResponse:)];
}

-(void)processResponse: (NSObject*)response {
  [NetworkProgress connectionDone];
  [target performSelector:action withObject:response];
}

@end

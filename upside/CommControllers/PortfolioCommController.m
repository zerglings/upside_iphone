//
//  PortfolioCommController.m
//  upside
//
//  Created by Victor Costan on 1/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PortfolioCommController.h"

#import "Position.h"
#import "TradeOrder.h"
#import "ServiceError.h"
#import "ServerPaths.h"
#import "WebSupport.h"

@implementation PortfolioCommController

- (id)initWithTarget: (id)theTarget action: (SEL)theAction {
	if ((self = [super init])) {
		target = theTarget;
		action = theAction;
		
		responseModels = [[NSDictionary alloc] initWithObjectsAndKeys:
						  [Position class], @"position",
						  [TradeOrder class], @"trade_order",
						  [ServiceError class], @"error",
						  nil];
	}
	return self;
}

- (void) dealloc {
	[responseModels release];
	[super dealloc];
}

- (void)sync {
	[ZNXmlHttpRequest callService:[ServerPaths portfolioSyncUrl]
                         method:[ServerPaths portfolioSyncMethod]
                           data:nil
                 responseModels:responseModels
                         target:target
                         action:action];
}

@end

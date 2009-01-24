//
//  GameSyncController.m
//  upside
//
//  Created by Victor Costan on 1/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GameSyncController.h"

#import "ActivationState.h"
#import "Game.h"
#import "LoginCommController.h"
#import "Portfolio.h"
#import "Portfolio+StockCache.h"
#import "PortfolioCommController.h"
#import "Position.h"
#import "ServiceError.h"
#import "TradeOrder.h"

@interface GameSyncController () <LoginCommDelegate>
@end

@implementation GameSyncController

- (id) initWithGame: (Game*)theGame {
	if ((self = [super initWithErrorModelClass:[ServiceError class]
                                syncInterval:60.0])) {
		game = theGame;
		commController = [[PortfolioCommController alloc]
                      initWithTarget:self
                      action:@selector(receivedResults:)];
		loginCommController = [[LoginCommController alloc] init];
		loginCommController.delegate = self;
	}
	return self;
}

- (void) dealloc {
	[commController release];
	[super dealloc];
}

- (void) sync {
	[commController sync];
}

- (BOOL) integrateResults: (NSArray*)results {
	NSMutableArray* positions = [[NSMutableArray alloc] init];
	NSMutableArray* tradeOrders = [[NSMutableArray alloc] init];
	NSMutableArray* trades = [[NSMutableArray alloc] init];
	for (ZNModel* model in results) {
		if ([model isKindOfClass:[Position class]])
			[positions addObject:model];
		if ([model isKindOfClass:[TradeOrder class]])
			[tradeOrders addObject:model];
		// TODO(overmind): handle trades and cash here
	}
	
	[[game portfolio] loadData:positions];
	//[[game tradeBook] loadData:tradeOrders];
	[positions release];
	[tradeOrders release];
	[trades release];
  
  [[game portfolio] loadTickersIntoStockCache:[game stockCache]];
	return YES;
}

- (BOOL) handleServiceError: (ServiceError*)error {
	if ([error isLoginError]) {
		[loginCommController loginUsing:[ActivationState sharedState]];
    return NO;
	}
  
  return YES;
}

- (void)loginFailed: (NSError*)error {
	// TODO(overmind): user changed their password, recover from this
}

- (void)loginSucceeded {
	// This happens if we login after syncing failed.
	// So we need to resume syncing.
	[self sync];
}

@end

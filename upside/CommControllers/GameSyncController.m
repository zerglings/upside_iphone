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
#import "PortfolioCommController.h"
#import "Position.h"
#import "ServiceError.h"
#import "TradeOrder.h"

@interface GameSyncController () <LoginCommDelegate>
- (void) startSyncing;
- (void) sync;
- (void) receivedSyncResults: (NSArray*)results;
- (BOOL) integrateSyncResults: (NSArray*)results;
- (void) handleServiceError: (ServiceError*)error;
@end


@implementation GameSyncController

- (id) initWithGame: (Game*)theGame {
	if ((self = [super init])) {
		game = theGame;
		commController = [[PortfolioCommController alloc]
                      initWithTarget:self
                      action:@selector(receivedSyncResults:)];
		loginCommController = [[LoginCommController alloc] init];
		loginCommController.delegate = self;
		syncInterval = 60.0;
	}
	return self;
}

- (void) dealloc {
	[commController release];
	[super dealloc];
}

- (void) startSyncing {
	[self sync];
}

- (void) sync {
	[commController sync];
}

- (void) receivedSyncResults: (NSArray*)results {
	if ([self integrateSyncResults:results]) {
		[self performSelector:@selector(sync)
               withObject:nil
               afterDelay:syncInterval]; 
	}
}

- (BOOL) integrateSyncResults: (NSArray*)results {
	if (![results isKindOfClass:[NSArray class]]) {
		// comm error, retry later
		return YES;
	}
	
	if ([results count] == 0) {
		// the server 500ed, retry later
		return YES;
	}
	
	ServiceError* maybeError = [results objectAtIndex:0];
	if ([maybeError isKindOfClass:[ServiceError class]]) {
		// error, will be handled separately
		[self handleServiceError:maybeError];
		return NO;
	}
  
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
	return YES;
}

- (void) handleServiceError: (ServiceError*)error {
	if ([error isLoginError]) {
		[loginCommController loginUsing:[ActivationState sharedState]];
	}
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

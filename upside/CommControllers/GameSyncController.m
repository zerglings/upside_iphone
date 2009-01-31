//
//  GameSyncController.m
//  StockPlay
//
//  Created by Victor Costan on 1/24/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "GameSyncController.h"

#import "ActivationState.h"
#import "AssetBook.h"
#import "AssetBook+RSS.h"
#import "AssetBook+StockCache.h"
#import "Game.h"
#import "LoginCommController.h"
#import "Portfolio.h"
#import "PortfolioCommController.h"
#import "Position.h"
#import "ServiceError.h"
#import "TradeOrder.h"

@interface GameSyncController () <LoginCommDelegate>
@end

@implementation GameSyncController

-(id)initWithGame: (Game*)theGame {
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

-(void)dealloc {
	[commController release];
  [loginCommController release];
	[super dealloc];
}

-(void)sync {
	[commController sync];
}

-(BOOL)integrateResults: (NSArray*)results {
	NSMutableArray* assets = [[NSMutableArray alloc] init];
	NSMutableArray* tradeOrders = [[NSMutableArray alloc] init];
	NSMutableArray* trades = [[NSMutableArray alloc] init];
	for (ZNModel* model in results) {
		if ([model isKindOfClass:[Position class]] ||
        [model isKindOfClass:[Portfolio class]]) {
			[assets addObject:model];
    }
    else if ([model isKindOfClass:[TradeOrder class]]) {
			[tradeOrders addObject:model];      
    }
		// TODO(overmind): handle trades here
	}
	
	[[game assetBook] loadData:assets];
	[[game tradeBook] loadData:tradeOrders];
	[assets release];
	[tradeOrders release];
	[trades release];
  
  [[game assetBook] loadTickersIntoStockCache:[game stockCache]];
  [[game assetBook] loadRssFeedsIntoCenter:[game newsCenter]];
	return YES;
}

-(BOOL)handleServiceError: (ServiceError*)error {
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
	[self resumeSyncing];
}

@end

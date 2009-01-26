//
//  Game.m
//  upside
//
//  Created by Victor Costan on 1/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Game.h"

#import "GameSyncController.h"
#import "NewsCenter.h"
#import "PendingOrdersSubmittingController.h"
#import "Portfolio.h"
#import "Portfolio+RSS.h"
#import "Portfolio+StockCache.h"
#import "StockCache.h"
#import "TradeBook.h"

@implementation Game

#pragma mark Lifecycle

- (id) init {
	if ((self = [super init])) {
		newsCenter = [[NewsCenter alloc] init];
		stockCache = [[StockCache alloc] init];
		portfolio = [[Portfolio alloc] init];
		tradeBook = [[TradeBook alloc] init];
		syncController = [[GameSyncController alloc] initWithGame:self];
    orderSubmittingController = [[PendingOrdersSubmittingController alloc]
                                 initWithTradeBook:tradeBook];
	}
	return self;
}

- (void) dealloc {
  [orderSubmittingController stopSyncing];
  [orderSubmittingController release];
  [syncController stopSyncing];
  [syncController release];
	[newsCenter release];
	[stockCache release];
	[portfolio release];
	[tradeBook release];
	[super dealloc];
}

# pragma mark Setup

- (void) setup {
	[portfolio loadRssFeedsIntoCenter:newsCenter];
	
	[portfolio loadTickersIntoStockCache:stockCache];
	[stockCache startSyncing];
	[syncController startSyncing];
  [orderSubmittingController startSyncing];
}

#pragma mark Accessors

@synthesize portfolio;
@synthesize tradeBook;
@synthesize stockCache;
@synthesize newsCenter;
@synthesize orderSubmittingController;

#pragma mark Singleton

static Game* sharedGame = nil;

+ (Game*) sharedGame {
	@synchronized(self) {
		if (sharedGame == nil) {
			sharedGame = [[Game alloc] init];
			[sharedGame setup];
		}
	}
	return sharedGame;
}

@end

//
//  Game.m
//  upside
//
//  Created by Victor Costan on 1/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Game.h"

#import "NewsCenter.h"
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
	}
	return self;
}

- (void) dealloc {
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
	[stockCache startUpdating];
}

#pragma mark Accessors

@synthesize portfolio;
@synthesize tradeBook;
@synthesize stockCache;
@synthesize newsCenter;

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

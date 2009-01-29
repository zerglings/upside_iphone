//
//  Game.h
//  upside
//
//  Created by Victor Costan on 1/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Portfolio;
@class StockCache;
@class TradeBook;
@class NewsCenter;
@class GameSyncController;
@class PendingOrdersSubmittingController;
@class ZNTargetActionSet;


@interface Game : NSObject {
	Portfolio* portfolio;
	TradeBook* tradeBook;
	StockCache* stockCache;
	NewsCenter* newsCenter;
	GameSyncController* syncController;
  PendingOrdersSubmittingController* orderSubmittingController;
  ZNTargetActionSet* newDataSite;
}

// The singleton Game instance.
+ (Game*)sharedGame;

#pragma mark Accessors

@property (nonatomic, readonly, retain) Portfolio* portfolio;
@property (nonatomic, readonly, retain) TradeBook* tradeBook;
@property (nonatomic, readonly, retain) StockCache* stockCache;
@property (nonatomic, readonly, retain) NewsCenter* newsCenter;
@property (nonatomic, readonly, retain)
    PendingOrdersSubmittingController* orderSubmittingController;

// Called when new game data becomes available. 
@property (nonatomic, readonly, retain) ZNTargetActionSet* newDataSite;

@end

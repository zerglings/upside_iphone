//
//  Game.h
//  StockPlay
//
//  Created by Victor Costan on 1/6/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AssetBook;
@class GameSyncController;
@class NewsCenter;
@class PendingOrdersSubmittingController;
@class StockCache;
@class TradeBook;
@class ZNTargetActionSet;


// Data making up a player's perspective of the game.
@interface Game : NSObject {
  AssetBook* assetBook;
  TradeBook* tradeBook;

  NewsCenter* newsCenter;
  StockCache* stockCache;

  GameSyncController* syncController;
  PendingOrdersSubmittingController* orderSubmittingController;
  ZNTargetActionSet* newDataSite;
}

// The singleton Game instance.
+(Game*)sharedGame;

#pragma mark Accessors

@property (nonatomic, readonly, retain) AssetBook* assetBook;
@property (nonatomic, readonly, retain) TradeBook* tradeBook;
@property (nonatomic, readonly, retain) StockCache* stockCache;
@property (nonatomic, readonly, retain) NewsCenter* newsCenter;
@property (nonatomic, readonly, retain)
    PendingOrdersSubmittingController* orderSubmittingController;

// Called when new game data becomes available.
@property (nonatomic, readonly, retain) ZNTargetActionSet* newDataSite;

// Called to force a one-time data synchronization now.
-(void)syncData;

// The time of the most recent data sync.
-(NSDate*)lastSyncTime;

@end

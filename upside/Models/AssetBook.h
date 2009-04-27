//
//  AssetBook.h
//  StockPlay
//
//  Created by Victor Costan on 1/3/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Stock.h"

@class Position;
@class Portfolio;
@class PortfolioStat;

// Collection of the user's assets (positions).
@interface AssetBook : NSObject {
  PortfolioStat* dailyStat;
  PortfolioStat* hourlyStat;
  Portfolio* portfolio;
  NSArray* positions;

  NSArray* longPositions;
  NSArray* shortPositions;
}

// General information about a player's portfolio.
@property (nonatomic, readonly, retain) Portfolio* portfolio;

// Portfolio stats (net worth, rank) computed at the beginning of the day.
@property (nonatomic, readonly, retain) PortfolioStat* dailyStat;

// Portfolio stats (net worth, rank) computed at the beginning of the hour.
@property (nonatomic, readonly, retain) PortfolioStat* hourlyStat;

// How much cash in this portfolio.
-(double)cash;

// How many long positions does the player have.
-(NSUInteger)longPositionCount;

// How many short positions does the player have.
-(NSUInteger)shortPositionCount;

// The long position at the given index.
-(Position*)longPositionAtIndex:(NSUInteger)index;

// The short position at the given index.
-(Position*)shortPositionAtIndex:(NSUInteger)index;

// The long position with the given ticker.
-(Position*)longPositionWithTicker:(NSString*)ticker;

// The short position with the given ticker.
-(Position*)shortPositionWithTicker:(NSString*)ticker;

// Reloads the asset book with the given data.
//
// The data should consist of Positions, a Portfolio, and PortfolioStats.
-(void)loadData:(NSArray*)newData;

@end

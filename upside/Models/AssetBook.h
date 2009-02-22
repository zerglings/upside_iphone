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

// Collection of the user's assets (positions).
@interface AssetBook : NSObject {
  Portfolio* portfolio;
	NSArray* positions;
	
	NSArray* longPositions;
	NSArray* shortPositions;
}

// General information about a player's portfolio.
@property (nonatomic, readonly, retain) Portfolio* portfolio;

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
// The data should consist of Positions and a Portfolio.
-(void)loadData:(NSArray*)newPositions;

@end

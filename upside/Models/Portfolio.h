//
//  Portfolio.h
//  upside
//
//  Created by Victor Costan on 1/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Stock.h"

@class Position;

@interface Portfolio : NSObject {
	NSArray* positions;
	
	NSArray* longPositions;
	NSArray* shortPositions;
}

// How many long positions in this portfolio.
- (NSUInteger)longPositionCount;

// How many short positions in this portfolio.
- (NSUInteger)shortPositionCount;

// The long position at the given index.
- (Position*)longPositionAtIndex: (NSUInteger)index;

// The short position at the given index.
- (Position*)shortPositionAtIndex: (NSUInteger)index;

// Reloads the portfolio with the given data.
- (void) loadData: (NSArray*)newPositions;

@end

//
//  Position.h
//  StockPlay
//
//  Created by Victor Costan on 1/22/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ModelSupport.h"

@interface Position : ZNModel {
	NSString* ticker;
	NSUInteger quantity;
	BOOL isLong;
}

// The ticker of the stock held in this position.
@property (nonatomic, readonly, retain) NSString* ticker;

// The number of stocks in this position. 
@property (nonatomic, readonly) NSUInteger quantity;

// YES for long positions, NO for shorts.
@property (nonatomic, readonly) BOOL isLong;

// Convenience initializer for testing.
-(id)initWithTicker: (NSString*)ticker
			 quantity: (NSUInteger)quantity
			   isLong: (BOOL)isLong;

// Comparator for sorting positions.
-(NSComparisonResult)compare: (Position*)other;

@end

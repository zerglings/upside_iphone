//
//  Portfolio.m
//  Upside
//
//  Created by Victor Costan on 1/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Portfolio.h"

#import "Position.h"

@interface Portfolio ()
- (void) loadMockData;
@end

@implementation Portfolio

#pragma mark I/O

- (void) load {
	[self loadMockData];
}

- (void) save {
}

#pragma mark Data Processing

+ (NSArray*) selectPositions: (NSArray*)positions isLong: (BOOL)isLong {
	NSMutableArray* selectedPositions = [[NSMutableArray alloc] init];
	for (Position* position in positions) {
		if ([position isLong] == isLong)
			[selectedPositions addObject:position];
	}
	NSArray* returnVal = [[NSArray alloc] initWithArray:selectedPositions];
	[selectedPositions release];
	return returnVal;
}

- (void) loadData: (NSArray*)newPositions {
	[positions release];
	[longPositions release];
	[shortPositions release];
	
	positions =
	    [[newPositions sortedArrayUsingSelector:@selector(compare:)]
		 retain];
	
	longPositions = [Portfolio selectPositions:positions isLong:YES];
	shortPositions = [Portfolio selectPositions:positions isLong:NO];
}

#pragma mark Testing


- (void) loadMockData {
	[self loadData:[NSArray arrayWithObjects:
					[[[Position alloc] initWithTicker:@"AAPL"
											 quantity:10000
											   isLong:YES] autorelease],
					[[[Position alloc] initWithTicker:@"GOOG"
											 quantity:31415
											   isLong:YES] autorelease],
					[[[Position alloc] initWithTicker:@"MSFT"
											 quantity:666
											   isLong:NO] autorelease],
					nil]];
}

#pragma mark Lifecycle

- (id)init {
	if ((self = [super init])) {
		[self load];
	}
	return self;
}

- (void)dealloc {
	[positions release];
	[longPositions release];
	[shortPositions release];
	[super dealloc];
}

#pragma mark Accessors

- (NSUInteger)longPositionCount {
	return [longPositions count];
}

- (NSUInteger)shortPositionCount {
	return [shortPositions count];
}

- (Position*)longPositionAtIndex: (NSUInteger)index {
	return [longPositions objectAtIndex:index];
}

- (Position*)shortPositionAtIndex: (NSUInteger)index {
	return [shortPositions objectAtIndex:index];
}

@end

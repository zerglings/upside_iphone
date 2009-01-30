//
//  AssetBook.m
//  Upside
//
//  Created by Victor Costan on 1/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AssetBook.h"

#import "Portfolio.h"
#import "Position.h"

@implementation AssetBook

#pragma mark I/O

- (void)load {
  // TODO(overmind): implement I/O
}

- (void)save {
  // TODO(overmind): implement I/O
}

#pragma mark Synchronizing

+ (NSArray*)copyObjects: (NSArray*)array
                  where: (SEL)predicate
                     is: (id)predicateValue {
	NSMutableArray* selectedPositions = [[NSMutableArray alloc] init];
  for (NSObject* object in array) {
    if ([object performSelector:predicate] == predicateValue)
			[selectedPositions addObject:object];
  }
	NSArray* returnVal = [[NSArray alloc] initWithArray:selectedPositions];
	[selectedPositions release];
	return returnVal;
}

- (void)loadData: (NSArray*)newPositions {
  NSArray* portfolios = [AssetBook copyObjects:newPositions
                                         where:@selector(class)
                                            is:[Portfolio class]];
  [portfolio release];
  if ([portfolios count] > 0) {
    portfolio = [[portfolios objectAtIndex:0] retain];
    [portfolios release];    
  }
  else
    portfolio = nil;
	
  NSArray* rawPositions = [AssetBook copyObjects:newPositions
                                           where:@selector(class)
                                              is:[Position class]];
  [positions release];
  positions = [[rawPositions sortedArrayUsingSelector:@selector(compare:)]
               retain];
  [rawPositions release];
  
  [longPositions release];
	longPositions = [AssetBook copyObjects:positions
                                   where:@selector(isLong)
                                      is:(id)YES];
  [shortPositions release];
	shortPositions = [AssetBook copyObjects:positions
                                    where:@selector(isLong)
                                       is:(id)NO];
}

#pragma mark Lifecycle

- (id)init {
	if ((self = [super init])) {
		[self load];
	}
	return self;
}

- (void)dealloc {
  [portfolio release];
	[positions release];
	[longPositions release];
	[shortPositions release];
	[super dealloc];
}

#pragma mark Accessors

@synthesize portfolio;

- (double)cash {
  return [portfolio cash];
}

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

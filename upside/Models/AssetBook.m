//
//  AssetBook.m
//  Upside
//
//  Created by Victor Costan on 1/3/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "AssetBook.h"

#import "Portfolio.h"
#import "PortfolioStat.h"
#import "Position.h"

@implementation AssetBook

#pragma mark I/O

-(void)load {
  // TODO(overmind): implement I/O
}

-(void)save {
  // TODO(overmind): implement I/O
}

#pragma mark Synchronizing

+(NSArray*)copyObjects:(NSArray*)array
                  where:(SEL)predicate
                     is:(id)predicateValue {
  NSMutableArray* selectedPositions = [[NSMutableArray alloc] init];
  for (NSObject* object in array) {
    if ([object performSelector:predicate] == predicateValue)
      [selectedPositions addObject:object];
  }
  NSArray* returnVal = [[NSArray alloc] initWithArray:selectedPositions];
  [selectedPositions release];
  return returnVal;
}

-(void)loadData:(NSArray*)newData {
  NSArray* portfolios = [AssetBook copyObjects:newData
                                         where:@selector(class)
                                            is:[Portfolio class]];
  [portfolio release];
  if ([portfolios count] > 0) {
    portfolio = [[portfolios objectAtIndex:0] retain];
  }
  else
    portfolio = nil;
  [portfolios release];

  NSArray* stats = [AssetBook copyObjects:newData
                                    where:@selector(class)
                                       is:[PortfolioStat class]];
  for (PortfolioStat* stat in stats) {
    if ([stat isDaily]) {
      [stat retain];
      [dailyStat release];
      dailyStat = stat;
    }
    else if ([stat isHourly]) {
      [stat retain];
      [hourlyStat release];
      hourlyStat = stat;
    }
  }
  [stats release];

  NSArray* rawPositions = [AssetBook copyObjects:newData
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

-(id)init {
  if ((self = [super init])) {
    [self load];
  }
  return self;
}

-(void)dealloc {
  [portfolio release];
  [positions release];
  [longPositions release];
  [shortPositions release];
  [super dealloc];
}

#pragma mark Accessors

@synthesize portfolio, dailyStat, hourlyStat;

-(double)cash {
  return [portfolio cash];
}

-(NSUInteger)longPositionCount {
  return [longPositions count];
}

-(NSUInteger)shortPositionCount {
  return [shortPositions count];
}

-(Position*)longPositionAtIndex:(NSUInteger)index {
  return [longPositions objectAtIndex:index];
}

-(Position*)shortPositionAtIndex:(NSUInteger)index {
  return [shortPositions objectAtIndex:index];
}

+(Position*)positionWithTicker:(NSString*)ticker in:(NSArray*)positions {
  for (Position* position in positions) {
    if ([position.ticker isEqualToString:ticker])
      return position;
  }
  return nil;
}

-(Position*)longPositionWithTicker:(NSString*)ticker {
  return [AssetBook positionWithTicker:ticker in:longPositions];
}

// The short position with the given ticker.
-(Position*)shortPositionWithTicker:(NSString*)ticker {
  return [AssetBook positionWithTicker:ticker in:shortPositions];
}


@end

//
//  PortfolioStat.m
//  upside
//
//  Created by Victor Costan on 4/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PortfolioStat.h"

// Frequency keyword indicating daily stats.
NSString* kPortfolioStatsFrequencyDaily = @"daily";

// Frequency keyword indicating hourly stats.
NSString* kPortfolioStatsFrequencyHourly = @"hourly";

@implementation PortfolioStat

@synthesize networth, rank, frequency;

-(BOOL)isDaily {
  return [frequency isEqualToString:kPortfolioStatsFrequencyDaily];
}
-(BOOL)isHourly {
  return [frequency isEqualToString:kPortfolioStatsFrequencyHourly];  
}

@end

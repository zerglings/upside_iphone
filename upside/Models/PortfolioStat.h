//
//  PortfolioStat.h
//  upside
//
//  Created by Victor Costan on 4/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ModelSupport.h"


// Mirrors server-side PortfolioStat model.
@interface PortfolioStat : ZNModel {
  NSString* frequency;  
  double netWorth;
  NSUInteger rank;
}

// The portfolio's net worth, computed based on all assets in the portfolio.
@property (nonatomic, readonly) double netWorth;

// The portfolio's rank among all portfolios in the game, based on networth.
@property (nonatomic, readonly) NSUInteger rank;

// The frequency that this statistic is updated with.
@property (nonatomic, readonly, retain) NSString* frequency;


#pragma mark Convenience Accessors

// YES if these statistics are computed daily.
-(BOOL)isDaily;

// YES if these statistics are computed hourly.
-(BOOL)isHourly;
@end

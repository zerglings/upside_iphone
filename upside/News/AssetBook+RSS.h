//
//  AssetBook+RSS.h
//  StockPlay
//
//  Created by Victor Costan on 1/10/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "AssetBook.h"

@class NewsCenter;

@interface AssetBook (RSS)

+(NSString*)rssFeedUrlForTicker: (NSString*)ticker;

+(NSString*)rssFeedTitleForTicker: (NSString*)ticker;

-(void)loadRssFeedsIntoCenter: (NewsCenter*)newsCenter;

@end

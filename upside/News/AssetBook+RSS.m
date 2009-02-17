//
//  AssetBook+RSS.m
//  StockPlay
//
//  Created by Victor Costan on 1/10/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "AssetBook+RSS.h"

#import "NewsCenter.h"
#import "Position.h"

@implementation AssetBook (RSS)

+(NSString*)rssFeedUrlForTicker:(NSString*)ticker {
	NSInteger rating = 3;
	NSInteger newsCount = 20;
	return [NSString stringWithFormat:
			@"http://finance.google.com/finance?morenews=%d&rating=%d&q=%@&output=rss",
			newsCount, rating, ticker];
}

+(NSString*)rssFeedTitleForTicker:(NSString*)ticker {
	return [NSString stringWithFormat:@"Stock %@", ticker];
}

-(void)loadRssFeedsIntoCenter:(NewsCenter*)newsCenter {
	for(Position* position in positions) {
		NSString* ticker = [position ticker];
		[newsCenter addTitle:[AssetBook rssFeedTitleForTicker:ticker]
					 withUrl:[AssetBook rssFeedUrlForTicker:ticker]
				  andRefresh:60];
	}
}

@end

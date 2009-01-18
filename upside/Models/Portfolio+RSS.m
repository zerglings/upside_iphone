//
//  Portfolio+RSS.m
//  upside
//
//  Created by Victor Costan on 1/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Portfolio.h"
#import "Portfolio+RSS.h"

#import "NewsCenter.h"

@implementation Portfolio (RSS)

+ (NSString*) rssFeedUrlForTicker: (NSString*)ticker {
	NSInteger rating = 3;
	NSInteger newsCount = 20;
	return [NSString stringWithFormat:
			@"http://finance.google.com/finance?morenews=%d&rating=%d&q=%@&output=rss",
			newsCount, rating, ticker];
}

+ (NSString*) rssFeedTitleForTicker: (NSString*)ticker {
	return [NSString stringWithFormat:@"Stock %@", ticker];
}

- (void) loadRssFeedsIntoCenter: (NewsCenter*)newsCenter {
	for(NSString* ticker in stockTickers) {
		[newsCenter addTitle:[Portfolio rssFeedTitleForTicker:ticker]
					 withUrl:[Portfolio rssFeedUrlForTicker:ticker]
				  andRefresh:60];
	}
}

@end

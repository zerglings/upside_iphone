//
//  AssetBook+RSS.h
//  upside
//
//  Created by Victor Costan on 1/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AssetBook.h"

@class NewsCenter;

@interface AssetBook (RSS)

+ (NSString*) rssFeedUrlForTicker: (NSString*)ticker;

+ (NSString*) rssFeedTitleForTicker: (NSString*)ticker;

- (void) loadRssFeedsIntoCenter: (NewsCenter*)newsCenter;

@end

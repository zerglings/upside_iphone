//
//  Portfolio+RSS.h
//  upside
//
//  Created by Victor Costan on 1/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NewsCenter;

@interface Portfolio (RSS)

+ (NSString*) rssFeedUrlForTicker: (NSString*)ticker;

+ (NSString*) rssFeedTitleForTicker: (NSString*)ticker;

- (void) loadRssFeedsIntoCenter: (NewsCenter*)newsCenter;

@end

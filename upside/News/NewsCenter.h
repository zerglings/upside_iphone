//
//  NewsCenter.h
//  upside
//
//  Created by Victor Costan on 1/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NewsItem;

@interface NewsCenter : NSObject {
	NSMutableDictionary* dataByTitle;
	NSMutableDictionary* newsByUid;
}

- (void) addTitle: (NSString*)title
		  withUrl: (NSString*)urlString
	   andRefresh: (NSTimeInterval)refreshInterval;

- (void) removeTitle: (NSString*) title;

- (NSUInteger) totalNewsForTitle: (NSString*) title;

- (NSUInteger) unreadNewsForTitle: (NSString*) title;

- (NewsItem*) newsItemForTitle: (NSString*)title atIndex: (NSUInteger)index;

- (void) markAsReadItemWithId: (NSString*)uid;

- (void) integrateNews: (NSArray*)news forTitle: (NSString*)title;

@end

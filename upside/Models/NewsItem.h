//
//  RssNewsItem.h
//  upside
//
//  Created by Victor Costan on 1/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DictionaryBackedModel.h"

@interface NewsItem : DictionaryBackedModel {
}

#pragma mark Convenience Constructors

- (id) initWithTitle: (NSString*)title
				date: (NSDate*)date
				 url: (NSURL*)url
				 uid: (NSString*)uid
			 summary: (NSString*)summary;

- (id) initWithRssItem: (NSDictionary*)rssItem;

#pragma mark Accessors
	
// The news' title.
- (NSString*) title;

// The date when the news was published.
- (NSDate*) date;

// An URL with the news' entire contents.
- (NSURL*) url;

// An unique ID for the news.
- (NSString*) uid;

// Summary for the news.
- (NSString*) summary;

@end
	
#pragma mark News Item Properties Keys
	
// An NSString with the item's title.
const NSString* kNewsItemTitle;

// An NSDate with the date when the item was published.
const NSString* kNewsItemDate;

// An NSURL with the URL of the full article associated with the item.
const NSString* kNewsItemUrl;

// An NSString with a unique id for the news item.
const NSString* kNewsItemUid;

// An NSString with the item's summary.
const NSString* kNewsItemSummary;

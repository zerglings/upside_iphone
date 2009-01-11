//
//  RssNewsItem.m
//  upside
//
//  Created by Victor Costan on 1/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NewsItem.h"

#import "DictionaryXmlParser.h"


@implementation NewsItem

#pragma mark Convenience Constructors

- (id) initWithTitle: (NSString*)title
				date: (NSDate*)date
				 url: (NSURL*)url
				 uid: (NSString*)uid
			 summary: (NSString*)summary {
	props = [NSDictionary dictionaryWithObjectsAndKeys:
			 title, kNewsItemTitle,
			 date, kNewsItemDate,
			 url, kNewsItemUrl,
			 uid, kNewsItemUid,
			 summary, kNewsItemSummary,
			 nil];
	return [super initWithProperties:props];
}

- (id) initWithRssItem: (NSDictionary*)rssItem {
	NSString* title = [rssItem objectForKey:kNewsItemTitle];
	if (!title)
		title = @"";
	NSDate* date = [NSDate dateWithNaturalLanguageString:
					[rssItem objectForKey:kNewsItemDate]];
	if (!date)
		date = [NSDate date];
	NSURL* url = [NSURL URLWithString:[rssItem objectForKey:kNewsItemUrl]];
	NSString* uid = [rssItem objectForKey:kNewsItemUid];
	NSString* summary = [rssItem objectForKey:kNewsItemSummary];
	
	return [super initWithProperties:[NSDictionary dictionaryWithObjectsAndKeys:
									  uid, kNewsItemUid,
									  title, kNewsItemTitle,
									  date, kNewsItemDate,
									  url, kNewsItemUrl,
									  summary, kNewsItemSummary,
									  nil]];
}

#pragma mark Accessors

- (NSString*) title {
	return [props objectForKey:kNewsItemTitle];
}
- (NSDate*) date {
	return [props objectForKey:kNewsItemDate];
}
- (NSURL*) url {
	return [props objectForKey:kNewsItemUrl];
}
- (NSString*) uid {
	return [props objectForKey:kNewsItemUid];
}
- (NSString*) summary {
	return [props objectForKey:kNewsItemSummary];
}

@end

#pragma mark News Item Properties Keys

const NSString* kNewsItemTitle = @"title";
const NSString* kNewsItemDate = @"pubDate";
const NSString* kNewsItemUrl = @"link";
const NSString* kNewsItemUid = @"guid";
const NSString* kNewsItemSummary = @"description";

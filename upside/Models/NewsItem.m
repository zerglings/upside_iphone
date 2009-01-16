//
//  NewsItem.m
//  upside
//
//  Created by Victor Costan on 1/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NewsItem.h"

@implementation NewsItem

@synthesize title, pubDate, guid, description, link;

@synthesize isRead;

- (void) dealloc {
	[title release];
	[pubDate release];
	[guid release];
	[description release];
	[link release];
	[super dealloc];
}

- (id) initWithItem: (NewsItem*)item markAsRead: (BOOL)isReadValue {
	NSMutableDictionary* attrs = [item
								  copyToMutableDictionaryForcingStrings:NO];
	[attrs setObject:[NSNumber numberWithBool:isReadValue] forKey:@"isRead"];
	NewsItem* newItem = [[NewsItem alloc] initWithProperties:attrs];
	[attrs release];
	return newItem;
}

@end
//
//  NewsItem.m
//  upside
//
//  Created by Victor Costan on 1/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NewsItem.h"

@interface NewsItem ()
@property (nonatomic) BOOL isRead;
@end

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
	if ((self = [self initWithModel:item])) {
		isRead = isReadValue;
	}
	return self;
}

@end

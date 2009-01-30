//
//  NewsItem.h
//  upside
//
//  Created by Victor Costan on 1/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ModelSupport.h"


// A single piece of news.
@interface NewsItem : ZNModel {
	NSString* title;
	NSDate* pubDate;
	NSString* guid;
	NSString* description;

	// TODO(overmind): allow this to be a NSURL
	NSString* link;	
	
	BOOL isRead;
}

// The news' title.
@property (nonatomic, readonly, retain) NSString* title;

// The date when the news was published.
@property (nonatomic, readonly, retain, getter=date) NSDate* pubDate;

// An unique ID for the news.
@property (nonatomic, readonly, retain, getter=uid) NSString* guid;

// Summary for the news.
@property (nonatomic, readonly, retain, getter=summary) NSString* description;

// An URL with the news' entire contents.
@property (nonatomic, readonly, retain, getter=url) NSString* link;

// YES if the item has been read.
@property (nonatomic, readonly) BOOL isRead;


- (id) initWithItem: (NewsItem*)item markAsRead: (BOOL)isRead;

@end

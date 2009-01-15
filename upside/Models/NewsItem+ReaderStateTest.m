//
//  NewsItem+ReaderStateTest.m
//  upside
//
//  Created by Victor Costan on 1/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "GTMSenTestCase.h"

#import "NewsItem.h"
#import "NewsItem+ReaderState.h"


@interface NewsItemReaderStateTest : SenTestCase {
	NewsItem* unreadItem;
}

@end

@implementation NewsItemReaderStateTest

- (void) setUp {
	unreadItem = [[NewsItem alloc] initWithTitle:@"Title1"
											date:[NSDate date]
											 url:[NSURL URLWithString:@"file://rss.xml"]
											 uid:@"st-1"
										 summary:@"Nothing exciting today."];
}

- (void) tearDown {
	[unreadItem release];
}

- (void) testDefaultIsUnread {
	STAssertEquals(NO, [unreadItem isRead],
				   @"Items should be marked unread by default");
}

- (void) testInitMarkAsRead {
	NewsItem* unreadItem2 = [[NewsItem alloc] initWithItem:unreadItem
												markAsRead:NO];
	STAssertEquals(NO, [unreadItem2 isRead],
				   @"-initWithItem:markAsRead: to mark unread item");
	
	NewsItem* readItem = [[NewsItem alloc] initWithItem:unreadItem
											 markAsRead:YES];
	STAssertEquals(YES, [readItem isRead],
				   @"-initWithItem:markAsRead: to mark read item");
	
	STAssertEqualStrings([unreadItem title], [readItem title],
						 @"-initWithItem:markAsRead: preserves title");
	STAssertEqualStrings([unreadItem summary], [readItem summary],
						 @"-initWithItem:markAsRead: preserves summary");
	STAssertEqualStrings([unreadItem uid], [readItem uid],
						 @"-initWithItem:markAsRead: preserves uid");
	STAssertEqualObjects([unreadItem date], [readItem date],
						 @"-initWithItem:markAsRead: preserves date");
}

@end

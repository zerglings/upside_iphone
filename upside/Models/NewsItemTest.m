//
//  NewsItemTest.m
//  StockPlay
//
//  Created by Victor Costan on 1/10/09.
//  Copyright Zergling.Net. All rights reserved.
//


#import "TestSupport.h"

#import "NewsItem.h"

@interface NewsItemTest : SenTestCase {
	NewsItem* unreadItem;
}

@end

@implementation NewsItemTest

-(void)setUp {
	unreadItem = [[NewsItem alloc] initWithProperties:
				   [NSDictionary dictionaryWithObjectsAndKeys:
					@"Title1", @"title",
					@"2008-12-01 12:30:05 -0500", @"pubDate",
					@"file://rss.xml", @"link",
					@"st-1", @"guid",
					@"Nothing exciting today.", @"description",
					nil]];
}

-(void)tearDown {
	[unreadItem release];
}

-(void)dealloc {
	[super dealloc];
}

-(void)testDefaultIsUnread {
	STAssertEquals(NO, [unreadItem isRead],
				   @"Items should be marked unread by default");
}

-(void)testInitMarkAsRead {
	NewsItem* unreadItem2 = [[NewsItem alloc] initWithItem:unreadItem
												markAsRead:NO];
	STAssertEquals(NO, [unreadItem2 isRead],
				   @"-initWithItem:markAsRead: to mark unread item");
	
	[unreadItem2 release];
	
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
	
	[readItem release];
}

@end

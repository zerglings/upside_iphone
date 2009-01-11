//
//  NewsCenterTest.m
//  upside
//
//  Created by Victor Costan on 1/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GTMSenTestCase.h"

#import "NewsItem.h"
#import "NewsCenter.h"


@interface NewsCenterTest : SenTestCase {
	NewsCenter* newsCenter;
	NewsItem* item1;
	NewsItem* item2;
	NewsItem* item3;
}

@end

@implementation NewsCenterTest

- (void) setUp {
	newsCenter = [[NewsCenter alloc] init];
	
	NSURL* badUrl = [NSURL URLWithString:@"http://127.0.0.1/bad.bad"];
	[newsCenter addTitle:@"misc" withUrl:badUrl andRefresh:1.0];
	[newsCenter addTitle:@"test" withUrl:badUrl andRefresh:1.0];
	
	item1 = [[NewsItem alloc] initWithTitle:@"First Title"
									   date:[NSDate date]
										url:badUrl
										uid:@"unittest-1" 
									summary:@"First description."];
	item2 = [[NewsItem alloc] initWithTitle:@"First Title"
									   date:[NSDate date]
										url:badUrl
										uid:@"unittest-2" 
									summary:@"Second description."];
	item3 = [[NewsItem alloc] initWithTitle:@"First Title"
									   date:[NSDate date]
										url:badUrl
										uid:@"unittest-3" 
									summary:@"Third description."];
}

- (void) testTotalAndUnreadCount {
	[newsCenter integrateNews:[NSArray arrayWithObjects:
							   item1, item2, item3, nil]
					 forTitle:@"misc"];
	STAssertEquals(3U, [newsCenter totalNewsForTitle:@"misc"],
				   @"-totalNewsForTitle: on freshly added stories");
	STAssertEquals(0U, [newsCenter totalNewsForTitle:@"test"],
				   @"-totalNewsForTitle: on empty stories");
	
	STAssertEquals(3U, [newsCenter unreadNewsForTitle:@"misc"],
				   @"-unreadNewsForTitle: on freshly added stories");
	[newsCenter markAsRead:[item1 uid]];
	STAssertEquals(2U, [newsCenter unreadNewsForTitle:@"misc"],
				   @"-unreadNewsForTitle: after -markAsRead");
}

- (void) testIntegrate {
	[newsCenter integrateNews:[NSArray arrayWithObjects:item2, item1, nil]
					 forTitle:@"misc"];
	[newsCenter markAsRead:[item2 uid]];
	STAssertEquals(2U, [newsCenter totalNewsForTitle:@"misc"],
				   @"-totalNewsForTitle: on freshly added stories");
	STAssertEquals(1U, [newsCenter unreadNewsForTitle:@"misc"],
				   @"-unreadNewsTitle: after -markAsRead");
	
	[newsCenter integrateNews:[NSArray arrayWithObjects:item3, item2, nil]
					 forTitle:@"misc"];
	STAssertEquals(2U, [newsCenter totalNewsForTitle:@"misc"],
				   @"-totalNewsForTitle: 2nd integrate with 1 add 1 delete");
	STAssertEquals(1U, [newsCenter unreadNewsForTitle:@"misc"],
				   @"2nd integrate should preseve read status");
	STAssertEqualStrings(item3.title,
						 [newsCenter newsItemForTitle:@"misc" atIndex:0].title,
						 @"2nd integrate respects news order");
	STAssertEqualStrings(item2.title,
						 [newsCenter newsItemForTitle:@"misc" atIndex:1].title,
						 @"2nd integrate respects news order");
}

- (void) checkRssData {
	 STAssertEquals(3U, [newsCenter totalNewsForTitle:@"local"],
					@"Didn't parse all the items");
	 
	 NewsItem* firstItem = [newsCenter newsItemForTitle:@"local" atIndex:0];
	 STAssertEqualStrings(@"Verizon Picks Microsoft Search over Google, Yahoo",
						  [firstItem title],
						  @"Title check for the first article");
	 STAssertEqualObjects([NSURL URLWithString:
						  @"http://www.eweek.com/c/a/Search-Engines/Verizon-Picks-Microsoft-Search-over-Google-Yahoo/"],
						  [firstItem url],
						  @"URL check for the first article");
	 
	 NewsItem* secondItem = [newsCenter newsItemForTitle:@"local" atIndex:1];
	 STAssertEqualStrings(@"tag:finance.google.com,cluster:1287774134",
						  [secondItem uid],
						  @"ID check for the first article");	
	 STAssertEqualObjects([NSDate
						   dateWithNaturalLanguageString: @"Wed, 07 Jan 2009 23:31:25 GMT"],
						  [secondItem date],
						  @"Date check for the first article");
	 
	 NewsItem* thirdItem = [newsCenter newsItemForTitle:@"local" atIndex:2];
	 STAssertEqualStrings(@"Google Sued by Model Over 'Skank' Comment",
						  [thirdItem title],
						  @"Title with escaped XML entities");		 
}

- (void) testFetching {
	NSString *filePath = [[[NSBundle mainBundle] resourcePath]
						  stringByAppendingPathComponent:
						  @"NewsCenterTest.xml"];
	
	[newsCenter addTitle:@"local" withUrl:[NSURL fileURLWithPath:filePath]
			  andRefresh:1.0];
	[[NSRunLoop currentRunLoop]
	 runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
	
	[self checkRssData];
}

@end
//
//  Portfolio+RSSTest.m
//  upside
//
//  Created by Victor Costan on 1/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TestSupport.h"

#import "NewsCenter.h"
#import "Portfolio+RSS.h"
#import "Position.h"


@interface PortfolioRSSTest : SenTestCase {
	Portfolio* portfolio;
	NewsCenter* newsCenter;
}
@end

@implementation PortfolioRSSTest

- (void) setUp {
	portfolio = [[Portfolio alloc] init];
	[portfolio loadData:[NSArray arrayWithObjects:
						 [[[Position alloc] initWithTicker:@"MSFT"
												  quantity:666
													isLong:YES] autorelease],
						 nil]];
	newsCenter = [[NewsCenter alloc] init];
}

- (void) tearDown {
	[portfolio release];
	[newsCenter release];
}

- (void) dealloc {
	[super dealloc];
}

- (void) testSetup {
	[portfolio loadRssFeedsIntoCenter:newsCenter];
	NSString* title = [Portfolio rssFeedTitleForTicker:@"MSFT"];
	
	while(true) {
		[[NSRunLoop currentRunLoop]
		 runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
		
		if ([newsCenter unreadNewsForTitle:title] != 0)
			break;
	}
	
	STAssertEquals(20U, [newsCenter unreadNewsForTitle:title],
				   @"RSS setup fetches the expected number of articles");
}

@end

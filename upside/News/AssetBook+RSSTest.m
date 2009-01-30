//
//  AssetBook+RSSTest.m
//  upside
//
//  Created by Victor Costan on 1/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TestSupport.h"

#import "AssetBook+RSS.h"
#import "NewsCenter.h"
#import "Position.h"


@interface AssetBookRSSTest : SenTestCase {
	AssetBook* assetBook;
	NewsCenter* newsCenter;
}
@end

@implementation AssetBookRSSTest

- (void) setUp {
	assetBook = [[AssetBook alloc] init];
	[assetBook loadData:[NSArray arrayWithObjects:
						 [[[Position alloc] initWithTicker:@"MSFT"
												  quantity:666
													isLong:YES] autorelease],
						 nil]];
	newsCenter = [[NewsCenter alloc] init];
}

- (void) tearDown {
	[assetBook release];
	[newsCenter release];
}

- (void) dealloc {
	[super dealloc];
}

- (void) testSetup {
	[assetBook loadRssFeedsIntoCenter:newsCenter];
	NSString* title = [AssetBook rssFeedTitleForTicker:@"MSFT"];
	
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

//
//  NewsCenter.m
//  upside
//
//  Created by Victor Costan on 1/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NewsCenter.h"

#import "DictionaryXmlParser.h"
#import "NetworkProgress.h"
#import "NewsItem.h"
#import "NewsItem+ReaderState.h"

#pragma mark Internal Data Structure

@interface NewsCenterData : NSObject {
	NewsCenter* newsCenter;
	NSString* title;
	NSURL* url;
	NSTimeInterval refreshInterval;
	NSArray* uids;
	BOOL removed;
}

// The title of this RSS feed.
@property (nonatomic, assign) NewsCenter* newsCenter;

// The title of this RSS feed.
@property (nonatomic, retain) NSString* title;

// The URL for the RSS feed.
@property (retain) NSURL* url;

// The amount of time to wait between refreshes.
@property (assign) NSTimeInterval refreshInterval;

// The UIDs of the articles in the RSS feed.
@property (nonatomic, retain) NSArray* uids;

// Set to YES when a feed is removed.
@property (assign) BOOL removed;

@end

@implementation NewsCenterData

@synthesize newsCenter;
@synthesize title;
@synthesize url;
@synthesize refreshInterval;
@synthesize removed;
@synthesize uids;

- (void) dealloc {
	[title release];
	[url release];
	[uids release];
	[super dealloc];
}

- (void) integrateNews: (NSArray*)news {
	[newsCenter integrateNews:news forTitle:title];
}

@end


#pragma mark Private Methods

@interface NewsCenter () <DictionaryXmlParserDelegate>

- (void) startFetchingNewsFor: (NewsCenterData*)feedData;

@end

@implementation NewsCenter

#pragma mark Lifecycle

- (id) init {
	if ((self = [super init])) {
		dataByTitle = [[NSMutableDictionary alloc] init];
		newsByUid = [[NSMutableDictionary alloc] init];
	}
	return self;
}
- (void) dealloc {
	[dataByTitle release];
	for (NewsCenterData* data in [dataByTitle allValues]) {
		data.removed = YES;
	}
	[newsByUid release];
	[super dealloc];
}

- (void) addTitle: (NSString*)title
		  withUrl: (NSURL*)url
	   andRefresh: (NSTimeInterval)refreshInterval {
	NewsCenterData* data = [dataByTitle objectForKey:title];
	if (data != nil) {
		data.url = url;
		data.refreshInterval = refreshInterval;
		return;
	}
	
	data = [[NewsCenterData alloc] init];
	data.newsCenter = self;
	data.title = title;
	data.url = url;
	data.refreshInterval = refreshInterval;
	data.removed = NO;
	data.uids = [NSArray array];
	[dataByTitle setObject:data forKey:title];
	[self startFetchingNewsFor:data];
}

- (void) removeTitle: (NSString*) title {
	NewsCenterData* data = [dataByTitle objectForKey:title];
	if (data != nil) {
		data.removed = YES;
		for(NSString* uid in data.uids) {
			[newsByUid removeObjectForKey:uid];
		}
		[dataByTitle removeObjectForKey:title];
	}
}

- (NSUInteger) totalNewsForTitle: (NSString*) title {
	return [[[dataByTitle objectForKey:title] uids] count];
}

- (NSUInteger) unreadNewsForTitle: (NSString*) title {
	NSUInteger unread = 0;
	for (NSString* uid in [[dataByTitle objectForKey:title] uids]) {
		unread += [(NewsItem*)[newsByUid objectForKey:uid] isRead] ? 0 : 1;
	}
	return unread;
}

- (NewsItem*) newsItemForTitle: (NSString*)title atIndex: (NSUInteger)index {
	NewsCenterData* data = [dataByTitle objectForKey:title];
	return [newsByUid objectForKey:[data.uids objectAtIndex:index]];
}

- (void) markAsReadItemWithId: (NSString*) uid {
	[newsByUid setObject:[[NewsItem alloc] initWithItem:[newsByUid
														 objectForKey:uid]
											 markAsRead:YES]
				  forKey:uid];
}

- (void) integrateNews: (NSArray*)news forTitle: (NSString*)title {
	NewsCenterData* data = [dataByTitle objectForKey:title];
	
	NSMutableSet* oldUids = [[NSMutableSet alloc] initWithArray:data.uids];
	NSMutableArray* newUids = [[NSMutableArray alloc]
							   initWithCapacity:[news count]];
	
	for (NewsItem* newsItem in news) {
		NSString* uid = newsItem.uid;
		[newUids addObject:uid];
		
		if ([oldUids containsObject:uid]) {
			[oldUids removeObject:uid];
		}
		else {
			[newsByUid setObject:newsItem forKey:uid];
		}
	}
	for(NSString* uid in oldUids) {
		[newsByUid removeObjectForKey:uid];
	}
	data.uids = [NSArray arrayWithArray:newUids];
	[newUids release];
	[oldUids release];
}

#pragma mark RSS Reading

static NSDictionary* rssParserSchema = nil;

+ (NSDictionary*) rssParserSchema {
	@synchronized ([NewsCenter class]) {
		if (rssParserSchema == nil) {
			rssParserSchema = [[NSDictionary alloc] initWithObjectsAndKeys:
							   [[NSSet alloc] initWithObjects:
							    kNewsItemDate, kNewsItemSummary, kNewsItemTitle,
								kNewsItemUid, kNewsItemUrl, nil],
							   @"item",
							   nil];
		}
	}
	return rssParserSchema;
}

- (void) parsedItem: (NSDictionary*)itemData
		   withName: (NSString*)itemName
				for: (NSObject*)context {
	[(NSMutableArray*)context addObject:[[NewsItem alloc]
										 initWithRssItem:itemData]];
}

- (void) feedFetcherThreadMain: (NewsCenterData*)feedData {
	NSAutoreleasePool* outerArp = [[NSAutoreleasePool alloc] init];
	
	NSMutableArray* newsItems = [[NSMutableArray alloc] init];
	DictionaryXmlParser* rssParser = [[DictionaryXmlParser alloc]
									  initWithSchema:
									  [NewsCenter rssParserSchema]];
	rssParser.context = newsItems;
	rssParser.delegate = self;
	
	while (!feedData.removed) {
		NSAutoreleasePool* arp = [[NSAutoreleasePool alloc] init];
		NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
				
		NSDate* sleepTimeout =
		    [NSDate dateWithTimeIntervalSinceNow:feedData.refreshInterval];
		[NetworkProgress connectionStarted];
		BOOL parsingWorked = [rssParser parseURL:feedData.url];
		[NetworkProgress connectionDone];
		if (parsingWorked) {		
			[feedData performSelectorOnMainThread:@selector(integrateNews:)
									   withObject:newsItems
									waitUntilDone:YES];
		}
		[newsItems removeAllObjects];
		[NSThread sleepUntilDate:sleepTimeout];
		//[runLoop runUntilDate:sleepTimeout];
		 
		[arp release];
	}
	[outerArp release];
	[feedData release];
}

- (void) startFetchingNewsFor: (NewsCenterData*)feedData {
	[feedData retain];
	[NSThread detachNewThreadSelector:@selector(feedFetcherThreadMain:)
							 toTarget:self
						   withObject:feedData];
}

@end

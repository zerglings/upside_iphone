//
//  NewsCenter.m
//  StockPlay
//
//  Created by Victor Costan on 1/10/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "NewsCenter.h"

#import "ModelSupport.h"
#import "WebSupport.h"

#import "NetworkProgress.h"
#import "NewsItem.h"

@interface NewsCenter ()
+(NSDictionary*)rssModels;
@end

#pragma mark Internal Data Structure

@interface NewsCenterFeed : NSObject {
  NewsCenter* newsCenter;
  NSString* title;
  NSString* urlString;
  NSTimeInterval refreshInterval;
  NSArray* uids;
  BOOL removed;
}

// The title of this RSS feed.
@property (nonatomic, assign) NewsCenter* newsCenter;

// The title of this RSS feed.
@property (nonatomic, retain) NSString* title;

// The URL for the RSS feed.
@property (nonatomic, retain) NSString* urlString;

// The amount of time to wait between refreshes.
@property (nonatomic, assign) NSTimeInterval refreshInterval;

// The UIDs of the articles in the RSS feed.
@property (nonatomic, retain) NSArray* uids;

// Set to YES when a feed is removed.
@property (nonatomic, assign) BOOL removed;

@end

@implementation NewsCenterFeed

@synthesize newsCenter, title, urlString, refreshInterval, removed, uids;

-(void)dealloc {
  [title release];
  [urlString release];
  [uids release];
  [super dealloc];
}

-(void)integrateNews:(NSArray*)news {
  if (![news isKindOfClass:[NSError class]])
    [newsCenter integrateNews:news forTitle:title];

  if ([self removed]) {
    [self release];
    return;
  }
  [self performSelector:@selector(fetchNews)
         withObject:nil
         afterDelay:[self refreshInterval]];
}

-(void)fetchNews {
  if ([self removed]) {
    [self release];
    return;
  }

  [ZNXmlHttpRequest callService:[self urlString]
               method:kZNHttpMethodGet
               data:nil
           responseModels:[NewsCenter rssModels]
               target:self
               action:@selector(integrateNews:)];
}
@end


#pragma mark Private Methods

@interface NewsCenter ()

-(void)startFetchingNewsFor:(NewsCenterFeed*)feedData;

@end

@implementation NewsCenter

#pragma mark Lifecycle

-(id)init {
  if ((self = [super init])) {
    dataByTitle = [[NSMutableDictionary alloc] init];
    newsByUid = [[NSMutableDictionary alloc] init];
  }
  return self;
}
-(void)dealloc {
  for (NewsCenterFeed* data in [dataByTitle allValues]) {
    data.removed = YES;
  }
  [dataByTitle release];
  [newsByUid release];
  [super dealloc];
}

-(void)addTitle:(NSString*)title
      withUrl:(NSString*)urlString
     andRefresh:(NSTimeInterval)refreshInterval {
  NSAssert([NSThread mainThread], @"Method called outside main thread");

  NewsCenterFeed* data = [dataByTitle objectForKey:title];
  if (data != nil) {
    data.urlString = urlString;
    data.refreshInterval = refreshInterval;
    return;
  }

  data = [[NewsCenterFeed alloc] init];
  data.newsCenter = self;
  data.title = title;
  data.urlString = urlString;
  data.refreshInterval = refreshInterval;
  data.removed = NO;
  data.uids = [NSArray array];
  [dataByTitle setObject:data forKey:title];
  [self startFetchingNewsFor:data];
}

-(void)removeTitle:(NSString*) title {
  NSAssert([NSThread mainThread], @"Method called outside main thread");

  NewsCenterFeed* data = [dataByTitle objectForKey:title];
  if (data != nil) {
    data.removed = YES;
    for(NSString* uid in data.uids) {
      [newsByUid removeObjectForKey:uid];
    }
    [dataByTitle removeObjectForKey:title];
  }
}

-(NSUInteger)totalNewsForTitle:(NSString*) title {
  NSAssert([NSThread mainThread], @"Method called outside main thread");

  return [[[dataByTitle objectForKey:title] uids] count];
}

-(NSUInteger)unreadNewsForTitle:(NSString*) title {
  NSAssert([NSThread mainThread], @"Method called outside main thread");

  NSUInteger unread = 0;
  for (NSString* uid in [[dataByTitle objectForKey:title] uids]) {
    unread += [(NewsItem*)[newsByUid objectForKey:uid] isRead] ? 0 : 1;
  }
  return unread;
}

-(NewsItem*)newsItemForTitle:(NSString*)title atIndex:(NSUInteger)index {
  NewsCenterFeed* data = [dataByTitle objectForKey:title];
  return [newsByUid objectForKey:[data.uids objectAtIndex:index]];
}

-(void)markAsReadItemWithId:(NSString*) uid {
  NSAssert([NSThread mainThread], @"Method called outside main thread");

  NewsItem* newItem = [[NewsItem alloc] initWithItem:[newsByUid
                            objectForKey:uid]
                      markAsRead:YES];
  [newsByUid setObject:newItem
          forKey:uid];
  [newItem release];
}

-(void)integrateNews:(NSArray*)news forTitle:(NSString*)title {
  NSAssert([NSThread mainThread], @"Method called outside main thread");

  NewsCenterFeed* data = [dataByTitle objectForKey:title];

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

static NSDictionary* rssModels = nil;

+(NSDictionary*)rssModels {
  @synchronized ([NewsCenter class]) {
    if (rssModels == nil) {
      rssModels = [[NSDictionary alloc] initWithObjectsAndKeys:
                   [NSArray arrayWithObjects:[NewsItem class],
                    [NSSet setWithObjects:@"description", @"guid", @"link",
                     @"pubDate", @"title", nil],
                    nil],
                   @"item", nil];
    }
  }
  return rssModels;
}

-(void)parsedItem:(NSDictionary*)itemData
         name:(NSString*)itemName
      context:(NSObject*)context {
  NewsItem* newsItem = [[NewsItem alloc] initWithProperties:itemData];
  [(NSMutableArray*)context addObject:newsItem];
  [newsItem release];
}

-(void)startFetchingNewsFor:(NewsCenterFeed*)feedData {
  [feedData retain];
  [feedData fetchNews];
}

@end

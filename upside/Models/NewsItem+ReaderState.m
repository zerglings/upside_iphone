//
//  NewsItem+ReaderState.m
//  upside
//
//  Created by Victor Costan on 1/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NewsItem.h"
#import "NewsItem+ReaderState.h"


@implementation NewsItem (ReaderState)

- (BOOL) isRead {
	NSNumber* isRead = [props objectForKey:kNewsItemRead];
	return (isRead != nil) && [isRead boolValue];
}

- (id) initWithItem: (NewsItem*)item markAsRead: (BOOL)isRead {
	NSMutableDictionary* newProps = [item.properties mutableCopy];
	[newProps setObject:[NSNumber numberWithBool:isRead] forKey:kNewsItemRead];
	return [super initWithProperties:newProps];
}

@end

#pragma mark News Item Extended Properties Keys

const NSString* kNewsItemRead = @"read";

// 			 [NSNumber numberWithBool:isRead], kNewsItemRead,

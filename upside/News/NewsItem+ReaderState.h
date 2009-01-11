//
//  NewsItem+ReaderState.h
//  upside
//
//  Created by Victor Costan on 1/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NewsItem (ReaderState)

#pragma mark Convenience Constructors

- (id) initWithItem: (NewsItem*)item markAsRead: (BOOL)isRead;

#pragma mark Accessors

// Returns YES if the item has been read.
- (BOOL) isRead;

@end

#pragma mark News Item Extended Properties Keys

// An NSNumber with a boolean value indicating whether the news item was read. 
const NSString* kNewsItemRead;

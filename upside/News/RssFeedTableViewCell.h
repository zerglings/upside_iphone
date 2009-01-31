//
//  RssFeedTableViewCell.h
//  StockPlay
//
//  Created by Victor Costan on 1/10/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsItem;

@interface RssFeedTableViewCell : UITableViewCell {
	IBOutlet UILabel* titleLabel;
	IBOutlet UILabel* summaryLabel;
	
	NewsItem* newsItem;
}

-(void)setNewsItem: (NewsItem*)newsItem;

@end

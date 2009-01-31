//
//  RssFeedTableViewCell.m
//  StockPlay
//
//  Created by Victor Costan on 1/10/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "RssFeedTableViewCell.h"

#import "NewsItem.h"

@implementation RssFeedTableViewCell

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[newsItem release];
    [super dealloc];
}

-(void)setNewsItem: (NewsItem*)theNewsItem {
	[theNewsItem retain];
	[newsItem release];
	newsItem = theNewsItem;

	titleLabel.font = [newsItem isRead] ? [UIFont systemFontOfSize:16] :
	[UIFont boldSystemFontOfSize:16];
	titleLabel.text = [newsItem title];
	summaryLabel.text = [newsItem summary];	
}

@end

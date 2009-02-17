//
//  NewsTableViewCell.m
//  StockPlay
//
//  Created by Victor Costan on 1/12/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "NewsTableViewCell.h"

#import "Game.h"
#import "NewsCenter.h"


@implementation NewsTableViewCell

-(id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}


-(void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)dealloc {
	[feedTitle release];
    [super dealloc];
}

-(void)setFeedTitle:(NSString*)title {
	[title retain];
	[feedTitle release];
	feedTitle = title;
	
	titleLabel.text = feedTitle;
	NSUInteger unreadItems = [[[Game sharedGame] newsCenter]
							  unreadNewsForTitle:feedTitle];
	[unreadCountButton setTitle:[NSString stringWithFormat:@"%u", unreadItems]
					   forState:UIControlStateNormal];
	[unreadCountButton setTitle:[NSString stringWithFormat:@"%u", unreadItems]
					   forState:UIControlStateHighlighted];
	
	if (unreadItems == 0) {
		[unreadCountButton setHidden:YES];
	}
}

@end

//
//  NewsTableViewCell.h
//  StockPlay
//
//  Created by Victor Costan on 1/12/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewsTableViewCell : UITableViewCell {
	IBOutlet UILabel* titleLabel;
	IBOutlet UIButton* unreadCountButton;
	
	NSString* feedTitle;
}

-(void)setFeedTitle:(NSString*)title;

@end

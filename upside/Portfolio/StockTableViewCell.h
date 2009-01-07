//
//  StockTableViewCell.h
//  upside
//
//  Created by Victor Costan on 1/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PortfolioTableViewController;
@class Stock;

@interface StockTableViewCell : UITableViewCell {
	IBOutlet UILabel* tickerLabel;
	IBOutlet UILabel* nameLabel;
	IBOutlet UILabel* askPriceLabel;
	IBOutlet UILabel* bidPriceLabel;
	IBOutlet UIButton* askChangeButton;
	IBOutlet UIButton* bidChangeButton;
	IBOutlet UILabel* stockCountLabel;
	IBOutlet UILabel* stockValueLabel;
	IBOutlet UIImageView* bidPriceProgressIcon;
	IBOutlet UIImageView* askPriceProgressIcon;
	
	Stock *stock;
	NSUInteger stockOwned;
}

- (Stock*) stock;
- (NSUInteger) stockOwned;

- (void) setStock: (Stock*)stock owned:(NSUInteger)stockOwned;

@end

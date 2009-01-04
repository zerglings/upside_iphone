//
//  StockTableViewCell.h
//  upside
//
//  Created by Victor Costan on 1/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PortfolioTableViewController;

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
	
	NSUInteger stockId;
}

- (NSUInteger) stockId;
- (void) setStockId: (NSUInteger)stockId;

// Loads a table cell with the given reuse identifier from a nib.
+ (StockTableViewCell*) loadFromNib: (NSString*)nibName
						 identifier: (NSString*)identifier
							  owner: (PortfolioTableViewController*)owner;
@end

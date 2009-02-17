//
//  StockTableViewCell.h
//  StockPlay
//
//  Created by Victor Costan on 1/3/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Position;
@class Stock;

@interface StockTableViewCell : UITableViewCell {
	IBOutlet UILabel* tickerLabel;
	IBOutlet UILabel* nameLabel;
	IBOutlet UILabel* askPriceLabel;
	IBOutlet UILabel* bidPriceLabel;
	IBOutlet UILabel* tradePriceLabel;
	IBOutlet UIButton* askChangeButton;
	IBOutlet UIButton* bidChangeButton;
	IBOutlet UIButton* tradeChangeButton;
	IBOutlet UILabel* stockCountLabel;
	IBOutlet UILabel* stockValueLabel;
	IBOutlet UIImageView* askPriceProgressIcon;
	IBOutlet UIImageView* bidPriceProgressIcon;
	IBOutlet UIImageView* tradePriceProgressIcon;
	
	Position* position;
	Stock *stockInfo;
}

-(Stock*)stockInfo;
-(Position*)position;

-(void)setPosition:(Position*)position stockInfo:(Stock*)stock;

@end

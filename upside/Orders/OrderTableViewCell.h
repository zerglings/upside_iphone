//
//  OrderTableViewCell.h
//  upside
//
//  Created by Victor Costan on 1/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TradeOrder;

@interface OrderTableViewCell : UITableViewCell {
	IBOutlet UILabel* tickerLabel;
	IBOutlet UILabel* buyOrSellLabel;
	IBOutlet UILabel* limitPriceLabel;
	IBOutlet UILabel* quantityLabel;
	IBOutlet UILabel* quantityFilledLabel;
	IBOutlet UILabel* percentFilledLabel;
	IBOutlet UIProgressView* fillProgressView;
	
	TradeOrder* order;	
}

- (TradeOrder*) order;
- (void) setOrder: (TradeOrder*)order;

@end

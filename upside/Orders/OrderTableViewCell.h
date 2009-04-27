//
//  OrderTableViewCell.h
//  StockPlay
//
//  Created by Victor Costan on 1/4/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TradeOrder;
@class Stock;

@interface OrderTableViewCell : UITableViewCell {
  IBOutlet UILabel* tickerLabel;
  IBOutlet UILabel* buyOrSellLabel;
  IBOutlet UILabel* limitPriceLabel;
  IBOutlet UILabel* quantityLabel;
  IBOutlet UILabel* quantityFilledLabel;
  IBOutlet UILabel* percentFilledLabel;
  IBOutlet UILabel* marketAskOrSellLabel;
  IBOutlet UIProgressView* fillProgressView;

  TradeOrder* order;
  Stock* stock;
}

-(TradeOrder*)order;
-(Stock*)stock;
-(void)setOrder:(TradeOrder*)order forStock:(Stock*)stock;

@end

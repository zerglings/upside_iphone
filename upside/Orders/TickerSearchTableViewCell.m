//
//  TickerSearchTableViewCell.m
//  upside
//
//  Created by Victor Costan on 5/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TickerSearchTableViewCell.h"

#import "StockSearchCommController.h"


@implementation TickerSearchTableViewCell

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

- (void)dealloc {
  [stockData release];
  [super dealloc];
}

-(void)setStockData:(StockSearchData*)theStockData {
  [stockData release];
  stockData = [theStockData retain];
  
  tickerLabel.text = stockData.symbol;
  marketLabel.text = stockData.exchDisp;
  companyNameLabel.text = stockData.name;  
}
-(StockSearchData*)stockData {
  return stockData;
}

@end

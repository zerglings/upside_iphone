//
//  OrderTableViewCell.m
//  StockPlay
//
//  Created by Victor Costan on 1/4/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "OrderTableViewCell.h"

#import "Stock.h"
#import "Stock+Formatting.h"
#import "TradeOrder.h"
#import "TradeOrder+Formatting.h"


@implementation OrderTableViewCell

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
	[order release];
    [super dealloc];
}

-(TradeOrder*)order {
	return order;
}
-(Stock*)stock {
	return stock;
}

-(void)setOrder: (TradeOrder*)newOrder forStock: (Stock*)newStock {
	[newOrder retain];
	[order release];
	order = newOrder;
	
	[newStock retain];
	[stock release];
	stock = newStock;
	
	tickerLabel.text = [order ticker];
	buyOrSellLabel.text = [order isBuy] ? @"buy" : @"sell";
	limitPriceLabel.text = [order formattedLimitPrice];
	quantityLabel.text = [order formattedQuantity];
	quantityFilledLabel.text = [order formattedQuantityFilled];
	percentFilledLabel.text = [order formattedPercentFilled];
	marketAskOrSellLabel.text = [order isBuy] ?
	    [stock formattedAskPrice] : [stock formattedBidPrice];
	[fillProgressView setProgress:[order fillRatio]];
}

@end

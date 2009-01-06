//
//  OrderTableViewCell.m
//  upside
//
//  Created by Victor Costan on 1/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "OrderTableViewCell.h"

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

- (TradeOrder*) order {
	return order;
}
- (void) setOrder: (TradeOrder*)newOrder {
	[newOrder retain];
	[order release];
	order = newOrder;
	
	tickerLabel.text = [order ticker];
	buyOrSellLabel.text = [order isBuyOrder] ? @"buy" : @"sell";
	limitPriceLabel.text = [order formattedLimitPrice];
	quantityLabel.text = [order formattedQuantity];
	quantityFilledLabel.text = [order formattedQuantityFilled];
	percentFilledLabel.text = [order formattedPercentFilled];
	[fillProgressView setProgress:[order fillRatio]];
}

@end

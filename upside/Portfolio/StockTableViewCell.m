//
//  StockTableViewCell.m
//  upside
//
//  Created by Victor Costan on 1/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StockTableViewCell.h"

#import "Portfolio.h"
#import "Portfolio+Formatting.h"
#import "Stock.h"
#import "Stock+Formatting.h"


@implementation StockTableViewCell

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
	[stock release];
    [super dealloc];
}

- (Stock*) stock {
	return stock;
}

- (NSUInteger) stockOwned {
	return stockOwned;
}

- (void) setStock: (Stock*)newStock owned:(NSUInteger)newStockOwned {
	[newStock retain];
	[stock release];
	stock = newStock;
	stockOwned = newStockOwned;
	
	tickerLabel.text = [stock ticker];
	nameLabel.text = [stock name];
	
	[askChangeButton setTitle:[stock formattedNetAskChange]
					 forState:UIControlStateNormal];
	[askChangeButton setTitle:[stock formattedNetAskChange]
					 forState:UIControlStateHighlighted];
	[bidChangeButton setTitle:[stock formattedNetBidChange]
					 forState:UIControlStateNormal];
	[bidChangeButton setTitle:[stock formattedNetBidChange]
					 forState:UIControlStateHighlighted];
	[tradeChangeButton setTitle:[stock formattedNetTradeChange]
					 forState:UIControlStateNormal];
	[tradeChangeButton setTitle:[stock formattedNetTradeChange]
					 forState:UIControlStateHighlighted];
	
	[askChangeButton setTitleColor:[stock colorForAskChange]
					      forState:UIControlStateNormal];
	[askChangeButton setTitleColor:[stock colorForAskChange]
					      forState:UIControlStateHighlighted];
	[bidChangeButton setTitleColor:[stock colorForBidChange]
					      forState:UIControlStateNormal];
	[bidChangeButton setTitleColor:[stock colorForBidChange]
					      forState:UIControlStateHighlighted];
	[tradeChangeButton setTitleColor:[stock colorForTradeChange]
					      forState:UIControlStateNormal];
	[tradeChangeButton setTitleColor:[stock colorForTradeChange]
					      forState:UIControlStateHighlighted];
	
	askPriceLabel.text = [stock formattedAskPrice];
	bidPriceLabel.text = [stock formattedBidPrice];
	tradePriceLabel.text = [stock formattedTradePrice];
	stockValueLabel.text = [stock formattedValueUsingBidPriceFor:stockOwned];	
	stockCountLabel.text = [Portfolio formatStockOwned:stockOwned];
						   
	askPriceProgressIcon.image = [stock imageForAskChange];
	bidPriceProgressIcon.image = [stock imageForBidChange];
	tradePriceProgressIcon.image = [stock imageForTradeChange];
}

@end

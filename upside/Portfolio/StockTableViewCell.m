//
//  StockTableViewCell.m
//  upside
//
//  Created by Victor Costan on 1/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StockTableViewCell.h"

#import "Portfolio.h"
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
    [super dealloc];
}

- (NSUInteger) stockId {
	return stockId;
}

- (void) setStockId: (NSUInteger)newStockId {
	stockId = newStockId;
	
	Stock* stock = [[Portfolio sharedPortfolio] stockWithStockId:stockId];
	
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
	
	[askChangeButton setTitleColor:[stock colorForAskChange]
					      forState:UIControlStateNormal];
	[askChangeButton setTitleColor:[stock colorForAskChange]
					      forState:UIControlStateHighlighted];
	[bidChangeButton setTitleColor:[stock colorForBidChange]
					      forState:UIControlStateNormal];
	[bidChangeButton setTitleColor:[stock colorForBidChange]
					      forState:UIControlStateHighlighted];
	
	askPriceLabel.text = [stock formattedAskPrice];
	bidPriceLabel.text = [stock formattedBidPrice];
	stockValueLabel.text = [stock formattedValueUsingBidPrice];	
	stockCountLabel.text = [stock formattedOwnCount];
						   
	askPriceProgressIcon.image = [stock imageForAskChange];
	bidPriceProgressIcon.image = [stock imageForBidChange];
}

@end

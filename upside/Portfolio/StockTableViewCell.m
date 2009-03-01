//
//  StockTableViewCell.m
//  StockPlay
//
//  Created by Victor Costan on 1/3/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "StockTableViewCell.h"

#import "AssetBook.h"
#import "Position.h"
#import "Position+Formatting.h"
#import "Stock.h"
#import "Stock+Formatting.h"


@implementation StockTableViewCell

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


-(void)dealloc {
	[position release];
	[stockInfo release];
    [super dealloc];
}

-(Position*)position {
	return position;
}

-(Stock*)stockInfo {
	return stockInfo;
}

-(void)setPosition:(Position*)newPosition stockInfo:(Stock*)newStockInfo {
	[position release];
	[stockInfo release];
	position = [newPosition retain];
	stockInfo = [newStockInfo retain];
	
	tickerLabel.text = [position ticker];
	nameLabel.text = [stockInfo name];
	
  NSString* formattedAskChange =
      [NSString stringWithFormat:@"%@ ", [stockInfo formattedNetAskChange]];
	[askChangeButton setTitle:formattedAskChange
					 forState:UIControlStateNormal];
	[askChangeButton setTitle:formattedAskChange
					 forState:UIControlStateHighlighted];
  
  NSString* formattedBidChange =
      [NSString stringWithFormat:@"%@ ", [stockInfo formattedNetBidChange]];
	[bidChangeButton setTitle:formattedBidChange
					 forState:UIControlStateNormal];
	[bidChangeButton setTitle:formattedBidChange
					 forState:UIControlStateHighlighted];
  
  NSString* formattedTradeChange = 
      [NSString stringWithFormat:@"%@ ", [stockInfo formattedNetTradeChange]];
	[tradeChangeButton setTitle:formattedTradeChange
					 forState:UIControlStateNormal];
	[tradeChangeButton setTitle:formattedTradeChange
					 forState:UIControlStateHighlighted];
	
	[askChangeButton setTitleColor:[stockInfo colorForAskChange]
					      forState:UIControlStateNormal];
	[askChangeButton setTitleColor:[stockInfo colorForAskChange]
					      forState:UIControlStateHighlighted];
	[bidChangeButton setTitleColor:[stockInfo colorForBidChange]
					      forState:UIControlStateNormal];
	[bidChangeButton setTitleColor:[stockInfo colorForBidChange]
					      forState:UIControlStateHighlighted];
	[tradeChangeButton setTitleColor:[stockInfo colorForTradeChange]
					      forState:UIControlStateNormal];
	[tradeChangeButton setTitleColor:[stockInfo colorForTradeChange]
					      forState:UIControlStateHighlighted];
	
	askPriceLabel.text = [stockInfo formattedAskPrice];
	bidPriceLabel.text = [stockInfo formattedBidPrice];
	tradePriceLabel.text = [stockInfo formattedTradePrice];
	stockValueLabel.text = [stockInfo formattedValueUsingTradePriceFor:
							[position quantity]];	
	stockCountLabel.text = [position formattedQuantity];
						   
	askPriceProgressIcon.image = [stockInfo imageForAskChange];
	bidPriceProgressIcon.image = [stockInfo imageForBidChange];
	tradePriceProgressIcon.image = [stockInfo imageForTradeChange];
}

@end

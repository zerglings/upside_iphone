//
//  StockTableViewCell.m
//  upside
//
//  Created by Victor Costan on 1/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StockTableViewCell.h"

#import "Portfolio.h"
#import "StockFormatter.h"


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
	StockFormatter* formatter = [StockFormatter sharedFormatter];
	
	tickerLabel.text = [stock objectForKey:kStockTicker];
	nameLabel.text = [stock objectForKey:kStockName];
	
	[askChangeButton setTitle:[formatter netAskChangeFor:stock]
					 forState:UIControlStateNormal];
	[askChangeButton setTitle:[formatter netAskChangeFor:stock]
					 forState:UIControlStateHighlighted];
	[bidChangeButton setTitle:[formatter netAskChangeFor:stock]
					 forState:UIControlStateNormal];
	[bidChangeButton setTitle:[formatter netAskChangeFor:stock]
					 forState:UIControlStateHighlighted];
	
	[askChangeButton setTitleColor:[formatter askChangeColorFor:stock]
					      forState:UIControlStateNormal];
	[askChangeButton setTitleColor:[formatter askChangeColorFor:stock]
					      forState:UIControlStateHighlighted];
	[bidChangeButton setTitleColor:[formatter bidChangeColorFor:stock]
					      forState:UIControlStateNormal];
	[bidChangeButton setTitleColor:[formatter bidChangeColorFor:stock]
					      forState:UIControlStateHighlighted];
	
	askPriceLabel.text = [formatter askPriceFor:stock];
	bidPriceLabel.text = [formatter bidPriceFor:stock];
	stockValueLabel.text = [formatter valueUsingBskPriceFor:stock];	
	stockCountLabel.text = [formatter ownCountFor:stock];
						   
	askPriceProgressIcon.image = [formatter askChangeImageFor:stock];
	bidPriceProgressIcon.image = [formatter bidChangeImageFor:stock];
}

+ (StockTableViewCell*) loadFromNib: (NSString*)nibName
						 identifier: (NSString*)identifier
							  owner: (PortfolioTableViewController*)owner {
	NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:nibName
														 owner:owner
													   options:nil];
	NSEnumerator* nibEnumerator = [nibContents objectEnumerator];
	
	NSObject* nibItem;
	while ((nibItem = [nibEnumerator nextObject])) {
		if (![nibItem isKindOfClass:[StockTableViewCell class]])
			continue;
		StockTableViewCell* stockTableViewCell = (StockTableViewCell*)nibItem;
		if ([stockTableViewCell.reuseIdentifier isEqualToString:identifier])
			return stockTableViewCell;
	}
	NSLog(@"StockTableViewCell -loadFromNib failed to find the cell");
	return nil;	
}

@end

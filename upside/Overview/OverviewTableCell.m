//
//  OverviewTableCell.m
//  upside
//
//  Created by Victor Costan on 3/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "OverviewTableCell.h"


@implementation OverviewTableCell

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

@synthesize descriptionLabel, quantityLabel, quantityImage;

@end

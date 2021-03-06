//
//  OverviewTableCell.h
//  StockPlay
//
//  Created by Victor Costan on 3/3/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OverviewTableCell : UITableViewCell {
  IBOutlet UILabel* descriptionLabel;
  IBOutlet UILabel* quantityLabel;
  IBOutlet UIImageView* quantityImage;
}

@property (nonatomic, readonly, assign) UILabel* descriptionLabel;
@property (nonatomic, readonly, assign) UILabel* quantityLabel;
@property (nonatomic, readonly, assign) UIImageView* quantityImage;

@end

//
//  NewOrderViewController.h
//  StockPlay
//
//  Created by Victor Costan on 1/25/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Stock;
@class StockInfoCommController;

@interface NewOrderViewController : UIViewController {
  IBOutlet UISegmentedControl* orderTypeSegmentedControl;
  IBOutlet UITextField* tickerText;
  IBOutlet UIImageView* tickerValidityImage;
  IBOutlet UIButton* tickerSeachButton;
  IBOutlet UITextField* quantityText;
  IBOutlet UIButton* quantityAllButton;
  IBOutlet UISegmentedControl* limitTypeSegmentedControl;
  IBOutlet UILabel* limitDescriptionLabel;
  IBOutlet UITextField* limitDollarsText;
  IBOutlet UITextField* limitCentsText;
  IBOutlet UILabel* limitCentSeparatorLabel;

  IBOutlet UILabel* askPriceLabel;
  IBOutlet UILabel* bidPriceLabel;
  IBOutlet UILabel* askPriceChange;
  IBOutlet UILabel* bidPriceChange;
  IBOutlet UIImageView* askPriceChangeImage;
  IBOutlet UIImageView* bidPriceChangeImage;
  IBOutlet UILabel* availableCashLabel;
  IBOutlet UILabel* estimatedCostLabel;

  NSNumberFormatter* inputFormatter;
  StockInfoCommController* stockInfoCommController;
  Stock* stockInfo;
}

-(IBAction)orderTypeChanged:(id)sender;
-(IBAction)limitTypeChanged:(id)sender;
-(IBAction)searchTapped:(id)sender;
-(IBAction)allTapped:(id)sender;

@end

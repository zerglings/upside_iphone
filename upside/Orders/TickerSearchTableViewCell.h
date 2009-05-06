//
//  TickerSearchTableViewCell.h
//  upside
//
//  Created by Victor Costan on 5/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StockSearchData;


@interface TickerSearchTableViewCell : UITableViewCell {
  IBOutlet UILabel* tickerLabel;
  IBOutlet UILabel* companyNameLabel;
  IBOutlet UILabel* marketLabel;
  
  StockSearchData* stockData;
}
@property (nonatomic, readwrite, retain) StockSearchData* stockData;

@end

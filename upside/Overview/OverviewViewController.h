//
//  OverviewViewController.h
//  StockPlay
//
//  Created by Victor Costan on 1/3/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "GameAwareViewController.h"


@interface OverviewViewController : GameAwareViewController {
  IBOutlet UILabel* userNameLabel;
  IBOutlet UILabel* lastSyncLabel;
  IBOutlet UILabel* cashLabel;
  IBOutlet UIImageView* cashImage;
  IBOutlet UILabel* stockWorthLabel;
  IBOutlet UILabel* netWorthLabel;
}

@end

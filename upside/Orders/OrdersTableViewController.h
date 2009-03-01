//
//  OrdersViewController.h
//  StockPlay
//
//  Created by Victor Costan on 1/4/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameAwareTableViewController.h"

@interface OrdersTableViewController : GameAwareTableViewController {
  // Shown when the table is empty.
  IBOutlet UIView* emptyView;
}

-(IBAction)placeOrderTapped:(id)sender;

@end

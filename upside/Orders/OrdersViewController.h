//
//  OrdersViewController.h
//  StockPlay
//
//  Created by Victor Costan on 6/14/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GameAwareViewController.h"


@class OrdersTableViewController;

@interface OrdersViewController : GameAwareViewController {
  IBOutlet OrdersTableViewController* tableViewController;
  IBOutlet UITableView* tableView;
  IBOutlet UISegmentedControl* orderFilterControl;
}

-(IBAction)ordersFilterChanged:(id)sender;
-(IBAction)placeOrderTapped:(id)sender;
@end

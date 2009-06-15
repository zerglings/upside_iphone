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
  // Shown when the orders table would be empty.
  IBOutlet UIView* emptyView;
  BOOL pendingOrdersEnabled;
  BOOL submittedOrdersEnabled;
  BOOL completedOrdersEnabled;
}

-(void)setOrdersFilter:(NSUInteger)ordersFiler;
@end

// Show all orders.
#define kOrdersFilterAll 0
// Show pending orders.
#define kOrdersFilterPending 1
// Show completed orders.
#define kOrdersFilterCompleted 2

//
//  OrdersViewController.m
//  StockPlay
//
//  Created by Victor Costan on 1/4/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "OrdersTableViewController.h"

#import "ControllerSupport.h"
#import "Game.h"
#import "OrderTableViewCell.h"
#import "StockCache.h"
#import "TradeBook.h"
#import "TradeOrder.h"

@interface OrdersTableViewController ()
-(void)refreshEmptyView;
@end


@implementation OrdersTableViewController

/*
-(id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

-(void)viewDidLoad {
  [super viewDidLoad];

  pendingOrdersEnabled = YES;
  submittedOrdersEnabled = YES;
  completedOrdersEnabled = YES;

  self.narrowCellNib = @"OrderTableCellNarrow";
  self.wideCellNib = @"OrderTableCellWide";
  self.narrowCellReuseIdentifier = @"OrderNarrow";
  self.wideCellReuseIdentifier = @"OrderWide";
  self.cellClass = [OrderTableViewCell class];

  // The empty view will always be a subview, but it will usually be hidden.
  [self.view addSubview:emptyView];
  CGRect frame = self.view.frame;
  emptyView.frame = CGRectMake(0.0f, 0.0f,
                               CGRectGetWidth(frame), CGRectGetHeight(frame));
  emptyView.autoresizingMask = UIViewAutoresizingFlexibleHeight |
      UIViewAutoresizingFlexibleWidth;
  [self refreshEmptyView];
}

-(void)refreshEmptyView {
  TradeBook* tradeBook = [[Game sharedGame] tradeBook];
  NSUInteger trades = (pendingOrdersEnabled ? [tradeBook pendingCount] : 0) +
      (submittedOrdersEnabled ? [tradeBook submittedCount] : 0) +
      (completedOrdersEnabled ? [tradeBook filledCount] : 0);
  BOOL hidden = (trades != 0);
  [emptyView setHidden:hidden];
}

-(void)newGameData {
  [super newGameData];
  [self refreshEmptyView];
}

/*
 -(void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
-(void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview
  [super didReceiveMemoryWarning];
  // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

#define kNotSubmittedSection 0
#define kSubmittedSection 1
#define kFilledSection 2

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return (pendingOrdersEnabled ? 1 : 0) + (submittedOrdersEnabled ? 1 : 0) +
         (completedOrdersEnabled ? 1 : 0);
}

-(NSInteger)logicalSectionForPhysicalSection:(NSInteger)section {
  if (pendingOrdersEnabled) {
    if (section == 0)
      return kNotSubmittedSection;
    section--;
  }
  if (submittedOrdersEnabled) {
    if (section == 0)
      return kSubmittedSection;
    section--;
  }
  if (completedOrdersEnabled) {
    if (section == 0)
      return kFilledSection;
    section--;
  }
  NSAssert(NO, @"Unsupported physical section");
  return -1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if ([self tableView:tableView numberOfRowsInSection:section] == 0) {
    return nil;
  }

  section = [self logicalSectionForPhysicalSection:section];
  switch(section) {
    case kNotSubmittedSection:
      return @"Not submitted to server";
    case kSubmittedSection:
      return @"Waiting to be filled";
    case kFilledSection:
      return @"Filled";
    default:
      return nil;
  }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  section = [self logicalSectionForPhysicalSection:section];

  TradeBook* tradeBook = [[Game sharedGame] tradeBook];
  switch(section) {
    case kNotSubmittedSection:
      NSLog(@"Pending orders: %d", [tradeBook pendingCount]);
      return [tradeBook pendingCount];
    case kSubmittedSection:
      return [tradeBook submittedCount];
    case kFilledSection:
      return [tradeBook filledCount];
    default:
      return -1;
  }
}

// Customize the appearance of table view cells.
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  OrderTableViewCell* cell = (OrderTableViewCell*)[super tableView:tableView
                                             cellForRowAtIndexPath:indexPath];
  TradeBook* tradeBook = [[Game sharedGame] tradeBook];
  TradeOrder* order;
  switch([self logicalSectionForPhysicalSection:indexPath.section]) {
    case kNotSubmittedSection:
      order = [tradeBook pendingAtIndex:
               ([tradeBook pendingCount] - indexPath.row - 1)];
      break;
    case kSubmittedSection:
      order = [tradeBook submittedAtIndex:
               ([tradeBook submittedCount] - indexPath.row - 1)];
      break;
    case kFilledSection:
      order = [tradeBook filledAtIndex:
               ([tradeBook filledCount] - indexPath.row - 1)];
      break;
    default:
      order = nil;
  }
  Stock* stock = [[[Game sharedGame] stockCache] stockForTicker:order.ticker];
  [cell setOrder:order forStock:stock];

  return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
  // AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
  // [self.navigationController pushViewController:anotherViewController];
  // [anotherViewController release];
}


/*
// Override to support conditional editing of the table view.
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
*/


/*
// Override to support rearranging the table view.
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

-(void)dealloc {
    [super dealloc];
}

-(void)setOrdersFilter:(NSUInteger)ordersFiler {
  switch (ordersFiler) {
    case kOrdersFilterAll:
      pendingOrdersEnabled = YES;
      submittedOrdersEnabled = YES;
      completedOrdersEnabled = YES;
      break;
    case kOrdersFilterPending:
      pendingOrdersEnabled = YES;
      submittedOrdersEnabled = YES;
      completedOrdersEnabled = NO;
      break;
    case kOrdersFilterCompleted:
      pendingOrdersEnabled = NO;
      submittedOrdersEnabled = NO;
      completedOrdersEnabled = YES;
      break;
    default:
      NSAssert(NO, @"Unknown order filtering mode");
      break;
  }
  [self newGameData];
}
@end


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
#import "NewOrderViewController.h"
#import "OrderTableViewCell.h"
#import "StockCache.h"
#import "TradeBook.h"
#import "TradeOrder.h"

@implementation OrdersTableViewController

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (void)viewDidLoad {
  [super viewDidLoad];
	
	self.narrowCellNib = @"OrderTableCellNarrow";
	self.wideCellNib = @"OrderTableCellWide";
	self.narrowCellReuseIdentifier = @"OrderNarrow";
	self.wideCellReuseIdentifier = @"OrderWide";
	self.cellClass = [OrderTableViewCell class];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  self.navigationItem.leftBarButtonItem =
      [[UIBarButtonItem alloc]
       initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
       target:self action:@selector(tappedAddTradeButton:)];
}

/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

#define kNotSubmittedSection 0
#define kSubmittedSection 1
#define kFilledSection 2

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  TradeBook* tradeBook = [[Game sharedGame] tradeBook];
	switch(section) {
		case kNotSubmittedSection:
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderTableViewCell* cell = (OrderTableViewCell*)[super tableView:tableView
											   cellForRowAtIndexPath:indexPath];
		
	TradeBook* tradeBook = [[Game sharedGame] tradeBook];
	TradeOrder* order;
	switch(indexPath.section) {
		case kNotSubmittedSection:
			order = [tradeBook pendingAtIndex:indexPath.row];
      break;
		case kSubmittedSection:
			order = [tradeBook submittedAtIndex:indexPath.row];
      break;
		case kFilledSection:
			order = [tradeBook filledAtIndex:indexPath.row];
      break;
		default:
			order = nil;
	}
	Stock* stock = [[[Game sharedGame] stockCache] stockForTicker:order.ticker];
	[cell setOrder:order forStock:stock];

  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
    [super dealloc];
}

-(void)tappedAddTradeButton: (id)sender {
  NewOrderViewController* newOrderViewController =
      [[NewOrderViewController alloc] initWithNibName:@"NewOrderViewController"
                                               bundle:nil];
  [self.navigationController pushViewController:newOrderViewController
                                       animated:YES];
  // TODO(overmind): setup controller
  [newOrderViewController release];
}

@end


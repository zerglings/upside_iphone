//
//  OverviewTableViewController.m
//  StockPlay
//
//  Created by Victor Costan on 3/3/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "OverviewTableViewController.h"

#import "AssetBook+Formatting.h"
#import "AssetBook+NetWorth.h"
#import "Game.h"
#import "OverviewTableCell.h"
#import "PortfolioStat.h"
#import "TradeBook+Formatting.h"

@interface OverviewTableViewController ()
-(void)setResultCell:(OverviewTableCell*)cell
         atIndexPath:(NSIndexPath*)indexPath;
-(void)setOperationsCell:(OverviewTableCell*)cell
         atIndexPath:(NSIndexPath*)indexPath;
-(void)setSyncCell:(OverviewTableCell*)cell
         atIndexPath:(NSIndexPath*)indexPath;
@end


@implementation OverviewTableViewController

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

  self.narrowCellNib = @"OverviewTableCellNarrow";
  self.wideCellNib = @"OverviewTableCellNarrow";
  self.narrowCellReuseIdentifier = @"OverviewNarrow";
  self.wideCellReuseIdentifier = @"OverviewNarrow";
  self.cellClass = [OverviewTableCell class];

  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc]
       initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
       target:[Game sharedGame] action:@selector(syncData)];
}

/*
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
-(void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
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
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

#define kResultsSection 0
#define kOperationsSection 1
#define kSyncSection 2

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if ([self tableView:tableView numberOfRowsInSection:section] == 0)
    return nil;

  switch(section) {
    case kResultsSection:
      return @"Accomplishments";
    case kOperationsSection:
      return @"Assets";
    case kSyncSection:
      return @"Data Accuracy";
    default:
      return nil;
  }
}

// Customize the number of rows in the table view.
-(NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  switch(section) {
    case kResultsSection:
      return 2;
    case kOperationsSection:
      return 3;
    case kSyncSection:
      return 1;
    default:
      return -1;
  }
}


// Customize the appearance of table view cells.
-(UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  OverviewTableCell* cell = (OverviewTableCell*)[super tableView:tableView
                                           cellForRowAtIndexPath:indexPath];

  switch(indexPath.section) {
    case kResultsSection:
      [self setResultCell:cell atIndexPath:indexPath];
      break;
    case kOperationsSection:
      [self setOperationsCell:cell atIndexPath:indexPath];
      break;
    case kSyncSection:
      [self setSyncCell:cell atIndexPath:indexPath];
      break;
    default:
      return nil;
  }

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

-(void)setResultCell:(OverviewTableCell*)cell
         atIndexPath:(NSIndexPath*)indexPath {
  AssetBook* assetBook = [[Game sharedGame] assetBook];
  switch (indexPath.row) {
    case 0:
      cell.descriptionLabel.text = @"Net Worth";
      StockCache* stockCache = [[Game sharedGame] stockCache];
      cell.quantityLabel.text = [assetBook
                                 formattedNetWorthWithCache:stockCache];
      cell.quantityImage.image =
          [assetBook imageForNetWorthChangeFrom:[assetBook dailyStat]
                                     stockCache:stockCache];
      break;
    case 1: {
      cell.descriptionLabel.text = @"Rank";
      NSUInteger rank = [[assetBook hourlyStat] rank];
      if (rank == 0) {
        cell.quantityLabel.text = @"unranked";
      }
      else {
        NSNumberFormatter* rankFormatter = [[NSNumberFormatter alloc] init];
        [rankFormatter setPositiveFormat:@"#,##0"];
        cell.quantityLabel.text = [rankFormatter stringFromNumber:
                                   [NSNumber numberWithUnsignedInteger:rank]];
        [rankFormatter release];
      }
    }
    default:
      break;
  }
}

-(void)setOperationsCell:(OverviewTableCell*)cell
             atIndexPath:(NSIndexPath*)indexPath {
  AssetBook* assetBook = [[Game sharedGame] assetBook];
  TradeBook* tradeBook = [[Game sharedGame] tradeBook];
  StockCache* stockCache = [[Game sharedGame] stockCache];

  switch (indexPath.row) {
    case 0:
      cell.descriptionLabel.text = @"Cash";
      cell.quantityLabel.text = [assetBook formattedCash];
      break;
    case 1:
      cell.descriptionLabel.text = @"Stocks";
      cell.quantityLabel.text =
          [assetBook formattedStockWorthWithCache:stockCache];
      break;
    case 2:
      cell.descriptionLabel.text = @"Orders";
      cell.quantityLabel.text =
          [tradeBook formattedOrderProceedsWithCache:stockCache];
      break;
    default:
      break;
  }
}

-(void)setSyncCell:(OverviewTableCell*)cell
       atIndexPath:(NSIndexPath*)indexPath {
  switch (indexPath.row) {
    case 0: {
      cell.descriptionLabel.text = @"Last Sync";

      NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
      [formatter setDateStyle:NSDateFormatterShortStyle];
      [formatter setTimeStyle:NSDateFormatterShortStyle];

      NSDate* lastSyncTime = [[Game sharedGame] lastSyncTime];
      if (lastSyncTime)
        cell.quantityLabel.text = [formatter stringFromDate:lastSyncTime];
      else
        cell.quantityLabel.text = @"never";
      [formatter release];
      break;
    }
    default:
      break;
  }
}


@end


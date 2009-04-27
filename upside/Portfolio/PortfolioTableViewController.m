//
//  PortfolioTableViewController.m
//  StockPlay
//
//  Created by Victor Costan on 1/3/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "PortfolioTableViewController.h"

#import "AssetBook.h"
#import "Game.h"
#import "NewOrderViewController.h"
#import "StockCache.h"
#import "StockTableViewCell.h"

@interface PortfolioTableViewController ()
-(void)refreshEmptyView;
@end


@implementation PortfolioTableViewController

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

  self.narrowCellNib = @"StockTableCellNarrow";
  self.wideCellNib = @"StockTableCellWide";
  self.narrowCellReuseIdentifier = @"StockNarrow";
  self.wideCellReuseIdentifier = @"StockWide";
  self.cellClass = [StockTableViewCell class];

  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;

  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc]
       initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
       target:[Game sharedGame] action:@selector(syncData)];

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
  AssetBook* assetBook = [[Game sharedGame] assetBook];
  BOOL hidden = ([assetBook shortPositionCount] + [assetBook longPositionCount])
                != 0;
  [emptyView setHidden:hidden];
}

-(void)newGameData {
  [super newGameData];
  [self refreshEmptyView];
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

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

// The section number for short positions.
#define kShortsSection 0
// The section number for long positions.
#define kLongsSection 1

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if ([self tableView:tableView numberOfRowsInSection:section] == 0)
    return nil;

  switch (section) {
    case kShortsSection:
      return @"Shorts";
    case kLongsSection:
      return @"Longs";
    default:
      break;
  }
  return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  switch (section) {
    case kShortsSection:
      return [[[Game sharedGame] assetBook] shortPositionCount];
    case kLongsSection:
      return [[[Game sharedGame] assetBook] longPositionCount];
    default:
      break;
  }
    return -1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  StockTableViewCell *cell = (StockTableViewCell*)[super tableView:tableView
                         cellForRowAtIndexPath:indexPath];

  AssetBook* portfolio = [[Game sharedGame] assetBook];
  StockCache* stockCache = [[Game sharedGame] stockCache];
  Position* position;
  switch (indexPath.section) {
    case kShortsSection:
      position = [portfolio shortPositionAtIndex:indexPath.row];
      break;
    case kLongsSection:
      position = [portfolio longPositionAtIndex:indexPath.row];
      break;
    default:
      position = nil;
      break;
  }

  [cell setPosition:position
      stockInfo:[stockCache stockForTicker:[position ticker]]];
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


-(IBAction)placeOrderTapped:(id)sender {
  UINavigationController* ordersNavigationController =
      [self.tabBarController.viewControllers objectAtIndex:2];
  [self.tabBarController setSelectedViewController:ordersNavigationController];

  if ([[ordersNavigationController.viewControllers lastObject]
       isKindOfClass:[NewOrderViewController class]])
    return;

  NewOrderViewController* newOrderViewController =
  [[NewOrderViewController alloc] initWithNibName:@"NewOrderViewController"
                                           bundle:nil];
  [ordersNavigationController pushViewController:newOrderViewController
                                        animated:YES];
  // TODO(overmind): setup controller
  [newOrderViewController release];
}

-(IBAction)changeButtonWasTapped:(id)sender; {
}

@end


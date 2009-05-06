//
//  TickerSearchTableViewController.m
//  upside
//
//  Created by Victor Costan on 5/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TickerSearchTableViewController.h"

#import "StockSearchCommController.h"
#import "TickerSearchTableViewCell.h"


@implementation TickerSearchTableViewController

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

  self.narrowCellNib = @"TickerSearchTableCellNarrow";
  self.wideCellNib = @"TickerSearchTableCellNarrow";
  self.narrowCellReuseIdentifier = @"TickerSearchNarrow";
  self.wideCellReuseIdentifier = @"TickerSearchNarrow";
  self.cellClass = [TickerSearchTableViewCell class];
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [searchResults count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  TickerSearchTableViewCell* cell =
      (TickerSearchTableViewCell*)[super tableView:tableView
                             cellForRowAtIndexPath:indexPath];
  cell.stockData = [searchResults objectAtIndex:indexPath.row];

  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  StockSearchData* selectedStock = [searchResults objectAtIndex:indexPath.row];
  [[selectedStock retain] autorelease];
  [target performSelector:action withObject:selectedStock];
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
  [searchResults dealloc];  
  [super dealloc];
}

-(void)setSearchResults:(NSArray*)theSearchResults {
  [searchResults release];
  searchResults = [theSearchResults retain];
  [(UITableView*)self.view reloadData];
  [self.view setHidden:([searchResults count] == 0)];
}
-(NSArray*)searchResults {
  return searchResults;
}

-(void)setTarget:(id)theTarget action:(SEL)theAction {
  target = theTarget;
  action = theAction;
}

@end


//
//  RssFeedTableViewController.m
//  StockPlay
//
//  Created by Victor Costan on 1/10/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "RssFeedTableViewController.h"

#import "Game.h"
#import "NewsArticleViewController.h"
#import "NewsCenter.h"
#import "NewsItem.h"
#import "RssFeedTableViewCell.h"

@implementation RssFeedTableViewController

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

	self.narrowCellNib = @"RssFeedTableCellNarrow";
	self.wideCellNib = @"RssFeedTableCellNarrow";
	self.narrowCellReuseIdentifier = @"RssItemNarrow";
	self.wideCellReuseIdentifier = @"RssItemNarrow";
	self.cellClass = [RssFeedTableViewCell class];
	
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
    return [[[Game sharedGame] newsCenter] totalNewsForTitle:feedTitle];
}

-(void)setUpCell: (RssFeedTableViewCell*)cell 
	  forIndexPath: (NSIndexPath*)indexPath {	
	NewsItem* newsItem = [[[Game sharedGame] newsCenter]
						  newsItemForTitle:feedTitle
						  atIndex:indexPath.row];
	[cell setNewsItem:newsItem];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RssFeedTableViewCell* cell =
	    (RssFeedTableViewCell*)[super tableView:tableView
						  cellForRowAtIndexPath:indexPath];
    [self setUpCell:cell forIndexPath:indexPath];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NewsItem* newsItem = [[[Game sharedGame] newsCenter]
						  newsItemForTitle:feedTitle
						  atIndex:indexPath.row];
	
	NewsArticleViewController *articleViewController =
	    [[NewsArticleViewController alloc]
		 initWithNibName:@"NewsArticleViewController" bundle:nil];
	[self.navigationController pushViewController:articleViewController
	                                     animated:YES];
	articleViewController.newsItem = newsItem;
	[articleViewController release];
	[[[Game sharedGame] newsCenter] markAsReadItemWithId:[newsItem uid]];
	[(UITableView*)self.view reloadData];
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
	[feedTitle release];
    [super dealloc];
}

@synthesize feedTitle;

-(void)setFeedTitle: (NSString*) newFeedTitle {
	[feedTitle release];
	feedTitle = [newFeedTitle retain];
	
	self.navigationItem.title = feedTitle;
	[(UITableView*)self.view reloadData];
}

@end

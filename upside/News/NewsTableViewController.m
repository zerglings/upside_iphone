//
//  NewsTableViewController.m
//  upside
//
//  Created by Victor Costan on 1/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NewsTableViewController.h"

#import "Game.h"
#import "NewsTableViewCell.h"
#import "Portfolio.h"
#import "Portfolio+RSS.h"
#import "RssFeedTableViewController.h"


@implementation NewsTableViewController

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

	self.narrowCellReuseIdentifier = @"NewsFeedNarrow";
	self.wideCellReuseIdentifier = @"NewsFeedNarrow";
	self.narrowCellNib = @"NewsTableCellNarrow";
	self.wideCellNib = @"NewsTableCellNarrow";
	self.cellClass = [NewsTableViewCell class];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)viewWillAppear:(BOOL)animated {
	[(UITableView*)self.view reloadData];
  [super viewWillAppear:animated];
}
 
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

// The section number for short positions.
#define kShortsSection 0
// The section number for long positions.
#define kLongsSection 1

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case kShortsSection:
			return @"Short Positions";
		case kLongsSection:
			return @"Long Positions";
		default:
			break;
	}
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case kShortsSection:
			return [[[Game sharedGame] portfolio] shortPositionCount];
		case kLongsSection:
			return [[[Game sharedGame] portfolio] longPositionCount];
		default:
			break;
	}
    return -1;
}

- (NSString*)feedTitleForRowAtIndexPath: (NSIndexPath*)indexPath {
	Portfolio* portfolio = [[Game sharedGame] portfolio];
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
	return [Portfolio rssFeedTitleForTicker:[position ticker]];
}

- (UITableViewCell *)tableView: (UITableView *)tableView
         cellForRowAtIndexPath: (NSIndexPath *)indexPath {    
  NewsTableViewCell* cell = (NewsTableViewCell*)[super tableView:tableView
                                           cellForRowAtIndexPath:indexPath];
  
	[cell setFeedTitle:[self feedTitleForRowAtIndexPath:indexPath]];
  return cell;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
	RssFeedTableViewController *feedController =
      [[RssFeedTableViewController alloc]
       initWithNibName:@"RssFeedTableViewController" bundle:nil];
	[self.navigationController pushViewController:feedController animated:YES];
	[feedController setFeedTitle:[self feedTitleForRowAtIndexPath:indexPath]];
	[feedController release];
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


@end


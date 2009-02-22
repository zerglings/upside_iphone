//
//  OverviewViewController.m
//  StockPlay
//
//  Created by Victor Costan on 1/3/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "OverviewViewController.h"

#import "AssetBook+Formatting.h"
#import "Game.h"
#import "GameSyncController.h"
#import "TradeBook+Formatting.h"


@interface OverviewViewController ()
-(void)updateLastSyncTime;
@end

@implementation OverviewViewController

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
-(void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
-(void)viewDidLoad {
  [super viewDidLoad];
  [self newGameData];
  
  // TODO(overmind): do we need these?
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;  
}

-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self newGameData];
}

-(void)updateLastSyncTime {
  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
  [formatter setDateStyle:NSDateFormatterShortStyle];
  [formatter setTimeStyle:NSDateFormatterShortStyle];
  
  NSDate* lastSyncTime = [game lastSyncTime];
  if (lastSyncTime)
    lastSyncLabel.text = [formatter stringFromDate:lastSyncTime];
  else
    lastSyncLabel.text = @"never";
  [formatter release];
}
  
-(void)newGameData {
  AssetBook* assetBook = [game assetBook];
  StockCache* stockCache = [game stockCache];
  TradeBook* tradeBook = [game tradeBook];
  
  cashLabel.text = [[assetBook portfolio] formattedCash];
  stockWorthLabel.text = [assetBook formattedStockWorthWithCache:stockCache];
  netWorthLabel.text = [assetBook formattedNetWorthWithCache:stockCache];
  orderProceedsLabel.text = [tradeBook
                             formattedOrderProceedsWithCache:stockCache];
  
  cashImage.image = nil;
  stockWorthImage.image = nil;
  netWorthImage.image = nil;
  
  [self updateLastSyncTime];
}


// Override to allow orientations other than the default portrait orientation.
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


-(void)dealloc {
    [super dealloc];
}


@end

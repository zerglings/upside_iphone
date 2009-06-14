//
//  OrdersViewController.m
//  StockPlay
//
//  Created by Victor Costan on 6/14/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "OrdersViewController.h"

#import "Game.h"
#import "NewOrderViewController.h"
#import "OrdersTableViewController.h"


@implementation OrdersViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {

  }
  return self;
}

-(void)viewDidLoad {
  [super viewDidLoad];

  // For some reason Interface Builder is retarded and won't set these
  // attributes for us.
  self.view.autoresizingMask =
      UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

  self.navigationItem.leftBarButtonItem =
      [[UIBarButtonItem alloc]
       initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
       target:self action:@selector(tappedAddTradeButton:)];

  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc]
       initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
       target:[Game sharedGame] action:@selector(syncData)];
}

-(void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
  // Release anything that's not essential, such as cached data
}


-(void)dealloc {
  [super dealloc];
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  [tableViewController
   shouldAutorotateToInterfaceOrientation:interfaceOrientation];
  // Will rotate any way the user wants us to.
  [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
  return YES;
}

-(void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
                                                      duration:(NSTimeInterval)duration {
  [tableViewController
   willAnimateSecondHalfOfRotationFromInterfaceOrientation:fromInterfaceOrientation
   duration:duration];

  [super willAnimateSecondHalfOfRotationFromInterfaceOrientation:fromInterfaceOrientation
                                                        duration:duration];
}

-(void)newGameData {
  [tableViewController newGameData];
}


-(void)tappedAddTradeButton:(id)sender {
  NewOrderViewController* newOrderViewController =
  [[NewOrderViewController alloc] initWithNibName:@"NewOrderViewController"
                                           bundle:nil];
  [self.navigationController pushViewController:newOrderViewController
   animated:YES];
  // TODO(overmind): setup controller
  [newOrderViewController release];
}

-(IBAction)ordersFilterChanged:(id)sender {
  [tableViewController
   setOrdersFilter:[orderFilterControl selectedSegmentIndex]];
}

-(IBAction)placeOrderTapped:(id)sender {
  [self tappedAddTradeButton:sender];
}
@end

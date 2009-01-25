//
//  NewOrderViewController.m
//  upside
//
//  Created by Victor Costan on 1/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NewOrderViewController.h"

#import "Stock.h"
#import "Stock+Formatting.h"
#import "StockInfoCommController.h"

@implementation NewOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        stockInfoCommController = [[StockInfoCommController alloc] 
                                   initWithTarget:self
                                   action:@selector(receivedStockInfo:)];
    }
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"New Order";
  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithTitle:@"Place"
                                       style:UIBarButtonItemStyleDone
                                      target:self
                                      action:@selector(boo:)];
  
  [self limitTypeChanged:nil];
  [self orderTypeChanged:nil];
}

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


- (void)dealloc {
  [stockInfo release];
  [stockInfoCommController release];
  [super dealloc];
}


- (BOOL)chosenIsLimit {
  return [limitTypeSegmentedControl selectedSegmentIndex] == 1;
}

- (BOOL)chosenIsBuy {
  NSInteger selectedSegment = [orderTypeSegmentedControl selectedSegmentIndex];
  return (selectedSegment == 0) || (selectedSegment == 3);
}

- (BOOL)chosenIsLong {
  NSInteger selectedSegment = [orderTypeSegmentedControl selectedSegmentIndex];
  return (selectedSegment == 0) || (selectedSegment == 1);
}

- (IBAction)limitTypeChanged: (id)sender {
  if ([self chosenIsLimit]) {
    [limitText setEnabled:YES];
    limitText.text = @"";
  }
  else {
    [limitText setEnabled:NO];
    limitText.text = @"market price";
  }
}

- (IBAction)orderTypeChanged: (id)sender {
  if ([self chosenIsBuy]) {
    limitDescriptionLabel.text = @"Bid";
    [quantityAllButton setHidden:YES];
  }
  else {
    limitDescriptionLabel.text = @"Ask";
    [quantityAllButton setHidden:NO];
  }
}

- (void)updateEstimatedPrice {
  NSString* quantityString = quantityText.text;
  if ([quantityString length] == 0) {
    estimatedCostLabel.text = @"";
    return;
  }
  NSUInteger quantity = [quantityString integerValue];
  
}

- (void)updatedStockInfo {
  if ([stockInfo isValid]) {
    askPriceLabel.text = [stockInfo formattedAskPrice];
    bidPriceLabel.text = [stockInfo formattedBidPrice];
    askPriceChange.text = [stockInfo formattedPointAskChange];
    bidPriceChange.text = [stockInfo formattedPointBidChange];
    askPriceChangeImage.image = [stockInfo imageForAskChange];
    bidPriceChangeImage.image = [stockInfo imageForBidChange];
  }
  else {
    askPriceLabel.text = @"";
    bidPriceLabel.text = @"";
    askPriceChange.text = @"";
    bidPriceChange.text = @"";
    askPriceChangeImage.image = nil;
    bidPriceChangeImage.image = nil;
  }
}

- (BOOL)textFieldDidEndEditing: (UITextField*)textField {
  if (textField == tickerText) {
    [stockInfoCommController fetchInfoForTickers:
     [NSArray arrayWithObject:tickerText.text]];
  }
  else if (textField == quantityText) {
    [self updateEstimatedPrice];
  }
  else if (textField == limitText) {
    [self updateEstimatedPrice];
  }
  return YES;  
}

- (BOOL)textFieldShouldReturn: (UITextField*)textField {
  [textField resignFirstResponder];
  return YES;
}

- (void)touchesEnded: (NSSet*)touches withEvent: (UIEvent*)event {
  [tickerText resignFirstResponder];
  [quantityText resignFirstResponder];
  [limitText resignFirstResponder];
}

- (void)receivedStockInfo:(NSArray*)info {
  if (![info isKindOfClass:[NSArray class]]) {
    // communication error
    // TODO(overmind): place question mark for ticker validity
    return;
  }
  
  if ([info count] < 1) {
    // Yahoo is being rude to us
    // TODO(overmind): place question mark for ticker validity
    return;
  }
  
  Stock* receivedInfo = [info objectAtIndex:0];
  if (![[receivedInfo ticker] isEqualToString:tickerText.text]) {
    // Delayed info -- the user already typed something else 
    return;
  }

  [stockInfo release];
  stockInfo = [receivedInfo retain];
  [self updatedStockInfo];
}

@end

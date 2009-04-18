//
//  NewOrderViewController.m
//  StockPlay
//
//  Created by Victor Costan on 1/25/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "NewOrderViewController.h"

#import "AssetBook.h"
#import "Game.h"
#import "PendingOrdersSubmittingController.h"
#import "Portfolio+Formatting.h"
#import "Stock.h"
#import "Stock+Formatting.h"
#import "StockInfoCommController.h"
#import "TradeBook.h"
#import "TradeOrder.h"

@interface NewOrderViewController ()
-(void)reloadData;
-(void)updatedStockInfo;
-(void)updateEstimatedPrice;
@end


@implementation NewOrderViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    inputFormatter = [[NSNumberFormatter alloc] init];      
    stockInfoCommController = [[StockInfoCommController alloc] 
                               initWithTarget:self
                               action:@selector(receivedStockInfo:)];
  }
  return self;
}

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 -(void)loadView {
 }
 */

-(void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"New Order";
  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithTitle:@"Place"
                                       style:UIBarButtonItemStyleDone
                                      target:self
                                      action:@selector(placeTapped:)];  
  [self reloadData];
}

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


-(void)dealloc {
  [stockInfo release];
  [stockInfoCommController release];
  [super dealloc];
}


-(BOOL)chosenIsLimit {
  return [limitTypeSegmentedControl selectedSegmentIndex] == 1;
}

-(BOOL)chosenIsBuy {
  NSInteger selectedSegment = [orderTypeSegmentedControl selectedSegmentIndex];
  return (selectedSegment == 0) || (selectedSegment == 3);
}

-(BOOL)chosenIsLong {
  NSInteger selectedSegment = [orderTypeSegmentedControl selectedSegmentIndex];
  return (selectedSegment == 0) || (selectedSegment == 1);
}

-(NSUInteger)chosenQuantity {
  return [[inputFormatter numberFromString:quantityText.text]
          unsignedIntegerValue];
}

-(double)chosenLimitPrice {
  if (![self chosenIsLimit])
    return kTradeOrderInvalidLimit;
  
  NSString* limitString = [NSString stringWithFormat:@"%@.%02@",
                           limitDollarsText.text, limitCentsText.text];
  return [[inputFormatter numberFromString:limitString] doubleValue];
}

-(IBAction)limitTypeChanged:(id)sender {
  if ([self chosenIsLimit]) {
    [limitDollarsText setEnabled:YES];
    limitDollarsText.text = @"";
    [limitCentsText setHidden:NO];
    limitCentsText.text = @"";
    [limitCentSeparatorLabel setHidden:NO];
  }
  else {
    [limitDollarsText setEnabled:NO];
    limitDollarsText.text = @"market price";
    [limitCentsText setHidden:YES];
    [limitCentSeparatorLabel setHidden:YES];
  }
  [self updateEstimatedPrice];  
}

-(IBAction)orderTypeChanged:(id)sender {
  if ([self chosenIsBuy] == [self chosenIsLong]) {
    limitDescriptionLabel.text = @"Bid";
    [quantityAllButton setHidden:YES];
  }
  else {
    limitDescriptionLabel.text = @"Ask";
    [quantityAllButton setHidden:NO];
    if ([quantityText.text length] == 0 ||
        [quantityText.text isEqualToString:@"0"]) {
      // If the user wants to sell or cover, and they haven't filled out the
      //  quantity, pre-fill it with how many stocks they have.
      [self allTapped:nil];
    }
  }
  [self updateEstimatedPrice];
}

-(void)updateEstimatedPrice {
  Portfolio* portfolio = [[[Game sharedGame] assetBook] portfolio];
  if (portfolio) {
    availableCashLabel.text = [portfolio formattedCash];
    availableCashLabel.textColor = [portfolio colorForCash];    
  }
  else {
    availableCashLabel.text = @"N/A";
    availableCashLabel.textColor = [UIColor darkGrayColor];
  }
  
  NSString* quantityString = quantityText.text;
  if ([quantityString length] == 0) {
    estimatedCostLabel.text = @"";
    return;
  }
  NSUInteger quantity = [self chosenQuantity];
  if (stockInfo) {
    if ([self chosenIsLong] == [self chosenIsBuy]) {
      estimatedCostLabel.text = [stockInfo formattedValueUsingAskPriceFor:
                                 quantity];
    }
    else {
      estimatedCostLabel.text = [stockInfo formattedValueUsingBidPriceFor:
                                 quantity];            
    }
  }
  else {
    estimatedCostLabel.text = @"";
  }
}

-(void)updatedStockInfo {
  tickerValidityImage.image = [stockInfo imageForValidity];
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

-(void)reloadData {
  [self limitTypeChanged:nil];
  [self orderTypeChanged:nil];
  [self updatedStockInfo];
  [self updateEstimatedPrice];
}

-(BOOL)textFieldDidEndEditing:(UITextField*)textField {
  if (textField == tickerText) {
    tickerText.text = [tickerText.text uppercaseString];
    [stockInfoCommController fetchInfoForTickers:
     [NSArray arrayWithObject:tickerText.text]];
  }
  else if (textField == quantityText) {
    [self updateEstimatedPrice];
  }
  else if (textField == limitDollarsText) {
    [self updateEstimatedPrice];
  }
  else if (textField == limitCentsText) {
    [self updateEstimatedPrice];
  }
  return YES;  
}

-(BOOL)textField:(UITextField*)textField
    shouldChangeCharactersInRange:(NSRange)range
    replacementString:(NSString*)string {
  if (textField != limitCentsText)
    return YES;
  
  // Disallow changes that make the length > 2 characters.
  return ([textField.text length] - range.length + [string length]) <= 2;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField {
  [textField resignFirstResponder];
  return YES;
}

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
  [tickerText resignFirstResponder];
  [quantityText resignFirstResponder];
  [limitDollarsText resignFirstResponder];
  [limitCentsText resignFirstResponder];
}

-(void)receivedStockInfo:(NSArray*)info {
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

-(void)validationFailed:(NSString*) message {
  UIAlertView* alert = [[UIAlertView alloc]
                        initWithTitle:@"Your order is invalid"
                        message:message
                        delegate:nil
                        cancelButtonTitle:@"OK"
                        otherButtonTitles:nil];
  [alert show];
  [alert release];
}

-(BOOL)validate {
  if (stockInfo != nil && ![stockInfo isValid]) {
    [self validationFailed:@"The ticker you have entered does not exist"];
    return NO;
  }
  if ([tickerText.text length] == 0) {
    [self validationFailed:@"You have to enter a stock ticker"];
    return NO;
  }
  if ([quantityText.text length] == 0) {
    [self validationFailed:
     @"You have to specify how many shares you want to trade"];
    return NO;
  }
  if ([self chosenIsLimit] && [limitDollarsText.text length] == 0
          && [limitCentsText.text length] == 0) {
    [self validationFailed:
     @"You have not entered a limit price. You can either enter a limit "
     @"price, or place a market order."];
    return NO;
  }
  return YES;
}

-(TradeOrder*)newOrderFromUserChoices {
  return [[TradeOrder alloc] initWithTicker:tickerText.text
                                   quantity:[self chosenQuantity]
                                      isBuy:[self chosenIsBuy]
                                     isLong:[self chosenIsLong]
                                 limitPrice:[self chosenLimitPrice]];
}

-(IBAction)searchTapped:(id)sender {
  UIAlertView* alert =
  [[UIAlertView alloc]
   initWithTitle:@"Search is not ready"
   message:@"We know you want to search for tickers. We will bring that you asap."
   delegate:nil
   cancelButtonTitle:@"Fine :("
   otherButtonTitles:nil];
  [alert show];
  [alert release];
}

-(IBAction)allTapped:(id)sender {
  Position * position;
  if ([self chosenIsLong]) {
    position = [[[Game sharedGame] assetBook]
                longPositionWithTicker:tickerText.text];
  }
  else {
    position = [[[Game sharedGame] assetBook]
                shortPositionWithTicker:tickerText.text];
    
  }
  // A nil position should return 0.
  quantityText.text = [NSString stringWithFormat:@"%u", [position quantity]];
  [self updateEstimatedPrice];
}

-(void)placeTapped:(id)sender {
  if (![self validate])
    return;
  
  TradeOrder* order = [self newOrderFromUserChoices];
  [[[Game sharedGame] tradeBook] queuePendingOrder:order];
  [order release];
  [[[Game sharedGame] orderSubmittingController] syncOnce];
  
  [self.navigationController popViewControllerAnimated:YES];
}
@end

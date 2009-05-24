//
//  TickerSearchViewController.m
//  StockPlay
//
//  Created by Victor Costan on 5/5/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "TickerSearchViewController.h"

#import "StockSearchCommController.h"
#import "TickerSearchTableViewController.h"


@interface TickerSearchViewController ()
-(void)searchNeeded;
@end


@implementation TickerSearchViewController

@synthesize lastSearchText;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    // Custom initialization
    commController = [[StockSearchCommController alloc]
                      initWithTarget:self
                      action:@selector(stockSearchReturned:)];
    lastSearchTime = 0;
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
  self.title = @"Stock Symbol Search";
  if (defaultSearchText) {
    tickerSearchBar.text = defaultSearchText;
    [self searchNeeded];
  }
  tickerSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
  tickerSearchBar.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
  [resultsTableViewController setTarget:self action:@selector(selectedStock:)];
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
  [commController release];
  [lastSearchText release];
  [super dealloc];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  [self performSelector:@selector(searchNeeded) withObject:nil afterDelay:0.2];
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
  return YES;
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  [searchBar resignFirstResponder];
}


// Called when the search bar text is changed, and a new stock search is
// necessary to update the table results.
-(void)searchNeeded {
  if ([lastSearchText isEqualToString:tickerSearchBar.text]) {
    return;
  }
  NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
  if (now - lastSearchTime < 0.6) {
    // Do not fire more than one search per 0.6 seconds.
    [self performSelector:@selector(searchNeeded) withObject:nil
               afterDelay:0.2];
    return;
  }

  self.lastSearchText = [NSString stringWithString:tickerSearchBar.text];
  lastSearchTime = now;
  [commController startTickerSearch:lastSearchText];
}

-(void)selectedStock:(StockSearchData*)selectedStock {
  // Ensure that no search happens after this point.
  lastSearchTime = [NSDate timeIntervalSinceReferenceDate] + 100;
  resultsTableViewController = nil;

  NSString* tickerSymbol = selectedStock.symbol;
  [[tickerSymbol retain] autorelease];
  [target performSelector:action withObject:tickerSymbol];

  [self.navigationController popViewControllerAnimated:YES];
}

-(NSString*)defaultSearchText {
  return defaultSearchText;
}
-(void)setDefaultSearchText:(NSString*)theDefaultSearchText {
  if (!theDefaultSearchText || [theDefaultSearchText length] == 0) {
    return;
  }

  [defaultSearchText release];
  defaultSearchText = [theDefaultSearchText retain];

  if (tickerSearchBar) {
    tickerSearchBar.text = defaultSearchText;
  }
}

// Sets the target-action handling the user's stock selection.
-(void)setTarget:(id)theTarget action:(SEL)theAction {
  target = theTarget;
  action = theAction;
}

// Called by the stock search comm controller when results are available.
-(void)stockSearchReturned:(NSArray*)searchResults {
  if (![searchResults isKindOfClass:[NSArray class]]) {
    // TODO(overmind): handle error
    return;
  }

  NSMutableArray* filteredResults = [[NSMutableArray alloc]
                                     initWithCapacity:[searchResults count]];
  for (StockSearchData* result in searchResults) {
    if ([@"S" isEqualToString:result.type]) {
      [filteredResults addObject:result];
    }
  }
  resultsTableViewController.searchResults = filteredResults;
  [filteredResults release];
}
@end

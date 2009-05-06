//
//  TickerSearchViewController.h
//  upside
//
//  Created by Victor Costan on 5/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StockSearchCommController;
@class TickerSearchTableViewController;


@interface TickerSearchViewController : UIViewController <UISearchBarDelegate> {
  IBOutlet UISearchBar* searchBar;
  IBOutlet TickerSearchTableViewController* resultsTableViewController;
  
  StockSearchCommController* commController;
  NSString* defaultSearchText;
  NSString* lastSearchText;
  NSTimeInterval lastSearchTime;
  
  id target;
  SEL action;
}
// The query in the last issued ticker search.
@property (nonatomic,readwrite,retain) NSString* lastSearchText;
// The default query in the search UI.
@property (nonatomic,readwrite,retain) NSString* defaultSearchText;

// Sets the initial query text in the search UI.
-(void)setDefaultSearchText:(NSString*)defaultSearchText;

// Sets the target-action handling the user's stock selection.
-(void)setTarget:(id)target action:(SEL)action;

@end

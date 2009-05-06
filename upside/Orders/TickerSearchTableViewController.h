//
//  TickerSearchTableViewController.h
//  upside
//
//  Created by Victor Costan on 5/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameAwareTableViewController.h"


@interface TickerSearchTableViewController : GameAwareTableViewController {
  NSArray* searchResults;
  id target;
  SEL action;
}
// The ticker search results displayed in this controller's table. 
@property (nonatomic,readwrite,retain) NSArray* searchResults;

// Sets the target-action handling the user's stock selection.
-(void)setTarget:(id)target action:(SEL)action;

@end

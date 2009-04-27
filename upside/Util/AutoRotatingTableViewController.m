//
//  AutoRotatingTableViewController.m
//  StockPlay
//
//  Created by Victor Costan on 1/4/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "AutoRotatingTableViewController.h"


@implementation AutoRotatingTableViewController

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Will rotate any way the user wants us to.
  return YES;
}

-(void)viewWillAppear:(BOOL)animated {
  if (![self.wideCellReuseIdentifier
      isEqualToString:self.narrowCellReuseIdentifier]) {
    [(UITableView*)self.view reloadData];
  }

  [super viewWillAppear:animated];
}

-(void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
                              duration:(NSTimeInterval)duration {
  if (![self.wideCellReuseIdentifier
      isEqualToString:self.narrowCellReuseIdentifier]) {
    [(UITableView*)self.view reloadData];
  }

  [super willAnimateSecondHalfOfRotationFromInterfaceOrientation:fromInterfaceOrientation
                              duration:duration];
}

@synthesize wideCellReuseIdentifier;
@synthesize wideCellNib;
@synthesize narrowCellReuseIdentifier;
@synthesize narrowCellNib;
@synthesize cellClass;

+(UITableViewCell*)loadCellFromNib:(NSString*)nibName
                identifier:(NSString*)identifier
                   class:(Class)cellClass
                   owner:(id)owner {
  NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:nibName
                             owner:owner
                             options:nil];
  NSEnumerator* nibEnumerator = [nibContents objectEnumerator];

  NSObject* nibItem;
  while ((nibItem = [nibEnumerator nextObject])) {
    if (![nibItem isKindOfClass:cellClass])
      continue;
    UITableViewCell* stockTableViewCell = (UITableViewCell*)nibItem;
    if ([stockTableViewCell.reuseIdentifier isEqualToString:identifier])
      return stockTableViewCell;
  }
  NSLog(@"AutoRotatingTableViewController -loadFromNib didn't find the cell");
  return nil;
}


-(UITableViewCell *)tableView:(UITableView *)tableView
     cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString* cellIdentifier;
  NSString* cellNib;
  if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
    cellIdentifier = wideCellReuseIdentifier;
    cellNib = wideCellNib;
  }
  else {
    cellIdentifier = narrowCellReuseIdentifier;
    cellNib = narrowCellNib;
  }

    UITableViewCell *cell =  [tableView
                dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [AutoRotatingTableViewController loadCellFromNib:cellNib
                             identifier:cellIdentifier
                                class:cellClass
                                owner:self];
    }
  return cell;
}

-(void)dealloc {
  [wideCellReuseIdentifier release];
  [wideCellNib release];
  [narrowCellReuseIdentifier release];
  [narrowCellNib release];
  [cellClass release];
  [super dealloc];
}

@end

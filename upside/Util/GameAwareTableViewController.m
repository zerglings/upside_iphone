//
//  GameAwareTableViewController.m
//  StockPlay
//
//  Created by Victor Costan on 2/17/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "GameAwareTableViewController.h"

#import "ControllerSupport.h"
#import "Game.h"


@implementation GameAwareTableViewController

@synthesize game;

-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  _isVisible = YES;
  
  if (!_observingGameChanges) {
    game = [Game sharedGame];
    [game.newDataSite addTarget:self action:@selector(newGameDataAvailable)];
    _observingGameChanges = YES;
  }
  else if (_dataNeedsRefresh) {
    [self newGameData];
    _dataNeedsRefresh = NO;
  }
}

-(void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  _isVisible = NO;
}
-(void)dealloc {
  if (_observingGameChanges) {
    [game.newDataSite removeTarget:self action:@selector(newGameDataAvailable)];
  }
  [super dealloc];
}

-(void)newGameDataAvailable {
  if (_isVisible) {
    [self newGameData];
    _dataNeedsRefresh = NO;
  }
  else {
    _dataNeedsRefresh = YES;
  }
}

-(void)viewDidLoad {
  // NOTE: ideally, we'd override an initializer. Except UITableViewController's
  //       header does not give a designated initializer.
  //       No, -initWithStyle: doesn't work.
  
  [super viewDidLoad];
  _observingGameChanges = NO;
  _isVisible = NO;
  _dataNeedsRefresh = NO;    
}

-(void)newGameData {
  [(UITableView*)self.view reloadData];
}

@end

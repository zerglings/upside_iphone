//
//  GameAwareViewController.m
//  StockPlay
//
//  Created by Victor Costan on 2/17/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "GameAwareViewController.h"

#import "ControllerSupport.h"
#import "Game.h"


@implementation GameAwareViewController

@synthesize game;

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  if (!game)
    game = [Game sharedGame];
  [game.newDataSite addTarget:self action:@selector(newGameData)];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
  [game.newDataSite removeTarget:self action:@selector(newGameData)];
}

-(void)newGameData {
  [(UITableView*)self.view reloadData];
}

@end

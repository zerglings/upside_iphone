//
//  GameAwareTableViewController.h
//  StockPlay
//
//  Created by Victor Costan on 2/17/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "AutoRotatingTableViewController.h"

@class Game;

@interface GameAwareTableViewController : AutoRotatingTableViewController {
  IBOutlet Game* game;
}

// The game data connected to this table.
@property (nonatomic, assign) Game* game;

// Subclasses can override this to react to game data updates. Subclasses should
// call the superclass implementation.
- (void)newGameData;

@end

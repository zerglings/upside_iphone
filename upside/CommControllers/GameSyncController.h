//
//  GameSyncController.h
//  upside
//
//  Created by Victor Costan on 1/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SyncController.h"

@class Game;
@class LoginCommController;
@class PortfolioCommController;

@interface GameSyncController : SyncController {
	Game* game;
	PortfolioCommController* commController;
	LoginCommController* loginCommController;
}


// Designated initializer.
- (id) initWithGame: (Game*)game;

@end

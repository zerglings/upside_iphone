//
//  GameSyncController.h
//  upside
//
//  Created by Victor Costan on 1/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ControllerSupport.h"

@class Game;
@class LoginCommController;
@class PortfolioCommController;

@interface GameSyncController : ZNSyncController {
	Game* game;
	PortfolioCommController* commController;
	LoginCommController* loginCommController;
}


// Designated initializer.
- (id) initWithGame: (Game*)game;

@end

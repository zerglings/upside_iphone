//
//  GameSyncController.h
//  upside
//
//  Created by Victor Costan on 1/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Game;
@class LoginCommController;
@class PortfolioCommController;

@interface GameSyncController : NSObject {
	Game* game;
	PortfolioCommController* commController;
	LoginCommController* loginCommController;
	double syncInterval;
}

- (id) initWithGame: (Game*)game;

- (void) startSyncing;

@end

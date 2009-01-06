//
//  Game.h
//  upside
//
//  Created by Victor Costan on 1/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Portfolio;
@class TradeBook;

@interface Game : NSObject {
	Portfolio* portfolio;
	TradeBook* tradeBook;
}

// The singleton Game instance.
+ (Game*)sharedGame;

#pragma mark Accessors

@property (nonatomic, readonly) Portfolio* portfolio;
@property (nonatomic, readonly) TradeBook* tradeBook;

@end

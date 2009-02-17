//
//  PortfolioCommController.h
//  StockPlay
//
//  Created by Victor Costan on 1/23/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <Foundation/Foundation.h>

// Retrieves portfolio sync data.
@interface PortfolioCommController : NSObject {
	NSDictionary* responseModels;
	SEL action;
	id target;
}

-(id)initWithTarget: (id)target action: (SEL)action;

-(void)sync;

@end

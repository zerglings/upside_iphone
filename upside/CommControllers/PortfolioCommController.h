//
//  PortfolioCommController.h
//  upside
//
//  Created by Victor Costan on 1/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PortfolioCommController : NSObject {
	NSDictionary* responseModels;
	SEL action;
	id target;
}

- (id)initWithTarget: (id)target action: (SEL)action;

- (void)sync;

@end

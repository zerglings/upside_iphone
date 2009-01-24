//
//  StockInfoCommController.h
//  upside
//
//  Created by Victor Costan on 1/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockInfoCommController : NSObject {
	NSString* service;
	NSArray* responseProperties;
	NSString* formatString;
	SEL action;
	id target;
}

- (id)initWithTarget: (id)target action: (SEL)action;

- (void)fetchInfoForTickers: (NSArray*)tickers;

@end

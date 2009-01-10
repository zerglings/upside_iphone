//
//  Portfolio+FormattingTest.m
//  upside
//
//  Created by Victor Costan on 1/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GTMSenTestCase.h"
#import "Portfolio.h"
#import "Portfolio+Formatting.h"

@interface PortfolioFormattingTest : SenTestCase {
	Portfolio* portfolio;
}
@end

@implementation PortfolioFormattingTest

- (void) setUp {
	portfolio = [[Portfolio alloc] init];
	[portfolio loadData:[NSDictionary dictionaryWithObjectsAndKeys:
						 [NSNumber numberWithUnsignedInt:10000],
						 @"AAPL",
						 [NSNumber numberWithUnsignedInt:35],
						 @"MSFT"]];
}

- (void) tearDown {
	[portfolio release];
}



@end

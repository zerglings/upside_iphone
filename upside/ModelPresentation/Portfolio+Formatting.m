//
//  Portfolio+Formatting.m
//  upside
//
//  Created by Victor Costan on 1/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Portfolio.h"
#import "Portfolio+Formatting.h"

@implementation Portfolio (Formatting)

#pragma mark Lifecycle

static NSNumberFormatter* countFormatter = nil;

#pragma mark Formatting

static void SetupFormatters() {
	@synchronized([Stock class]) {
		if (countFormatter == nil) {
			countFormatter = [[NSNumberFormatter alloc] init];
			[countFormatter setPositiveFormat:@"#,##0"];
			[countFormatter setNegativeFormat:@"-#,##0"];
		}
	}
}

+ (NSString*) formatStockOwned: (NSUInteger) stockOwned {
	SetupFormatters();
	return [countFormatter stringFromNumber:[NSNumber numberWithUnsignedInt:
											 stockOwned]];
}

- (NSString*) formattedStockOwnedForTicker: (NSString*) ticker {
	return [Portfolio formatStockOwned:[self stockOwnedForTicker:ticker]];
}

@end

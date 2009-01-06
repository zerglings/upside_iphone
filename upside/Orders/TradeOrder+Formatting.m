//
//  TradeOrder+Formatting.m
//  upside
//
//  Created by Victor Costan on 1/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TradeOrder.h"
#import "TradeOrder+Formatting.h"


@implementation TradeOrder (Formatting)

#pragma mark Lifecycle

static NSNumberFormatter* quantityFormatter = nil;
static NSNumberFormatter* priceFormatter = nil;

#pragma mark Formatting

static void SetupFormatters() {
	@synchronized([TradeOrder class]) {
		if (quantityFormatter == nil) {
			quantityFormatter = [[NSNumberFormatter alloc] init];
			[quantityFormatter setPositiveFormat:@"#,##0"];
			
			priceFormatter = [[NSNumberFormatter alloc] init];
			[priceFormatter setPositiveFormat:@"$#,##0.00"];
		}
	}
}

- (NSString*) formattedQuantity {
	SetupFormatters();
	return [quantityFormatter stringFromNumber:[NSNumber numberWithUnsignedInt:
												[self quantity]]];
}

- (NSString*) formattedLimitPrice {
	SetupFormatters();
	
	if(![self isLimitOrder]) {
		return @"mkt";
	}
	
	return [priceFormatter stringFromNumber:[NSNumber numberWithDouble:
											 [self limitPrice]]];
}

@end

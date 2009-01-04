//
//  StockFormatter.m
//  upside
//
//  Created by Victor Costan on 1/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StockFormatter.h"


@implementation StockFormatter

#pragma mark Formatting

- (void) setupFormatters {
	[countFormatter setPositiveFormat:@"#,##0"];
	[countFormatter setNegativeFormat:@"-#,##0"];
	
	[priceFormatter setPositiveFormat:@"$#,##0.00"];
	
	[pointChangeFormatter setPositiveFormat:@"+#,##0.00%"];
	[pointChangeFormatter setNegativeFormat:@"-#,##0.00%"];
	
	[netChangeFormatter setPositiveFormat:@"+#,##0.00"];
	[netChangeFormatter setNegativeFormat:@"-#,##0.00"];
}

- (NSString*) ownCountFor:(Stock*)stock {
	return [countFormatter stringFromNumber:[stock objectForKey:kStockHeld]];
}

- (NSString*) formatPrice: (NSUInteger)priceInCents {
	return [priceFormatter stringFromNumber:
			[NSNumber numberWithDouble:(priceInCents / 100.0)]];
}

- (NSString*) askPriceFor: (Stock*)stock {
	return [self formatPrice:[[stock objectForKey:kStockAskCents]
							  unsignedIntValue]];
}

- (NSString*) bidPriceFor: (Stock*)stock {
	return [self formatPrice:[[stock objectForKey:kStockBidCents]
							  unsignedIntValue]];
}

- (NSString*) formatValueFor:(NSUInteger)count
				  usingPrice:(NSUInteger)priceInCents {
	return [priceFormatter stringFromNumber:[NSNumber numberWithDouble:
											 ((count * priceInCents) / 100.0)]];
}

- (NSString*) valueUsingAskPriceFor:(Stock*)stock {
	return [self formatValueFor:[[stock objectForKey:kStockHeld]
								 unsignedIntValue]
					 usingPrice:[[stock objectForKey:kStockAskCents]
								 unsignedIntValue]];
}
- (NSString*) valueUsingBskPriceFor:(Stock*)stock {
	return [self formatValueFor:[[stock objectForKey:kStockHeld]
								 unsignedIntValue]
					 usingPrice:[[stock objectForKey:kStockBidCents]
								 unsignedIntValue]];
}

- (NSString*) formatChange: (NSUInteger)newPriceInCents
					  from: (NSUInteger)oldPriceInCents
					 point: (BOOL)usePointChange {
	double change = ((double)newPriceInCents - oldPriceInCents) / 100.0;
	if (!usePointChange) {
		return [netChangeFormatter stringFromNumber:[NSNumber
													 numberWithDouble:change]];
	}
	double pointChange = (change * 100.0) / oldPriceInCents;
	return [pointChangeFormatter stringFromNumber:
			[NSNumber numberWithDouble:pointChange]];
}
	
- (NSString*) netAskChangeFor: (Stock*)stock {
	return [self formatChange:[[stock objectForKey:kStockAskCents]
							   unsignedIntValue]
						 from:[[stock objectForKey:kStockLastAskCents]
							   unsignedIntValue]
						point:NO];
}

- (NSString*) pointAskChangeFor: (Stock*)stock {
	return [self formatChange:[[stock objectForKey:kStockAskCents]
							   unsignedIntValue]
						 from:[[stock objectForKey:kStockLastAskCents]
							   unsignedIntValue]
						point:YES];
}

- (NSString*) netBidChangeFor: (Stock*)stock {
	return [self formatChange:[[stock objectForKey:kStockBidCents]
							   unsignedIntValue]
						 from:[[stock objectForKey:kStockLastBidCents]
							   unsignedIntValue]
						point:NO];
}


- (NSString*) pointBidChangeFor: (Stock*)stock {
	return [self formatChange:[[stock objectForKey:kStockBidCents]
							   unsignedIntValue]
						 from:[[stock objectForKey:kStockLastBidCents]
							   unsignedIntValue]
						point:YES];	
}

- (UIImage*) imageForChange: (NSUInteger)currentValue
					   from: (NSUInteger)oldValue {
	if (oldValue < currentValue)
		return [UIImage imageNamed:@"GreenUpArrow.png"];
	if (oldValue > currentValue)
		return [UIImage imageNamed:@"RedDownArrow.png"];
	return nil;
}

- (UIColor*) colorForChange: (NSUInteger)currentValue
					   from: (NSUInteger)oldValue {	
	if (oldValue < currentValue)
		return [UIColor colorWithRed:0.0f green:0.5f blue:0.0f alpha:1.0f];
	if (oldValue > currentValue)
		return [UIColor colorWithRed:0.5f green:0.0f blue:0.0f alpha:1.0f];
	return [UIColor darkGrayColor];
}

- (UIColor*) askChangeColorFor:(Stock*)stock {
	return [self colorForChange:[[stock objectForKey:kStockAskCents]
								 unsignedIntValue]
						   from:[[stock objectForKey:kStockLastAskCents]
								 unsignedIntValue]];	
}
- (UIColor*) bidChangeColorFor:(Stock*)stock {
	return [self colorForChange:[[stock objectForKey:kStockBidCents]
								 unsignedIntValue]
						   from:[[stock objectForKey:kStockLastBidCents]
								 unsignedIntValue]];	
}
- (UIImage*) askChangeImageFor:(Stock*)stock {
	return [self imageForChange:[[stock objectForKey:kStockAskCents]
								 unsignedIntValue]
						   from:[[stock objectForKey:kStockLastAskCents]
								 unsignedIntValue]];	
}
- (UIImage*) bidChangeImageFor:(Stock*)stock {
	return [self imageForChange:[[stock objectForKey:kStockAskCents]
								 unsignedIntValue]
						   from:[[stock objectForKey:kStockLastAskCents]
								 unsignedIntValue]];	
}


#pragma mark Lifecycle

- (id) init {
	if ((self = [super init])) {
		priceFormatter = [[NSNumberFormatter alloc] init];
		pointChangeFormatter = [[NSNumberFormatter alloc] init];
		netChangeFormatter = [[NSNumberFormatter alloc] init];
		[self setupFormatters];
	}
	return self;
}

- (void) dealloc {
	[priceFormatter release];
	[pointChangeFormatter release];
	[netChangeFormatter release];
	
	[super dealloc];
}

#pragma mark Singleton

static StockFormatter* sharedFormatter = nil;

+ (StockFormatter*) sharedFormatter {
	@synchronized(self) {
		if (sharedFormatter == nil) {
			sharedFormatter = [[StockFormatter alloc] init];
		}
	}
	return sharedFormatter;
}

@end

//
//  StockFormatter.m
//  upside
//
//  Created by Victor Costan on 1/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Stock.h"
#import "Stock+Formatting.h"


@implementation Stock (Formatting)

#pragma mark Lifecycle

static NSNumberFormatter* countFormatter = nil;
static NSNumberFormatter* priceFormatter = nil;
static NSNumberFormatter* netChangeFormatter = nil;
static NSNumberFormatter* pointChangeFormatter = nil;

#pragma mark Formatting

static void SetupFormatters() {
	@synchronized([Stock class]) {
		if (countFormatter == nil) {
			countFormatter = [[NSNumberFormatter alloc] init];
			[countFormatter setPositiveFormat:@"#,##0"];
			[countFormatter setNegativeFormat:@"-#,##0"];
						
			priceFormatter = [[NSNumberFormatter alloc] init];
			[priceFormatter setPositiveFormat:@"$#,##0.00"];
			
			pointChangeFormatter = [[NSNumberFormatter alloc] init];
			[pointChangeFormatter setPositiveFormat:@"+#,##0.00%"];
			[pointChangeFormatter setNegativeFormat:@"-#,##0.00%"];
			
			netChangeFormatter = [[NSNumberFormatter alloc] init];
			[netChangeFormatter setPositiveFormat:@"+#,##0.00"];
			[netChangeFormatter setNegativeFormat:@"-#,##0.00"];
		}
	}
}

+ (NSString*) formattedPrice: (double)price {
	SetupFormatters();
	return [priceFormatter stringFromNumber:[NSNumber numberWithDouble:price]];
}

- (NSString*) formattedAskPrice {
	return [Stock formattedPrice:[self askPrice]];
}

- (NSString*) formattedBidPrice {
	return [Stock formattedPrice:[self bidPrice]];
}

+ (NSString*) formatValueFor: (NSUInteger)count
				  usingPrice: (NSUInteger)priceInCents {
	SetupFormatters();
	return [priceFormatter stringFromNumber:[NSNumber numberWithDouble:
											 ((count * priceInCents) / 100.0)]];
}

- (NSString*) formattedValueUsingAskPriceFor: (NSUInteger)stockCount {
	return [Stock formatValueFor:stockCount usingPrice:[self askCents]];
}
- (NSString*) formattedValueUsingBidPriceFor: (NSUInteger)stockCount {
	return [Stock formatValueFor:stockCount usingPrice:[self bidCents]];
}

+ (NSString*) formatChange: (NSUInteger)newPriceInCents
					  from: (NSUInteger)oldPriceInCents
					 point: (BOOL)usePointChange {
	SetupFormatters();
	double change = ((double)newPriceInCents - oldPriceInCents) / 100.0;
	if (!usePointChange) {
		return [netChangeFormatter stringFromNumber:[NSNumber
													 numberWithDouble:change]];
	}
	double pointChange = (change * 100.0) / oldPriceInCents;
	return [pointChangeFormatter stringFromNumber:
			[NSNumber numberWithDouble:pointChange]];
}
	
- (NSString*) formattedNetAskChange {
	return [Stock formatChange:[self askCents]
				 		  from:[self lastAskCents]
						 point:NO];
}

- (NSString*) formattedPointAskChange {
	return [Stock formatChange:[self askCents]
						  from:[self lastAskCents]
						 point:YES];
}

- (NSString*) formattedNetBidChange {
	return [Stock formatChange:[self bidCents]
						  from:[self lastBidCents]
						 point:NO];
}


- (NSString*) formattedPointBidChange {
	return [Stock formatChange:[self bidCents]
						  from:[self lastBidCents]
						 point:YES];
}

+ (UIImage*) imageForChange: (NSUInteger)currentValue
					   from: (NSUInteger)oldValue {
	if (oldValue < currentValue)
		return [UIImage imageNamed:@"GreenUpArrow.png"];
	if (oldValue > currentValue)
		return [UIImage imageNamed:@"RedDownArrow.png"];
	return nil;
}

+ (UIColor*) colorForChange: (NSUInteger)currentValue
					   from: (NSUInteger)oldValue {
	if (oldValue < currentValue)
		return [UIColor colorWithRed:0.0f green:0.5f blue:0.0f alpha:1.0f];
	if (oldValue > currentValue)
		return [UIColor colorWithRed:0.5f green:0.0f blue:0.0f alpha:1.0f];
	return [UIColor darkGrayColor];
}

- (UIColor*) colorForAskChange {
	return [Stock colorForChange:[self askCents]
						    from:[self lastAskCents]];	
}
- (UIColor*) colorForBidChange {
	return [Stock colorForChange:[self bidCents]
						    from:[self lastBidCents]];	
}
- (UIImage*) imageForBidChange {
	return [Stock imageForChange:[self askCents]
						    from:[self lastAskCents]];	
}
- (UIImage*) imageForAskChange {
	return [Stock imageForChange:[self bidCents]
						    from:[self lastBidCents]];	
}

@end

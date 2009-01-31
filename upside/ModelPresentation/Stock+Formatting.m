//
//  StockFormatter.m
//  StockPlay
//
//  Created by Victor Costan on 1/4/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "Stock+Formatting.h"


@implementation Stock (Formatting)

#pragma mark Formatting

static NSNumberFormatter* countFormatter = nil;
static NSNumberFormatter* priceFormatter = nil;
static NSNumberFormatter* netChangeFormatter = nil;
static NSNumberFormatter* pointChangeFormatter = nil;

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

+(NSString*)formattedPrice: (double)price {
	SetupFormatters();
	return [priceFormatter stringFromNumber:[NSNumber numberWithDouble:price]];
}

-(NSString*)formattedAskPrice {
	return [Stock formattedPrice:askPrice];
}

-(NSString*)formattedBidPrice {
	return [Stock formattedPrice:bidPrice];
}

-(NSString*)formattedTradePrice {
	return [Stock formattedPrice:lastTradePrice];
}

+(NSString*)formatValueFor: (NSUInteger)count
				  usingPrice: (double)price {
	SetupFormatters();
	return [priceFormatter stringFromNumber:[NSNumber numberWithDouble:
											 (count * price)]];
}

-(NSString*)formattedValueUsingAskPriceFor: (NSUInteger)stockCount {
	return [Stock formatValueFor:stockCount usingPrice:askPrice];
}
-(NSString*)formattedValueUsingBidPriceFor: (NSUInteger)stockCount {
	return [Stock formatValueFor:stockCount usingPrice:bidPrice];
}
-(NSString*)formattedValueUsingTradePriceFor: (NSUInteger)stockCount {
	return [Stock formatValueFor:stockCount usingPrice:lastTradePrice];
}

+(NSString*)formatChange: (double)newPrice
					  from: (double)oldPrice
					 point: (BOOL)usePointChange {
	SetupFormatters();
	double change = newPrice - oldPrice;
	if (!usePointChange) {
		return [netChangeFormatter stringFromNumber:[NSNumber
													 numberWithDouble:change]];
	}
	double pointChange = change / oldPrice;
	return [pointChangeFormatter stringFromNumber:
			[NSNumber numberWithDouble:pointChange]];
}
	
-(NSString*)formattedNetAskChange {
	return [Stock formatChange:askPrice
				 		  from:previousClosePrice
						 point:NO];
}

-(NSString*)formattedPointAskChange {
	return [Stock formatChange:askPrice
						  from:previousClosePrice
						 point:YES];
}

-(NSString*)formattedNetBidChange {
	return [Stock formatChange:bidPrice
						  from:previousClosePrice
						 point:NO];
}

-(NSString*)formattedPointBidChange {
	return [Stock formatChange:bidPrice
						  from:previousClosePrice
						 point:YES];
}

-(NSString*)formattedNetTradeChange {
	return [Stock formatChange:lastTradePrice
						  from:previousClosePrice
						 point:NO];
}

-(NSString*)formattedPointTradeChange {
	return [Stock formatChange:lastTradePrice
						  from:previousClosePrice
						 point:YES];
}

+(UIImage*)imageForChange: (double)currentValue
					   from: (double)oldValue {
  NSAssert([UIImage imageNamed:@"GreenUpArrow.png"] != nil,
           @"GreenUpArrow.png not available");
  NSAssert([UIImage imageNamed:@"RedDownArrow.png"] != nil,
           @"RedDownArrow.png not available");
  
	if (oldValue < currentValue)
		return [UIImage imageNamed:@"GreenUpArrow.png"];
	if (oldValue > currentValue)
		return [UIImage imageNamed:@"RedDownArrow.png"];
	return nil;
}

+(UIColor*)colorForChange: (double)currentValue
					   from: (double)oldValue {
	if (oldValue < currentValue)
		return [UIColor colorWithRed:0.0f green:0.5f blue:0.0f alpha:1.0f];
	if (oldValue > currentValue)
		return [UIColor colorWithRed:0.5f green:0.0f blue:0.0f alpha:1.0f];
	return [UIColor darkGrayColor];
}

-(UIColor*)colorForAskChange {
	return [Stock colorForChange:askPrice
						    from:previousClosePrice];	
}
-(UIColor*)colorForBidChange {
	return [Stock colorForChange:bidPrice
						    from:previousClosePrice];	
}
-(UIColor*)colorForTradeChange {
	return [Stock colorForChange:lastTradePrice
						    from:previousClosePrice];	
}
-(UIImage*)imageForAskChange {
	return [Stock imageForChange:askPrice
						    from:previousClosePrice];
}
-(UIImage*)imageForBidChange {
	return [Stock imageForChange:bidPrice
						    from:previousClosePrice];	
}
-(UIImage*)imageForTradeChange {
	return [Stock imageForChange:lastTradePrice
						    from:previousClosePrice];	
}

-(UIImage*)imageForValidity {
  NSAssert([UIImage imageNamed:@"GreenTick.png"] != nil,
           @"GreenTick.png not available");
  NSAssert([UIImage imageNamed:@"RedX.png"] != nil,
           @"RedX.png not available");
  
  if ([self isValid])
    return [UIImage imageNamed:@"GreenTick.png"];
  else
    return [UIImage imageNamed:@"RedX.png"];
}

@end

//
//  StockCache.m
//  StockPlay
//
//  Created by Victor Costan on 1/6/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "StockCache.h"

#import "Stock.h"
#import "StockInfoCommController.h"

@implementation StockCache

#pragma mark I/O

-(void)load {
	// TODO(overmind): code this up
}

-(void)save {
	// TODO(overmind): code this up
}

#pragma mark Lifecycle

- (id)init {
	if ((self = [self initWithErrorModelClass:nil syncInterval:60.0])) {
		stocks = [[NSMutableDictionary alloc] init];
		commController = [[StockInfoCommController alloc]
						  initWithTarget:self
								  action:@selector(receivedResults:)];
	}
	return self;
}

- (void)dealloc {
	[stocks release];
	[super dealloc];
}

#pragma mark Update Cycle

-(void)sync {
	[commController fetchInfoForTickers:[stocks allKeys]];
}

-(BOOL)integrateResults: (NSArray*)newStocks {
	for (Stock* stock in newStocks) {
		// TODO(overmind): merge new model info with what was there before
		[stocks setObject:stock forKey:[stock ticker]];
	}
  return YES;
}

#pragma mark Cache Access

- (Stock*)stockForTicker:(NSString*)stockTicker {
	Stock* stockInfo = [stocks objectForKey:stockTicker];
	if (stockInfo) {
		if ([stockInfo isKindOfClass:[NSNull class]])
			return nil;
		else
			return stockInfo;
	}
	
	// We don't have stock information, so let's queue it up.
	[stocks setObject:[NSNull null] forKey:stockTicker];
	return nil;
}

@end

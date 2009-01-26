//
//  PendingOrdersSubmittingController.m
//  upside
//
//  Created by Victor Costan on 1/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PendingOrdersSubmittingController.h"

#import "ActivationState.h"
#import "LoginCommController.h"
#import "ServiceError.h"
#import "TradeBook.h"
#import "TradeOrder.h"
#import "TradeOrderCommController.h"

@interface PendingOrdersSubmittingController () <LoginCommDelegate>
@end

@implementation PendingOrdersSubmittingController

- (id)initWithTradeBook: (TradeBook*)theTradeBook {
  if ((self = [super initWithErrorModelClass:[ServiceError class]
                                syncInterval:60.0])) {
    tradeBook = theTradeBook;
    lastSubmittedOrder = nil;
    
    commController = [[TradeOrderCommController alloc]
                      initWithTarget:self
                      action:@selector(receivedResults:)];
		loginCommController = [[LoginCommController alloc] init];
		loginCommController.delegate = self;
  }
  return self;
}

- (void)dealloc {
  [commController release];
  [loginCommController release];
  [super dealloc];
}

- (void) sync {
  if (lastSubmittedOrder)
    return;  // pending order not submitted yet
  
  TradeOrder* nextOrder = [tradeBook firstPendingOrder];
  if (nextOrder == nil)
    return;
  lastSubmittedOrder = nextOrder;
	[commController submitOrder:nextOrder];
}


- (BOOL) integrateResults: (NSArray*)results {
  TradeOrder* submittedOrder = [results objectAtIndex:0];
	[tradeBook dequeuePendingOrder:lastSubmittedOrder submitted:submittedOrder];
  lastSubmittedOrder = nil;
  [self sync];
  return NO;
}

- (BOOL) handleServiceError: (ServiceError*)error {
	if ([error isLoginError]) {
    lastSubmittedOrder = nil;
		[loginCommController loginUsing:[ActivationState sharedState]];
    return NO;
	}
  
  if ([error isValidationError]) {
    // TODO(overmind): should take this order out of the queue, and put it in
    //                 a list where the user could see it; then proceed to the
    //                 next order to be submitted
    ;
  }
  
  lastSubmittedOrder = nil;
  return YES;
}
    
- (void) handleSystemError: (NSError*)error {
    lastSubmittedOrder = nil;
}


- (void)loginFailed: (NSError*)error {
	// TODO(overmind): user changed their password, recover from this
}

- (void)loginSucceeded {
	// This happens if we login after syncing failed.
	// So we need to resume syncing.
	[self sync];
}


@end

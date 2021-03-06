//
//  PendingOrdersSubmittingController.m
//  StockPlay
//
//  Created by Victor Costan on 1/26/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "PendingOrdersSubmittingController.h"

#import "RegistrationState.h"
#import "LoginCommController.h"
#import "ServiceError.h"
#import "TradeBook.h"
#import "TradeOrder.h"
#import "TradeOrderCommController.h"

@interface PendingOrdersSubmittingController () <LoginCommDelegate>
@end

@implementation PendingOrdersSubmittingController

-(id)initWithTradeBook:(TradeBook*)theTradeBook {
  if ((self = [super initWithErrorModelClass:[ServiceError class]
                                syncInterval:60.0])) {
    tradeBook = theTradeBook;

    commController = [[TradeOrderCommController alloc]
                      initWithTarget:self
                      action:@selector(receivedResults:)];
    loginCommController = [[LoginCommController alloc] init];
    loginCommController.delegate = self;
  }
  return self;
}

-(void)dealloc {
  [commController release];
  [loginCommController release];
  [super dealloc];
}

-(void)sync {
  TradeOrder* nextOrder = [tradeBook firstPendingOrder];
  if (!nextOrder) {
    [self receivedResults:nil];
    return;  // pending order not submitted yet
  }
  [commController submitOrder:nextOrder];
}


-(BOOL)integrateResults:(NSArray*)results {
  if ([results count] != 1)
    return YES;  // communication error in disguise

  TradeOrder* submittedOrder = [results objectAtIndex:0];
  [tradeBook submittedOrder:submittedOrder];

  if (![tradeBook firstPendingOrder])
    return YES;  // submitted all orders, go to sleep until needed

  [self sync];
  return NO;
}

-(BOOL)handleServiceError:(ServiceError*)error {
  if ([error isLoginError]) {
    [loginCommController loginUsing:[RegistrationState sharedState]];
    return NO;
  }

  if ([error isValidationError]) {
    // TODO(overmind): should take this order out of the queue, and put it in
    //                 a list where the user could see it; then proceed to the
    //                 next order to be submitted
    ;
  }

  return YES;
}

-(void)handleSystemError:(NSError*)error {
}

-(void)loginFailed:(NSError*)error {
  // TODO(overmind): user changed their password, recover from this
}

-(void)loginSucceeded {
  // This happens if we login after syncing failed.
  [self resumeSyncing];
}


@end

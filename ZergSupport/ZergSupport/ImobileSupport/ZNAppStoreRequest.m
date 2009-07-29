//
//  ZNAppStoreRequest.m
//  ZergSupport
//
//  Created by Victor Costan on 7/21/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNAppStoreRequest.h"

#import <StoreKit/StoreKit.h>


@interface ZNAppStoreRequest () <SKProductsRequestDelegate,
                                 SKPaymentTransactionObserver>
@end


@implementation ZNAppStoreRequest

#pragma mark Lifecycle

-(id)initWithTarget:(id)theTarget action:(SEL)theAction {
  if ((self = [super init])) {
    target = theTarget;
    action = theAction;
    skRequest = nil;
    skPayment = nil;
    skTransaction = nil;
    skTransactionId = nil;
    unwrapProductInfo = NO;
  }
  return self;
}
-(void)dealloc {
  [skRequest release];
  [skPayment release];
  [skTransaction release];
  [skTransactionId release];
  [super dealloc];
}

#pragma mark Request Preparation

-(void)getInfoForProductIds:(NSArray*)productIds
          unwrapProductInfo:(BOOL)theUnwrapProductInfo {
  unwrapProductInfo = theUnwrapProductInfo;
  NSSet* ids = [[NSSet alloc] initWithArray:productIds];
  skRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:ids];
  [ids release];
  skRequest.delegate = self;
  [skRequest start];
  [self retain];
}

-(void)startPurchasing:(NSString*)productId {
  skPayment = [[SKPayment paymentWithProductIdentifier:productId] retain];

  SKPaymentQueue* queue = [SKPaymentQueue defaultQueue];
  [queue addPayment:skPayment];
  [queue addTransactionObserver:self];
  [self retain];
}

#pragma mark SKPaymentRequest Delegate

-(void)productsRequest:(SKProductsRequest *)request
    didReceiveResponse:(SKProductsResponse *)response {
  if (unwrapProductInfo) {
    NSArray* products = response.products;
    SKProduct* product =
        ([products count] == 0) ? nil : [response.products objectAtIndex:0];
    [target performSelector:action withObject:product];
  }
  else {
    [target performSelector:action withObject:response.products];
  }
}

-(void)requestDidFinish:(SKRequest *)request {
  [self release];
}

-(void)request:(SKRequest *)request didFailWithError:(NSError *)error {
  [target performSelector:action withObject:error];
  [self release];
}

#pragma mark SKPaymentTransaction Observer

-(void)paymentQueue:(SKPaymentQueue *)queue
updatedTransactions:(NSArray *)transactions {
  SKPaymentQueue* skQueue = [SKPaymentQueue defaultQueue];
  for (SKPaymentTransaction* transaction in transactions) {
    if (![transaction.payment.productIdentifier
          isEqualToString:skPayment.productIdentifier]) {
      continue;
    }

    if (transaction.transactionState == SKPaymentTransactionStatePurchasing) {
      // The user confirmed the purchase, so wait until it gets to the server.
      break;
    }

    if (transaction.transactionState == SKPaymentTransactionStateFailed &&
        transaction.error == nil) {
      // Failed transaction without an error message. This is garbage.
      [skQueue finishTransaction:transaction];
      continue;
    }

    // Ideally, we'd remove ourselves from the queue's observer list. But if we
    // do that, the queue won't sync with the server.
    if (skTransaction.transactionIdentifier) {
      skTransactionId = [skTransaction.transactionIdentifier retain];
    }
    else {
      skTransaction = [transaction retain];
    }

    switch (transaction.transactionState) {
      case SKPaymentTransactionStateFailed:
        // Purchase failed. Communicate the error, and finish the transaction.
        // There's no need for the client to deal with this drudgery.
        [skQueue finishTransaction:transaction];
        [target performSelector:action withObject:transaction.error];
        break;
      case SKPaymentTransactionStatePurchased:
        // Purchase completed. Give transaction to client, so it can extract
        // the unique ID and receipt. The client is responsible for calling
        // +finishedTransaction: after recording the purchase.
        [target performSelector:action withObject:transaction];
        break;
      case SKPaymentTransactionStateRestored:
        // Old purchase restored. Give original transaction to client, so it can
        // extract the unique ID and receipt. The client is responsible for
        // calling +finishedTransaction: after recording the purchase.
        [target performSelector:action
                     withObject:transaction.originalTransaction];
        break;
      default:
        NSAssert1(NO, @"Unknown SKPaymentTransactionState: %d",
                  transaction.transactionState);
    }
    break;
  }
}

-(void)paymentQueue:(SKPaymentQueue *)queue
removedTransactions:(NSArray *)transactions {
  for (SKPaymentTransaction* transaction in transactions) {
    if (skTransaction != transaction &&
        skTransactionId != transaction.transactionIdentifier) {
      continue;
    }

    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [self release];
  }
}

-(void)paymentQueue:(SKPaymentQueue *)queue
restoreCompletedTransactionsFailedWithError:(NSError *)error {

}

-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
  // Nothing to do here.
}


#pragma mark Public Interface

+(void)getInfoForProductIds:(NSArray*)productIds
                     target:(id)target
                     action:(SEL)action {
  ZNAppStoreRequest* request =
      [[ZNAppStoreRequest alloc] initWithTarget:target action:action];
  [request getInfoForProductIds:productIds unwrapProductInfo:NO];
  [request release];
}

+(void)getInfoForProductId:(NSString*)productId
                    target:(id)target
                    action:(SEL)action {
  ZNAppStoreRequest* request =
      [[ZNAppStoreRequest alloc] initWithTarget:target action:action];
  NSArray* productIds = [[NSArray alloc] initWithObjects:productId, nil];
  [request getInfoForProductIds:productIds unwrapProductInfo:YES];
  [request release];
  [productIds release];
}

+(void)startPurchasing:(NSString*)productId
                target:(id)target
                action:(SEL)action {
  ZNAppStoreRequest* request =
      [[ZNAppStoreRequest alloc] initWithTarget:target action:action];
  [request startPurchasing:productId];
  [request release];
}

+(void)finishedTransaction:(SKPaymentTransaction*)transaction {
  [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

@end

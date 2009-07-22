//
//  ZNAppStoreRequest.h
//  ZergSupport
//
//  Created by Victor Costan on 7/21/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

@class SKPayment;
@class SKPaymentTransaction;
@class SKRequest;


// One-stop service class for In-App Purchasing.
@interface ZNAppStoreRequest : NSObject {
  SKRequest* skRequest;
  SKPayment* skPayment;
  SKPaymentTransaction* skTransaction;
  NSString* skTransactionId;
  NSObject* target;
  SEL action;
  BOOL unwrapProductInfo;
}

// Fetches information (e.g. local price) about an In-App Purchase.
//
// The target's action will be invoked with an NSError if something goes wrong,
// or with a nil argument if the product ID is not found, or with a SKProduct
// if the product ID is a valid In-App Purchase.
//
// The SKProduct contains localized user-friendly information about the
// In-App Purchase. If the user indicates a desire for buying the product, call
// +startPurchasing: with the productId.
+(void)getInfoForProductId:(NSString*)productId
                    target:(id)target
                    action:(SEL)action;

// Fetches information (e.g. local price) about multiple In-App Purchases.
//
// The target's action will be invoked with an NSError if something goes wrong,
// or with a NSArray containing SKProduct instances for the valid product IDs.
// Product IDs which can't be found in the store will not be represented in the
// response.
//
// The SKProduct* contains localized user-friendly information about the
// In-App Purchase. If the user indicates a desire for buying the product, call
// +startPurchasing: with the productId.
+(void)getInfoForProductIds:(NSArray*)productIds
                     target:(id)target
                     action:(SEL)action;


// Starts the In-App Purchase process.
//
// The user will have to approve the purchase before it happens. The target's
// action will be invoked with a NSError if something goes wrong, or with a
// SKPaymentTransaction upon success (the user bought the item, for sure).
//
// If the target is given a SKPaymentTransaction, it must call
// +finishedTransaction: _after_ the transaction result has been committed to
// persistent storage. For example, subscriptions should be finished after your
// server has received the receipt and acknowledged updating the user's account.
+(void)startPurchasing:(NSString*)productId
                target:(id)target
                action:(SEL)action;

// Marks an In-App Purchase transaction as committed.
//
// This should be called when the transaction's effect has been stored in
// persistent memory, otherwise the user's purchase may be lost. See
// +startPurchasing:target:action for more information.
+(void)finishedTransaction:(SKPaymentTransaction*)transaction;

@end

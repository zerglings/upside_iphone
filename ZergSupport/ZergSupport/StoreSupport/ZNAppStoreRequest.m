//
//  ZNAppStoreRequest.m
//  ZergSupport
//
//  Created by Victor Costan on 7/21/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNAppStoreRequest.h"

#import <StoreKit/StoreKit.h>


@interface ZNAppStoreRequest () <SKProductsRequestDelegate>
@end


@implementation ZNAppStoreRequest

#pragma mark Lifecycle

-(id)initWithTarget:(id)theTarget action:(SEL)theAction {
  if ((self = [super init])) {
    target = theTarget;
    action = theAction;
    skRequest = nil;
  }
  return self;
}
-(void)dealloc {
  [skRequest release];
  [super dealloc];
}

#pragma mark Request Preparation

-(void)getInfoForProductIds:(NSArray*)productIds {
  NSSet* ids = [[NSSet alloc] initWithArray:productIds];
  skRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:ids];
  [ids release];
  skRequest.delegate = self;
  [skRequest start];
  [self retain];
}

#pragma mark SKProductsRequest Delegate

-(void)productsRequest:(SKProductsRequest *)request
    didReceiveResponse:(SKProductsResponse *)response {
  [target performSelector:action withObject:response.products];  
}

-(void)requestDidFinish:(SKRequest *)request {
  [self release];
}

-(void)request:(SKRequest *)request didFailWithError:(NSError *)error {
  [target performSelector:action withObject:error];
  [self release];
}

#pragma mark Public Interface

+(void)getInfoForProductIds:(NSArray*)productIds
                     target:(id)target
                     action:(SEL)action {
  ZNAppStoreRequest* request =
      [[ZNAppStoreRequest alloc] initWithTarget:target action:action];
  [request getInfoForProductIds:productIds];
  [request release];
}

+(void)getInfoForProductId:(NSString*)productId
                    target:(id)target
                    action:(SEL)action {
  NSArray* productIds = [[NSArray alloc] initWithObjects:productId, nil];
  [self getInfoForProductIds:productIds target:target action:action];
  [productIds release];
}

@end

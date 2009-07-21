//
//  ZNAppStoreRequestTest.m
//  ZergSupport
//
//  Created by Victor Costan on 7/21/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ZNAppStoreRequest.h"

#import <StoreKit/StoreKit.h>
#import <TargetConditionals.h>


@interface ZNAppStoreRequestTest : SenTestCase {
  NSString* subscriptionId;
  NSString* featureId;
  NSArray* productIds;
  BOOL receivedResponse;
  BOOL inSimulator;
}
@end


@implementation ZNAppStoreRequestTest

-(void)setUp {
  subscriptionId = @"net.zergling.ZergSupport.sub";
  featureId = @"net.zergling.ZergSupport.feature";
  productIds = [[NSArray alloc] initWithObjects:subscriptionId, featureId, nil];
  receivedResponse = NO;
#if TARGET_IPHONE_SIMULATOR
  inSimulator = YES;
#else  // TARGET_IPHONE_SIMULATOR
  inSimulator = NO;
#endif  // TARGET_IPHONE_SIMULATOR
}
-(void)tearDown {
  [productIds release];
}
-(void)dealloc {
  [super dealloc];
}

-(void)checkSubscriptionProductInfo:(SKProduct*)product {
  STAssertTrue([product isKindOfClass:[SKProduct class]],
               @"Product is not an SKProduct");
  STAssertEqualStrings(subscriptionId, product.productIdentifier,
                       @"Wrong product retrieved (mismatching ID)");
  STAssertEqualStrings(@"1 Month Subscription", product.localizedTitle,
                       @"Wrong product retrieved (mismatching title)");
  STAssertEqualStrings(@"1 Month Subscription Description",
                       product.localizedDescription,
                       @"Wrong product retrieved (mismatching description)");
  STAssertEqualsWithAccuracy(1.99, [product.price doubleValue], 0.01,
                             @"Wrong product retrieved (mismatching price)");
}
-(void)checkFeatureProductInfo:(SKProduct*)product {
  STAssertTrue([product isKindOfClass:[SKProduct class]],
               @"Product is not an SKProduct");
  STAssertEqualStrings(featureId, product.productIdentifier,
                       @"Wrong product retrieved (mismatching ID)");
  STAssertEqualStrings(@"Awesome Feature", product.localizedTitle,
                       @"Wrong product retrieved (mismatching title)");
  STAssertEqualStrings(@"Awesome Feature Description",
                       product.localizedDescription,
                       @"Wrong product retrieved (mismatching description)");
  STAssertEqualsWithAccuracy(3.99, [product.price doubleValue], 0.01,
                             @"Wrong product retrieved (mismatching price)");
}

-(void)testSingleProduct {
  if (inSimulator) {
    NSLog(@"StoreKit cannot be tested in the Simulator. Please run tests on "
          @"real hardware if you make changes to ZNAppStoreRequest.");
    return;
  }
  
  [ZNAppStoreRequest getInfoForProductId:subscriptionId
                                  target:self
                                  action:@selector(checkSingleProductInfo:)];
  
  for (NSUInteger i = 0; i < 300; i++) {
    [[NSRunLoop currentRunLoop] runUntilDate:
     [NSDate dateWithTimeIntervalSinceNow:0.1]];
    if (receivedResponse) {
      break;
    }
  }
  STAssertEquals(YES, receivedResponse, @"Never received StoreKit response");
}

-(void)checkSingleProductInfo:(NSArray*)productInfo {
  receivedResponse = YES;
  STAssertFalse([productInfo isKindOfClass:[NSError class]],
                @"Fetching product info failed: %@", [productInfo description]);  
  STAssertEquals(1U, [productInfo count], @"Expected info for 1 product");
  
  [self checkSubscriptionProductInfo:[productInfo objectAtIndex:0]];
}

-(void)testMultipleProducts {
  if (inSimulator) {
    NSLog(@"StoreKit cannot be tested in the Simulator. Please run tests on "
          @"real hardware if you make changes to ZNAppStoreRequest.");
    return;
  }
  
  [ZNAppStoreRequest getInfoForProductIds:[NSArray arrayWithObjects:
                                           subscriptionId, featureId, nil]
                                   target:self
                                   action:@selector(checkMultipleProductInfo:)];
  
  for (NSUInteger i = 0; i < 300; i++) {
    [[NSRunLoop currentRunLoop] runUntilDate:
     [NSDate dateWithTimeIntervalSinceNow:0.1]];
    if (receivedResponse) {
      break;
    }
  }
  STAssertEquals(YES, receivedResponse, @"Never received StoreKit response");
}

-(void)checkMultipleProductInfo:(NSArray*)productInfo {
  receivedResponse = YES;
  STAssertFalse([productInfo isKindOfClass:[NSError class]],
                @"Fetching product info failed: %@", [productInfo description]);  
  STAssertEquals(2U, [productInfo count], @"Expected info for 2 products");
  
  NSString* firstId = [(SKProduct*)[productInfo objectAtIndex:0]
                       productIdentifier];
  if ([subscriptionId isEqualToString:firstId]) {
    [self checkSubscriptionProductInfo:[productInfo objectAtIndex:0]];
    [self checkFeatureProductInfo:[productInfo objectAtIndex:1]];
  }
  else {
    [self checkFeatureProductInfo:[productInfo objectAtIndex:0]];
    [self checkSubscriptionProductInfo:[productInfo objectAtIndex:1]];
  }
}

@end

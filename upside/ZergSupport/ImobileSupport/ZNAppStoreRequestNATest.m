//
//  ZNAppStoreRequestNATest.m
//  ZergSupport
//
//  Created by Victor Costan on 7/21/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ZNAppStoreRequest.h"

#import <StoreKit/StoreKit.h>
#import <TargetConditionals.h>

#import "FormatSupport.h"
#import "ModelSupport.h"
#import "WebSupport.h"
#import "ZNImobileDevice.h"


// Model for the request to the receipt verification service.
@interface ZNAppStoreRequestNATestWebRequest : ZNModel {
  NSData* receipt;
  BOOL production;
}
@property (nonatomic, retain, readonly) NSData* receipt;
@property (nonatomic, readonly) BOOL production;
@end
@implementation ZNAppStoreRequestNATestWebRequest
@synthesize receipt, production;
-(void)dealloc {
  [receipt release];
  [super dealloc];
}
@end


// Model for the response from the receipt verification service.
@interface ZNAppStoreRequestNATestWebResponse : ZNModel {
  NSInteger quantity;
  NSString* productId;
  NSString* transactionId;
  NSDate* purchaseDate;
  NSDate* originalPurchaseDate;
  NSString* bid;
  NSString* bvrs;
}
@property (nonatomic, readonly) NSInteger quantity;
@property (nonatomic, retain, readonly) NSString* productId;
@property (nonatomic, retain, readonly) NSString* transactionId;
@property (nonatomic, retain, readonly) NSDate* purchaseDate;
@property (nonatomic, retain, readonly) NSDate* originalPurchaseDate;
@property (nonatomic, retain, readonly) NSString* bid;
@property (nonatomic, retain, readonly) NSString* bvrs;
@end
@implementation ZNAppStoreRequestNATestWebResponse
@synthesize quantity, productId, transactionId, purchaseDate, bid, bvrs;
@synthesize originalPurchaseDate;
-(void)dealloc {
  [productId release];
  [transactionId release];
  [purchaseDate release];
  [bid release];
  [bvrs release];
  [super dealloc];
}
@end


@interface ZNAppStoreRequestNATest : SenTestCase {
  NSString* testService;
  NSString* cheapSubscriptionId;
  NSString* cancelMeId;
  BOOL inSimulator;

  SKPaymentTransaction* skTransaction;
  BOOL receivedResponse;
}
@end


@implementation ZNAppStoreRequestNATest

-(void)warmUpHerokuService:(NSString*)herokuService {
  // Issues a request to the testbed, so heroku loads it up on a machine
  [NSString stringWithContentsOfURL:[NSURL URLWithString:herokuService]
                           encoding:NSUTF8StringEncoding
                              error:NULL];
}

-(void)setUp {
  // This may go wrong during testing and actually charge us. So use the lowest
  // possible price, to reduce the bleed.
  cheapSubscriptionId = @"net.zergling.ZergSupport.sub_cheap";
  // This product instructors the tester to cancel it.
  cancelMeId = @"net.zergling.ZergSupport.cancel_me";

#if TARGET_IPHONE_SIMULATOR
  inSimulator = YES;
#else  // TARGET_IPHONE_SIMULATOR
  inSimulator = NO;
#endif  // TARGET_IPHONE_SIMULATOR

  skTransaction = nil;
  receivedResponse = NO;

  testService =
      @"http://zn-testbed.heroku.com/imobile_support/payment_receipt.json";
  [self warmUpHerokuService:testService];
}
-(void)tearDown {
  [skTransaction release];

  [testService release];
  testService = nil;
}
-(void)dealloc {
  [super dealloc];
}

-(void)testPurchase {
  if (inSimulator) {
    NSLog(@"StoreKit cannot be tested in the Simulator. Please run tests on "
          @"real hardware if you make changes to ZNAppStoreRequest.");
    return;
  }

  [ZNAppStoreRequest startPurchasing:cheapSubscriptionId
                              target:self
                              action:@selector(checkPurchase:)];
  for (NSUInteger i = 0; i < 3000; i++) {
    [[NSRunLoop currentRunLoop] runUntilDate:
     [NSDate dateWithTimeIntervalSinceNow:0.1]];
    if (receivedResponse) {
      break;
    }
  }
  STAssertEquals(YES, receivedResponse, @"Never received StoreKit response");

  // Verify the transaction receipt with the Web service.
  receivedResponse = NO;
  ZNAppStoreRequestNATestWebRequest* request =
      [[ZNAppStoreRequestNATestWebRequest alloc] initWithProperties:
       [NSDictionary dictionaryWithObject:skTransaction.transactionReceipt
                                   forKey:@"receipt"]];
  [ZNJsonHttpRequest callService:testService
                          method:kZNHttpMethodPost
                            data:request
                 responseQueries:[NSArray arrayWithObjects:
                                  [ZNAppStoreRequestNATestWebResponse class],
                                  @"/response", nil]
                          target:self
                          action:@selector(checkReceipt:)];
  [request release];
  for (NSUInteger i = 0; i < 3000; i++) {
    [[NSRunLoop currentRunLoop] runUntilDate:
     [NSDate dateWithTimeIntervalSinceNow:0.1]];
    if (receivedResponse) {
      break;
    }
  }
  STAssertEquals(YES, receivedResponse, @"Verification service didn't respond");
}

-(void)checkPurchase:(SKPaymentTransaction*)transaction {
  receivedResponse = YES;
  STAssertFalse([transaction isKindOfClass:[NSError class]],
                @"Purchase failed: %@", [transaction description]);
  STAssertNotNil(transaction, @"Purchase failed (no transaction receipt)");

  skTransaction = [transaction retain];
  [ZNAppStoreRequest finishedTransaction:skTransaction];

  STAssertEqualStrings(cheapSubscriptionId,
                       transaction.payment.productIdentifier,
                       @"Purchased wrong product");
  STAssertEquals(1, transaction.payment.quantity,
                 @"Purchased wrong quantity");
}

-(void)checkReceipt:(NSArray*)response {
  STAssertFalse([response isKindOfClass:[NSError class]],
                @"Verification failed: %@", [response description]);

  ZNAppStoreRequestNATestWebResponse* receipt = [response objectAtIndex:0];
  receivedResponse = YES;

  STAssertEquals(skTransaction.payment.quantity, receipt.quantity,
                 @"Receipt quantity doesn't match");
  STAssertEqualStrings(skTransaction.payment.productIdentifier,
                       receipt.productId,
                       @"Receipt product ID doesn't match");
  STAssertEqualStrings(skTransaction.transactionIdentifier,
                       receipt.transactionId,
                       @"Receipt transaction ID doesn't match");
  STAssertEqualStrings([ZNImobileDevice appId], receipt.bid,
                       @"Receipt bundle ID doesn't match");
  STAssertEqualStrings([ZNImobileDevice appVersion], receipt.bvrs,
                       @"Receipt bundle version doesn't match");

  if (skTransaction.transactionDate) {
    STAssertEqualObjects(skTransaction.transactionDate, receipt.purchaseDate,
                         @"Receipt purchase date doesnt't march");
  }
  if (skTransaction.originalTransaction) {
    STAssertEqualObjects(skTransaction.originalTransaction.transactionDate,
                         receipt.originalPurchaseDate,
                         @"Receipt purchase date doesnt't march");
  }
}


-(void)testPurchaseCancel {
  if (inSimulator) {
    NSLog(@"StoreKit cannot be tested in the Simulator. Please run tests on "
          @"real hardware if you make changes to ZNAppStoreRequest.");
    return;
  }

  [ZNAppStoreRequest startPurchasing:cancelMeId
                              target:self
                              action:@selector(checkPurchaseCancel:)];
  for (NSUInteger i = 0; i < 3000; i++) {
    [[NSRunLoop currentRunLoop] runUntilDate:
     [NSDate dateWithTimeIntervalSinceNow:0.1]];
    if (receivedResponse) {
      break;
    }
  }
  STAssertEquals(YES, receivedResponse, @"Never received StoreKit response");
}
-(void)checkPurchaseCancel:(NSError*)error {
  receivedResponse = YES;
  STAssertTrue([error isKindOfClass:[NSError class]],
               @"Cancelled purchase didn't fail: %@", [error description]);
}

@end

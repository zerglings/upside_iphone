//
//  ZNSyncControllerTest.m
//  upside
//
//  Created by Victor Costan on 1/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TestSupport.h"

#import "ModelSupport.h"
#import "ZNSyncController.h"
#import "WebSupport.h"


// Result class for testing.
@interface ZNSyncControllerTestModel : ZNModel {
  NSTimeInterval responseDelay;
  NSTimeInterval resumeDelay;
}
@property (nonatomic, readonly) NSTimeInterval responseDelay;
@property (nonatomic, readonly) NSTimeInterval resumeDelay;
-(id)initWithResponseDelay: (NSTimeInterval)responseDelay;
-(id)initWithResponseDelay: (NSTimeInterval)responseDelay
               resumeDelay: (NSTimeInterval)resumeDelay;
@end

@implementation ZNSyncControllerTestModel
@synthesize responseDelay, resumeDelay;

-(id)initWithResponseDelay: (NSTimeInterval)theResponseDelay {
  return [self initWithModel:nil properties:
          [NSDictionary dictionaryWithObjectsAndKeys:
           [NSNumber numberWithDouble:theResponseDelay], @"responseDelay",
           nil]];
}

-(id)initWithResponseDelay: (NSTimeInterval)theResponseDelay
               resumeDelay: (NSTimeInterval)theResumeDelay {
  return [self initWithModel:nil properties:
          [NSDictionary dictionaryWithObjectsAndKeys:
           [NSNumber numberWithDouble:theResponseDelay], @"responseDelay",
           [NSNumber numberWithDouble:theResumeDelay], @"resumeDelay", nil]];
}
@end

// Error class for testing.
@interface ZNSyncControllerTestError : ZNSyncControllerTestModel
@end
@implementation ZNSyncControllerTestError
@end


// Test implementation of CacheController
@protocol ZNSyncControllerTestDelegate
- (void)checkSync;
- (void)checkIntegrate: (NSArray*)results;
- (void)checkServiceError: (ZNSyncControllerTestError*)error;
- (void)checkSystemError: (NSError*)error;
@end


@interface ZNSyncControllerTestBox : ZNSyncController {
  NSArray* scenario;
  NSInteger currentStep;
  BOOL pendingResponse;
  id<ZNSyncControllerTestDelegate> delegate;
}
@property (nonatomic, readonly, retain) NSArray* scenario;
@property (nonatomic, readonly) NSInteger currentStep;
@property (nonatomic, readonly) BOOL pendingResponse;
- (id)initWithScenario: (NSArray*)scenario
              delegate: (id<ZNSyncControllerTestDelegate>)delegate;
@end

@implementation ZNSyncControllerTestBox
@synthesize scenario, currentStep, pendingResponse;
- (id)initWithScenario: (NSArray*)theScenario
              delegate: (id<ZNSyncControllerTestDelegate>)theDelegate {
  if ((self = [super initWithErrorModelClass:[ZNSyncControllerTestError class]
                                syncInterval:0.1])) {
    scenario = theScenario;
    currentStep = 0;
    pendingResponse = NO;
    delegate = theDelegate;
  }
  return self;
}
  
- (void)sync {
  [delegate checkSync];
  
  NSObject* scenarioStep = [scenario objectAtIndex:currentStep];
  NSArray* results = [NSArray arrayWithObject:scenarioStep];
  pendingResponse = YES;
  if ([scenarioStep isKindOfClass:[ZNSyncControllerTestModel class]]) {
    [self performSelector:@selector(receivedResults:)
               withObject:results
               afterDelay:[(ZNSyncControllerTestModel*)scenarioStep
                           responseDelay]];
  }
  else {
    [self receivedResults:results];
  }
}

- (BOOL)integrateResults: (NSArray*)results {
  [delegate checkIntegrate:results];
  pendingResponse = NO;
  currentStep++;
  
  return (currentStep < [scenario count]);
}

- (BOOL)handleServiceError: (ZNSyncControllerTestError*)error {
  [delegate checkServiceError:error];
  pendingResponse = NO;
  currentStep++;
  
  if ([error resumeDelay] > 0.0001) {
    [self performSelector:@selector(resumeSyncing:)
               withObject:nil
               afterDelay:[error resumeDelay]];
    return NO;
  }
  else
    return (currentStep < [scenario count]);
}

// Subclasses should override this method to handle a system error.
- (void)handleSystemError: (NSError*)error {
  [delegate checkSystemError:error];
  pendingResponse = NO;
  currentStep++;
}


@end


@interface ZNSyncControllerTest : SenTestCase <ZNSyncControllerTestDelegate> {
  ZNSyncControllerTestBox* testBox;
}
@end

@implementation ZNSyncControllerTest

#pragma mark Delegate

- (void)checkSync {
  STAssertFalse([testBox pendingResponse],
                @"Spurious -sync call at step %s", [testBox currentStep]);
}
- (void)checkIntegrate: (NSArray*)results {
  STAssertTrue([testBox pendingResponse],
               @"Spurious -integrate: call at step %s", [testBox currentStep]);
  STAssertEquals(1U, [results count],
                 @"Oversized array given to -integrate:");
  STAssertEquals([[testBox scenario] objectAtIndex:[testBox currentStep]],
                 [results objectAtIndex:0],
                 @"Wrong result given to -integrate:");
}
- (void)checkServiceError: (ZNSyncControllerTestError*)error {
  STAssertTrue([testBox pendingResponse],
               @"Spurious -handleServiceError: call at step %s",
               [testBox currentStep]);
  STAssertEquals([[testBox scenario] objectAtIndex:[testBox currentStep]],
                 error,
                 @"Wrong error given to -handleServiceError:");
  
}
- (void)checkSystemError: (NSError*)error {
  STAssertTrue([testBox pendingResponse],
               @"Spurious -handleSystemError: call at step %s",
               [testBox currentStep]);
  STAssertEquals([[testBox scenario] objectAtIndex:[testBox currentStep]],
                 error,
                 @"Wrong error given to -handleServiceError:");
}

#pragma mark Tests

- (void)setUp {
  testBox = nil;
}
- (void)tearDown {
  [testBox release];
}

- (void)testResponsePausing {
  testBox = [[ZNSyncControllerTestBox alloc] initWithScenario:
             [NSArray arrayWithObject:
              [[[ZNSyncControllerTestModel alloc] initWithResponseDelay:0.1]
               autorelease]]
                                                    delegate:self];
  [testBox startSyncing];
  [[NSRunLoop currentRunLoop] runUntilDate:[NSDate
                                            dateWithTimeIntervalSinceNow:0.7]];
  
  STAssertEquals(1, [testBox currentStep], @"Test scenario did not complete");
}
- (void)testErrorPausing {
  testBox = [[ZNSyncControllerTestBox alloc] initWithScenario:
             [NSArray arrayWithObjects:
              [[[ZNSyncControllerTestModel alloc] initWithResponseDelay:0.1]
               autorelease],
              [[[ZNSyncControllerTestError alloc] initWithResponseDelay:0.1]
               autorelease],
              nil]
             
                                                   delegate:self];
  [testBox startSyncing];
  [[NSRunLoop currentRunLoop] runUntilDate:[NSDate
                                            dateWithTimeIntervalSinceNow:1.0]];
  
  STAssertEquals(2, [testBox currentStep], @"Test scenario did not complete");
}
- (void)testAllResponses {
  testBox = [[ZNSyncControllerTestBox alloc] initWithScenario:
             [NSArray arrayWithObjects:
              [[[ZNSyncControllerTestModel alloc] initWithResponseDelay:0.1]
               autorelease],
              [[[ZNSyncControllerTestError alloc] initWithResponseDelay:0.1]
               autorelease],
              [NSError errorWithDomain:@"testing"
                                  code:0
                              userInfo:nil],
              [[[ZNSyncControllerTestModel alloc] initWithResponseDelay:0.1]
               autorelease],
              nil]
             
                                                   delegate:self];
  [testBox startSyncing];
  [[NSRunLoop currentRunLoop] runUntilDate:[NSDate
                                            dateWithTimeIntervalSinceNow:1.4]];
}
- (void)testErrorResuming {
  testBox = [[ZNSyncControllerTestBox alloc] initWithScenario:
             [NSArray arrayWithObjects:
              [[[ZNSyncControllerTestError alloc] initWithResponseDelay:0.1
                                                          resumeDelay:0.2]
               autorelease],
              [[[ZNSyncControllerTestModel alloc] initWithResponseDelay:0.1]
               autorelease],
              nil]
             
                                                   delegate:self];
  [testBox startSyncing];
  [[NSRunLoop currentRunLoop] runUntilDate:[NSDate
                                            dateWithTimeIntervalSinceNow:1.0]];
  
  STAssertEquals(2, [testBox currentStep], @"Test scenario did not complete");  
}

@end

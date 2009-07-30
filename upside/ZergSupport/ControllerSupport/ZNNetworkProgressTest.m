//
//  ZNNetworkProgressTest.m
//  ZergSupport
//
//  Created by Victor Costan on 6/21/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ZNNetworkProgress.h"


@interface ZNNetworkProgressTest : SenTestCase {
  ZNNetworkProgress* netProgress;
  UIApplication* app;
}
@end


@implementation ZNNetworkProgressTest
-(void)setUp {
  app = [UIApplication sharedApplication];
  netProgress = [ZNNetworkProgress sharedInstance];
}
-(void)testProgressIndicatorSingleThread {
  STAssertFalse(app.networkActivityIndicatorVisible,
                @"Progress indicator should start out hidden");
  [netProgress connectionStarted];
  STAssertTrue(app.networkActivityIndicatorVisible,
               @"Started first connection");
  [netProgress connectionStarted];
  STAssertTrue(app.networkActivityIndicatorVisible,
               @"Started second connection");
  [netProgress connectionDone];
  STAssertTrue(app.networkActivityIndicatorVisible,
               @"Done with first connection");
  [netProgress connectionDone];
  STAssertFalse(app.networkActivityIndicatorVisible,
                @"Done with second connection");
}
@end

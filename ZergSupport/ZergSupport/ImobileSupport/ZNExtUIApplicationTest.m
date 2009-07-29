//
//  ZNExtUIApplicationTest.m
//  ZergSupport
//
//  Created by Victor Costan on 7/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ZNExtUIApplication.h"


// This delegate should not be auto-instantiated for chaining.
static BOOL manualDelegateLaunched = NO;
@interface ZNExtUIApplicationTestManual : NSObject<UIApplicationDelegate> {
}
@end
@implementation ZNExtUIApplicationTestManual
-(void)applicationDidFinishLaunching:(UIApplication *)application {
  manualDelegateLaunched = NO;
}
@end


// This delegate should be auto-instantiated for chaining.
static BOOL autoDelegateLaunched = NO;
@interface ZNExtUIApplicationTestAuto :
    NSObject<UIApplicationDelegate, ZNAutoUIApplicationDelegate> {
}
@end
@implementation ZNExtUIApplicationTestAuto
-(void)applicationDidFinishLaunching:(UIApplication *)application {
  autoDelegateLaunched = YES;
}
-(void)thisDelegateIsAuto {
}
@end

// This delegate should be auto-instantiated for hidden chaining.
static BOOL hiddenDelegateLaunched = NO;
@interface ZNExtUIApplicationTestHidden :
NSObject<UIApplicationDelegate, ZNAutoUIHiddenApplicationDelegate> {
}
@end
@implementation ZNExtUIApplicationTestHidden
-(void)applicationDidFinishLaunching:(UIApplication *)application {
  hiddenDelegateLaunched = YES;
}
-(void)thisDelegateIsHidden {
}
@end


@interface ZNExtUIApplicationTest : SenTestCase {
}
@end


@implementation ZNExtUIApplicationTest

-(void)testAutoDelegateChaining {
  STAssertTrue(autoDelegateLaunched,
               @"Delegate with auto-chaining wasn't invoked at app launch");
  STAssertTrue(hiddenDelegateLaunched,
               @"Delegate with hidden-chaining wasn't invoked at app launch");
  STAssertFalse(manualDelegateLaunched,
               @"Delegate without auto-chaining was invoked at app launch");

  id mainDelegate = [[ZNExtUIApplication sharedApplication] delegate];
  STAssertTrue([mainDelegate respondsToSelector:@selector(thisDelegateIsAuto)],
               @"ZNAutoUIApplicationDelegate was chained as hidden");
  STAssertFalse([mainDelegate
                 respondsToSelector:@selector(thisDelegateIsHidden)],
                @"ZNAutoUIHiddenApplicationDelegate wasn't chained as hidden");
}

-(void)testCopyAllAutoChainedClasses {
  NSArray* chainedClasses = [ZNExtUIApplication copyAllAutoChainedClasses];
  STAssertTrue([chainedClasses containsObject:[ZNExtUIApplicationTestAuto
                                               class]],
               @"copyAllAutoChainedClasses missed an auto-chaining delegate");
  STAssertFalse([chainedClasses containsObject:[ZNExtUIApplicationTestHidden
                                                class]],
                @"copyAllAutoChainedClasses has a hidden chaining delegate");
  STAssertFalse([chainedClasses containsObject:[ZNExtUIApplicationTestManual
                                                class]],
                @"copyAllAutoChainedClasses has a manual-chaining delegate");
}
-(void)testCopyAllHiddenAutoChainedClasses {
  NSArray* hiddenClasses = [ZNExtUIApplication copyAllHiddenAutoChainedClasses];
  STAssertFalse([hiddenClasses containsObject:[ZNExtUIApplicationTestAuto
                                               class]],
                @"copyAllHiddenAutoChainedClasses has an auto-chaining "
                @"delegate");
  STAssertTrue([hiddenClasses containsObject:[ZNExtUIApplicationTestHidden
                                               class]],
               @"copyAllHiddenAutoChainedClasses missed a hidden chaining "
               @"delegate");
  STAssertFalse([hiddenClasses containsObject:[ZNExtUIApplicationTestManual
                                                class]],
                @"copyAllHiddenAutoChainedClasses has a manual-chaining "
                @"delegate");
}

-(void)testSharedDelegate {
  STAssertTrue([[ZNExtUIApplication sharedApplication]
                isKindOfClass:[ZNExtUIApplication class]],
               @"[UIApplication sharedApplication] not a ZNExtUIApplication");
}

@end

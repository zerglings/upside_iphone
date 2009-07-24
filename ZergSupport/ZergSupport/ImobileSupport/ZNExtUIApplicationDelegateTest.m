//
//  ZNExtUIApplicationDelegateTest.m
//  ZergSupport
//
//  Created by Victor Costan on 7/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ZNExtUIApplicationDelegate.h"


// Fixture delegate that keeps track of invocations and returns a customized
// value from some method.
@interface ZNExtUIApplicationDelegateTestD1 : NSObject<UIApplicationDelegate> {
  BOOL returnValue;
  NSDictionary* invoked;
}
@property (nonatomic,assign,readonly) NSDictionary* invoked;
@end
@implementation ZNExtUIApplicationDelegateTestD1
@synthesize invoked;
-(id)initWithReturnValue:(BOOL)theReturnValue {
  if ((self = [super init])) {
    returnValue = theReturnValue;
    invoked = nil;
  }
  return self;
}
-(void)dealloc {
  [super dealloc];
}
-(BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  invoked = launchOptions;
  return returnValue;
}
@end

// Fixture delegate that implements a method the previous delegate does not
// implement.
@interface ZNExtUIApplicationDelegateTestD2 : ZNExtUIApplicationDelegateTestD1 {
  NSData* invoked2;
}
@property (nonatomic,readonly) NSData* invoked2;
@end
@implementation ZNExtUIApplicationDelegateTestD2
@synthesize invoked2;
-(void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  invoked2 = deviceToken;
}
@end



@interface ZNExtUIApplicationDelegateTest : SenTestCase {
  ZNExtUIApplicationDelegate* delegate;
  ZNExtUIApplicationDelegateTestD1* d1;
  ZNExtUIApplicationDelegateTestD1* d2;
  ZNExtUIApplicationDelegateTestD2* d3;
  SEL commonSel;
  SEL d3Sel;
  SEL nooneSel;
  
  NSDictionary* arg1;
  NSData* arg2;
}
@end


@implementation ZNExtUIApplicationDelegateTest

-(void)setUp {
  commonSel = @selector(application:didFinishLaunchingWithOptions:);
  d3Sel =
      @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:);
  nooneSel = @selector(application:handleOpenURL:);
  
  d1 = [[ZNExtUIApplicationDelegateTestD1 alloc] initWithReturnValue:YES];
  d2 = [[ZNExtUIApplicationDelegateTestD1 alloc] initWithReturnValue:NO];
  d3 = [[ZNExtUIApplicationDelegateTestD2 alloc] initWithReturnValue:NO];
  
  delegate = [[ZNExtUIApplicationDelegate alloc] init];
  delegate.mainDelegate = d1;
  [delegate chainDelegate:d2];
  [delegate chainDelegate:d3];
}
-(void)tearDown {
  [d1 release];
  [d2 release];
  [d3 release];
  [delegate release];
}
-(void)dealloc {
  [super dealloc];
}

-(void)testRespondsTo {
  STAssertTrue([delegate respondsToSelector:commonSel],
               @"Responds to selector implemented by all delegates");
  STAssertTrue([delegate respondsToSelector:d3Sel],
               @"Responds to selector implemented by a chained delegate");
  STAssertFalse([delegate respondsToSelector:nooneSel],
               @"Does not respond to selector not implemented by any delegate");
}

-(void)testChainedInvocation {
  [delegate application:nil didFinishLaunchingWithOptions:arg1];
  
  STAssertEquals(arg1, d1.invoked, @"Main delegate not invoked");
  STAssertEquals(arg1, d2.invoked, @"Chained delegate 1 not invoked");
  STAssertEquals(arg1, d3.invoked, @"Chained delegate 2 not invoked");
}

-(void)testSelectiveInvocation {
  [delegate application:nil
   didRegisterForRemoteNotificationsWithDeviceToken:arg2];
  
  STAssertNil(d1.invoked, @"Wrong message invoed on main delegate");
  STAssertNil(d2.invoked, @"Wrong message invoed on chained delegate 1");
  STAssertNil(d3.invoked, @"Wrong message invoed on chained delegate 2");
  STAssertEquals(arg2, d3.invoked2, @"Chained delegate 2 not invoked");
}

-(void)testReturnValue {
  BOOL value = [delegate application:nil didFinishLaunchingWithOptions:arg1];
  STAssertTrue(value, @"Return value does not reflect main delegate");
}
@end

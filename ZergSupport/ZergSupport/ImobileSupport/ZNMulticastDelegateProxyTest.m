//
//  ZNMulticastDelegateProxyTest.m
//  ZergSupport
//
//  Created by Victor Costan on 7/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ZNMulticastDelegateProxy.h"


// Fixture delegate that keeps track of invocations and returns a customized
// value from some method.
@interface ZNMulticastDelegateProxyTestD1 : NSObject<UIApplicationDelegate> {
  BOOL returnValue;
  NSDictionary* invoked;
}
@property (nonatomic,assign,readonly) NSDictionary* invoked;
@end
@implementation ZNMulticastDelegateProxyTestD1
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
@interface ZNMulticastDelegateProxyTestD2 : ZNMulticastDelegateProxyTestD1 {
  NSData* invoked2;
}
@property (nonatomic,readonly) NSData* invoked2;
@end
@implementation ZNMulticastDelegateProxyTestD2
@synthesize invoked2;
-(id)initWithReturnValue:(BOOL)theReturnValue {
  if ((self = [super initWithReturnValue:theReturnValue])) {
    invoked2 = nil;
  }
  return self;
}
-(void)dealloc {
  [super dealloc];
}
-(void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  invoked2 = deviceToken;
}
@end



@interface ZNMulticastDelegateProxyTest : SenTestCase {
  ZNMulticastDelegateProxy<UIApplicationDelegate>* delegate;
  ZNMulticastDelegateProxyTestD1* main;
  ZNMulticastDelegateProxyTestD1* d1;
  ZNMulticastDelegateProxyTestD2* d2;
  SEL commonSel;
  SEL d2Sel;
  SEL nooneSel;

  NSDictionary* arg1;
  NSData* arg2;
}
@end


@implementation ZNMulticastDelegateProxyTest

-(void)setUp {
  commonSel = @selector(application:didFinishLaunchingWithOptions:);
  d2Sel =
      @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:);
  nooneSel = @selector(application:handleOpenURL:);

  main = [[ZNMulticastDelegateProxyTestD1 alloc] initWithReturnValue:YES];
  d1 = [[ZNMulticastDelegateProxyTestD1 alloc] initWithReturnValue:NO];
  d2 = [[ZNMulticastDelegateProxyTestD2 alloc] initWithReturnValue:NO];

  delegate = [[ZNMulticastDelegateProxy alloc] init];
  delegate.mainDelegate = main;
  [delegate chainDelegate:d1];
  [delegate chainDelegate:d2];

  arg1 = [[NSMutableDictionary alloc] init];
  arg2 = [[NSMutableData alloc] init];
}
-(void)tearDown {
  [main release];
  [d1 release];
  [d2 release];
  [delegate release];
  [arg1 release];
  [arg2 release];
}
-(void)dealloc {
  [super dealloc];
}

-(void)testRespondsTo {
  STAssertTrue([delegate respondsToSelector:commonSel],
               @"Responds to selector implemented by all delegates");
  STAssertTrue([delegate respondsToSelector:d2Sel],
               @"Responds to selector implemented by a chained delegate");
  STAssertFalse([delegate respondsToSelector:nooneSel],
               @"Does not respond to selector not implemented by any delegate");
}

-(void)testChainedInvocation {
  [delegate application:nil didFinishLaunchingWithOptions:arg1];

  STAssertEquals(arg1, main.invoked, @"Main delegate not invoked");
  STAssertEquals(arg1, d1.invoked, @"Chained delegate 1 not invoked");
  STAssertEquals(arg1, d2.invoked, @"Chained delegate 2 not invoked");
}

-(void)testSelectiveInvocation {
  [delegate application:nil
   didRegisterForRemoteNotificationsWithDeviceToken:arg2];

  STAssertNil(main.invoked, @"Wrong message invoed on main delegate");
  STAssertNil(d1.invoked, @"Wrong message invoed on chained delegate 1");
  STAssertNil(d2.invoked, @"Wrong message invoed on chained delegate 2");
  STAssertEquals(arg2, d2.invoked2, @"Chained delegate 2 not invoked");
}

-(void)testReturnValue {
  BOOL value = [delegate application:nil didFinishLaunchingWithOptions:arg1];
  STAssertTrue(value, @"Return value does not reflect main delegate");
}

-(void)testHiddenDelegates {
  [delegate unchainDelegate:d2];
  [delegate chainHiddenDelegate:d2];

  STAssertFalse([delegate respondsToSelector:d2Sel],
                @"Hidden delegates should not influence -respondsTo:");

  [delegate application:nil
didRegisterForRemoteNotificationsWithDeviceToken:arg2];
  STAssertEquals(arg2, d2.invoked2, @"Hidden chained delegate not invoked");
}
@end

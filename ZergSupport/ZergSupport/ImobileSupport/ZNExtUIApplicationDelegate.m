//
//  ZNExtUIApplicationDelegate.m
//  ZergSupport
//
//  Created by Victor Costan on 7/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNExtUIApplicationDelegate.h"


@implementation ZNExtUIApplicationDelegate

@synthesize mainDelegate;

-(id)init {
  mainDelegate = nil;
  chainedDelegates = [[NSMutableSet alloc] init];
  return self;
}
-(void)dealloc {
  [chainedDelegates release];
  
  [super dealloc];
}

-(void)chainDelegate:(id<UIApplicationDelegate>)delegate {
  [chainedDelegates addObject:delegate];
}

-(void)unchainDelegate:(id<UIApplicationDelegate>)delegate {
  [chainedDelegates removeObject:delegate];
}

// Overrides the default implementation to respond YES if any delegate responds.
-(BOOL)respondsToSelector:(SEL)aSelector {
  if ([mainDelegate respondsToSelector:aSelector]) {
    return YES;
  }
  for (id<UIApplicationDelegate> delegate in chainedDelegates) {
    if ([delegate respondsToSelector:aSelector]) {
      return YES;
    }
  }
  return [super respondsToSelector:aSelector];
}

// Overrides the default implementation to check all delegates for signature.
-(NSMethodSignature*)methodSignatureForSelector:(SEL)aSelector {
  if ([mainDelegate respondsToSelector:aSelector]) {
    return [mainDelegate methodSignatureForSelector:aSelector];
  }
  for (NSObject<UIApplicationDelegate>* delegate in chainedDelegates) {
    if ([delegate methodSignatureForSelector:aSelector]) {
      return [delegate methodSignatureForSelector:aSelector];
    }
  }
  return [super methodSignatureForSelector:aSelector];
}

// Overrides the default implementation to invoke all delegates.
-(void)forwardInvocation:(NSInvocation *)invocation {
  SEL aSelector = [invocation selector];  
  for (id<UIApplicationDelegate> delegate in chainedDelegates) {
    if ([delegate respondsToSelector:aSelector]) {
      [invocation invokeWithTarget:delegate];
    }
  }
  if ([mainDelegate respondsToSelector:aSelector]) {
    [invocation invokeWithTarget:mainDelegate];
  }
}

@end

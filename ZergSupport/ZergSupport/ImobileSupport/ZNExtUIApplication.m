//
//  ZNExtUIApplication.m
//  ZergSupport
//
//  Created by Victor Costan on 7/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNExtUIApplication.h"

#include <objc/runtime.h>
#import "ZNMulticastDelegateProxy.h"


@implementation ZNExtUIApplication

-(id)init {
  if ((self = [super init])) {
    delegateProxy = [[ZNMulticastDelegateProxy alloc] init];

    NSArray* chainedClasses = [ZNExtUIApplication copyAllAutoChainedClasses];
    for(Class klass in chainedClasses) {
      NSObject<UIApplicationDelegate>* delegate = [[klass alloc] init];
      [self chainDelegate:delegate];
      [delegate release];
    }
    [chainedClasses release];

    NSArray* hiddenChainedClasses = [ZNExtUIApplication
                                     copyAllHiddenAutoChainedClasses];
    for(Class klass in hiddenChainedClasses) {
      NSObject<UIApplicationDelegate>* delegate = [[klass alloc] init];
      [self chainHiddenDelegate:delegate];
      [delegate release];
    }
    [hiddenChainedClasses release];
  }
  return self;
}
-(void)dealloc {
  [delegateProxy release];

  [super dealloc];
}

-(id<UIApplicationDelegate>)delegate {
  return (id<UIApplicationDelegate>)delegateProxy;
}
-(void)setDelegate:(id<UIApplicationDelegate>)delegate {
  delegateProxy.mainDelegate = delegate;
  [super setDelegate:(id<UIApplicationDelegate>)delegateProxy];
}

-(void)chainDelegate:(NSObject<UIApplicationDelegate>*)delegate {
  [delegateProxy chainDelegate:delegate];
}

-(void)chainHiddenDelegate:(NSObject<UIApplicationDelegate>*)delegate {
  [delegateProxy chainHiddenDelegate:delegate];
}

-(void)unchainDelegate:(NSObject<UIApplicationDelegate>*)delegate {
  [delegateProxy unchainDelegate:delegate];
}

+(ZNExtUIApplication*)sharedApplication {
  NSAssert([[super sharedApplication] isKindOfClass:[ZNExtUIApplication class]],
           @"ZNExtUIApplication isn't hooked as the UIApplication instance. "
           @"Include ZergSupport/ImobileSupport/_ZNExtUIApplicationMain.h "
           @"in your main.c file, or subclass ZNExtUIApplication.");
  return (ZNExtUIApplication*)[super sharedApplication];
}

// All the classes implementing a protocol.
+(NSArray*)copyAllClassesImplementing:(char*)protocolName {
  // Get all the classes from the Objective C runtime.
  int numClasses = objc_getClassList(NULL, 0);
  Class* classes = (Class*)calloc(sizeof(Class), numClasses);
  numClasses = objc_getClassList(classes, numClasses);

  // Filter the classes implementing ZNAutoUIApplicationDelegate.
  int chainedClasses = 0;
  SEL mss = @selector(methodSignatureForSelector:);
  for (int i = 0; i < numClasses; i++) {
    Class klass = classes[i];
    if (!class_respondsToSelector(klass, mss))
      continue;

    unsigned int protocolCount;
    Protocol** protocols = class_copyProtocolList(klass, &protocolCount);
    for(unsigned int i = 0; i < protocolCount; i++) {
      const char* classProtocolName = protocol_getName(protocols[i]);
      if (!strcmp(classProtocolName, protocolName)) {
        classes[chainedClasses++] = klass;
        break;
      }
    }
  }

  // Wrap the result in an NSArray.
  NSArray* returnValue = [[NSArray alloc] initWithObjects:classes
                                                    count:chainedClasses];
  free(classes);
  return returnValue;
}

+(NSArray*)copyAllAutoChainedClasses {
  return [self copyAllClassesImplementing:"ZNAutoUIApplicationDelegate"];
}

+(NSArray*)copyAllHiddenAutoChainedClasses {
  return [self copyAllClassesImplementing:"ZNAutoUIHiddenApplicationDelegate"];
}

@end

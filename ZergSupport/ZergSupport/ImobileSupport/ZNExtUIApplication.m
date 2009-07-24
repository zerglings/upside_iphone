//
//  ZNExtUIApplication.m
//  ZergSupport
//
//  Created by Victor Costan on 7/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNExtUIApplication.h"

#include <objc/objc-runtime.h>
#import "ZNExtUIApplicationDelegate.h"


@implementation ZNExtUIApplication

-(id)init {
  if ((self = [super init])) {
    fakeDelegate = [[ZNExtUIApplicationDelegate alloc] init];
    
    NSArray* chainedClasses = [ZNExtUIApplication copyAllAutoChainedClasses];
    for(Class klass in chainedClasses) {
      NSObject<UIApplicationDelegate>* delegate = [[klass alloc] init];
      [self chainDelegate:delegate];
      [delegate release];
    }
    [chainedClasses release];
  }
  return self;
}
-(void)dealloc {
  [fakeDelegate release];
  
  [super dealloc];
}

-(id<UIApplicationDelegate>)delegate {
  return fakeDelegate;
}
-(void)setDelegate:(id<UIApplicationDelegate>)delegate {
  fakeDelegate.mainDelegate = delegate;
  [super setDelegate:fakeDelegate];
}

-(void)chainDelegate:(id<UIApplicationDelegate>)delegate {
  [fakeDelegate chainDelegate:delegate];
}

-(void)unchainDelegate:(id<UIApplicationDelegate>)delegate {
  [fakeDelegate unchainDelegate:delegate];
}

+(ZNExtUIApplication*)sharedApplication {
  NSAssert([[super sharedApplication] isKindOfClass:[ZNExtUIApplication class]],
           @"ZNExtUIApplication isn't hooked as the UIApplication instance. "
           @"Include ZergSupport/ImobileSupport/_ZNExtUIApplicationMain.h "
           @"in your main.c file, or subclass ZNExtUIApplication.");
  return (ZNExtUIApplication*)[super sharedApplication];
}

+(NSArray*)copyAllAutoChainedClasses {
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
      const char* protocolName = protocol_getName(protocols[i]);
      if (!strcmp(protocolName, "ZNAutoUIApplicationDelegate")) {
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

@end

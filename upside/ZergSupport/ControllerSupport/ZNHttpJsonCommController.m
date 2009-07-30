//
//  ZNHttpJsonCommController.m
//  upside
//
//  Created by Victor Costan on 6/20/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNHttpJsonCommController.h"

#include <objc/runtime.h>

#import "ZNNetworkProgress.h"
#import "WebSupport.h"


@implementation ZNHttpJsonCommController

-(id)initWithTarget:(id)theTarget action:(SEL)theAction {
  if ((self = [super init])) {
    target = theTarget;
    action = theAction;
    responseQueries = [[self class] copyResponseQueries];
  }
  return self;
}
-(void)dealoc {
  [responseQueries release];
  [super dealloc];
}

-(void)callService:(NSString*)service
            method:(NSString*)method
              data:(NSDictionary*)request {
  [ZNNetworkProgress connectionStarted];
  [ZNJsonHttpRequest callService:service
                          method:method
                            data:request
                 responseQueries:responseQueries
                          target:self
                          action:@selector(processResponse:)];
}

-(void)processResponse:(NSArray*)response {
  [target performSelector:action withObject:response];
  [ZNNetworkProgress connectionDone];
}

+(NSArray*)copyResponseQueries {
  NSAssert1(FALSE, @"Controller %s did not implement +copyResponseQueries",
            class_getName(self));
  return [[NSArray alloc] init];
}

@end

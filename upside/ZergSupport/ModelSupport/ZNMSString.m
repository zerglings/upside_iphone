//
//  ZNMSString.m
//  ZergSupport
//
//  Created by Victor Costan on 1/14/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNMSString.h"

#import "ZNModelDefinitionAttribute.h"

@implementation ZNMSString

#pragma mark Boxing

-(NSObject*)copyBoxedAttribute:(ZNModelDefinitionAttribute*)attribute
                    inInstance:(ZNModel*)instance
                   forceString:(BOOL)forceString {
  NSString* string = object_getIvar(instance, [attribute runtimeIvar]);
  return [string retain];
}

-(void)unboxAttribute:(ZNModelDefinitionAttribute*)attribute
           inInstance:(ZNModel*)instance
                 from:(NSObject*)boxedObject {
  NSString* string;
  if ([boxedObject isKindOfClass:[NSString class]]) {
    string = (NSString*)boxedObject;
  }
  else if ([boxedObject isKindOfClass:[NSNull class]]) {
    string = nil;
  }
  else {
    string = [boxedObject description];
  }

  Ivar runtimeIvar = [attribute runtimeIvar];
  switch ([attribute setterStrategy]) {
    case kZNPropertyWantsCopy: {
      string = [string copy];
      NSString* oldString = object_getIvar(instance, runtimeIvar);
      [oldString release];
      break;
    }
    case kZNPropertyWantsRetain: {
      [string retain];
      NSString* oldString = object_getIvar(instance, runtimeIvar);
      [oldString release];
      break;
    }
    case kZNPropertyWantsAssign:
      break;
    default:
      NSAssert(NO, @"Unknown attribute setter strategy");
  }
  object_setIvar(instance, runtimeIvar, string);
}

-(NSObject*)copyStringForBoxedValue:(NSObject*)boxedValue {
  NSAssert([boxedValue isKindOfClass:[NSString class]],
           @"Value is not a NSString instance");
  return [(NSString*)boxedValue retain];
}

@end

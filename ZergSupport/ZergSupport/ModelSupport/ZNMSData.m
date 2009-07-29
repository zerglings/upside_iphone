//
//  ZNMSData.m
//  ZergSupport
//
//  Created by Victor Costan on 7/21/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNMSData.h"

#import "ZNModelDefinitionAttribute.h"

@implementation ZNMSData

#pragma mark Lifecycle

-(id)init {
  if ((self = [super init])) {
  }
  return self;
}

-(void)dealloc {
  [super dealloc];
}

#pragma mark Boxing

-(NSObject*)copyBoxedAttribute:(ZNModelDefinitionAttribute*)attribute
                    inInstance:(ZNModel*)instance
                   forceString:(BOOL)forceString {
  NSData* data = object_getIvar(instance, [attribute runtimeIvar]);
  if (forceString && data) {
    return [self copyStringForBoxedValue:data];
  }
  else {
    return [data retain];
  }
}

-(void)unboxAttribute:(ZNModelDefinitionAttribute*)attribute
           inInstance:(ZNModel*)instance
                 from:(NSObject*)boxedObject {
  NSData* data;
  if ([boxedObject isKindOfClass:[NSString class]]) {
    // NOTE: using Latin-1 because it's the default HTTP encoding.
    data = [(NSString*)boxedObject dataUsingEncoding:NSISOLatin1StringEncoding];
  }
  else if ([boxedObject isKindOfClass:[NSData class]]) {
    data = (NSData*)boxedObject;
  }
  else if ([boxedObject isKindOfClass:[NSNull class]]) {
    data = nil;
  }
  else {
    data = nil;
  }

  Ivar runtimeIvar = [attribute runtimeIvar];
  switch ([attribute setterStrategy]) {
    case kZNPropertyWantsCopy: {
      data = [data copy];
      NSData* oldData = object_getIvar(instance, runtimeIvar);
      [oldData release];
      break;
    }
    case kZNPropertyWantsRetain: {
      [data retain];
      NSDate* oldData = object_getIvar(instance, runtimeIvar);
      [oldData release];
      break;
    }
    case kZNPropertyWantsAssign:
      break;
    default:
      NSAssert(NO, @"Unknown attribute setter strategy");
  }
  object_setIvar(instance, runtimeIvar, data);
}

-(NSObject*)copyStringForBoxedValue:(NSObject*)boxedValue {
  NSAssert([boxedValue isKindOfClass:[NSData class]],
            @"Value is not a NSData instance");
  
  // NOTE: using Latin-1 because it's the default HTTP encoding.
  return [[NSString alloc] initWithData:(NSData*)boxedValue
                               encoding:NSISOLatin1StringEncoding];
  
}

@end

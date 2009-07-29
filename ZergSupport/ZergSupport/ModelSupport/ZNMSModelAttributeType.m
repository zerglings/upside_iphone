//
//  ZNMSModelAttributeType.m
//  ZergSupport
//
//  Created by Victor Costan on 6/7/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNMSModelAttributeType.h"

#import "ZNModel.h"
#import "ZNModelDefinitionAttribute.h"


@implementation ZNMSModelAttributeType

@synthesize modelClass;

-(NSObject*)copyBoxedAttribute:(ZNModelDefinitionAttribute*)attribute
                    inInstance:(ZNModel*)instance
                   forceString:(BOOL)forceString {
  ZNModel* model = object_getIvar(instance, [attribute runtimeIvar]);

  return [model copyToDictionaryForcingStrings:forceString];
}

-(void)unboxAttribute:(ZNModelDefinitionAttribute*)attribute
           inInstance:(ZNModel*)instance
                 from:(NSObject*)boxedObject {
  ZNModel* model;
  if ([boxedObject isKindOfClass:[NSDictionary class]]) {
    model = [[modelClass alloc] initWithProperties:(NSDictionary*)boxedObject];
  }
  else {
    model = nil;
  }

  Ivar runtimeIvar = [attribute runtimeIvar];
  switch ([attribute setterStrategy]) {
    case kZNPropertyWantsCopy:
    case kZNPropertyWantsRetain: {
      ZNModel* oldModel = object_getIvar(instance, runtimeIvar);
      [oldModel release];
      break;
    }
    case kZNPropertyWantsAssign:
      [model autorelease];
      break;
    default:
      NSAssert(NO, @"Unknown attribute setter strategy");
  }
  object_setIvar(instance, runtimeIvar, model);
}

-(NSObject*)copyStringForBoxedValue:(NSObject*)boxedValue {
  NSAssert1([boxedValue isKindOfClass:modelClass],
            @"Value is not a %s instance", class_getName(modelClass));
  return [(ZNModel*)boxedValue copyToDictionaryForcingStrings:YES];
}

-(id)initWithModelClass:(Class)theModelClass {
  if ((self = [super init])) {
    modelClass = theModelClass;
  }
  return self;
}

@end

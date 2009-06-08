//
//  ZNAttributeType.m
//  ZergSupport
//
//  Created by Victor Costan on 1/14/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNMSAttributeType.h"

#import <objc/runtime.h>

#import "ZNModel.h"
#import "ZNModelDefinitionAttribute.h"
#import "ZNMSModelAttributeType.h"
#import "ZNMSRegistry.h"


@implementation ZNMSAttributeType

+(ZNMSAttributeType*)copyTypeFromString:(const char*)encodedType {
  switch (*encodedType) {
    case '@':
      encodedType++;
      if (*encodedType == '"') {
        // Class name following the type. Check for special cases first.
        if (!strncmp(encodedType, "\"NSString\"", 10))
          return [[[ZNMSRegistry sharedRegistry] stringType] retain];
        else if (!strncmp(encodedType, "\"NSDate\"", 8))
          return [[[ZNMSRegistry sharedRegistry] dateType] retain];
        else {
          // Should be a nested model.

          // Extract class from type signature.
          encodedType++;
          size_t classNameLength = strchr(encodedType, '"') - encodedType;
          char* className = (char*)calloc(classNameLength + 1, sizeof(char));
          memcpy(className, encodedType, classNameLength);
          className[classNameLength] = '\0';
          id modelClass = objc_getClass(className);
          free(className);

          if (![ZNModel isModelClass:modelClass])
            return nil;
          return [[ZNMSModelAttributeType alloc] initWithModelClass:modelClass];
        }
      }
      else {
         return [[[ZNMSRegistry sharedRegistry] stringType] retain];
      }
    case 'c':
      return [[[ZNMSRegistry sharedRegistry] booleanType] retain];
    case 'd':
      return [[[ZNMSRegistry sharedRegistry] doubleType] retain];
    case 'i':
      return [[[ZNMSRegistry sharedRegistry] integerType] retain];
    case 'I':
      return [[[ZNMSRegistry sharedRegistry] uintegerType] retain];
    default:
      return nil;
  }
}

-(NSObject*)copyBoxedAttribute:(ZNModelDefinitionAttribute*)attribute
                    inInstance:(ZNModel*)instance
                   forceString:(BOOL)forceString {
  NSAssert1(FALSE, @"Attribute type %s did not implement -boxInstanceVar",
            class_getName([self class]));
  return [[NSNull alloc] init];
}

-(void)unboxAttribute:(ZNModelDefinitionAttribute*)attribute
           inInstance:(ZNModel*)instance
                 from:(NSObject*)boxedObject {
  NSAssert1(FALSE, @"Attribute type %s did not implement -unboxInstanceVar",
            class_getName([self class]));
}

@end

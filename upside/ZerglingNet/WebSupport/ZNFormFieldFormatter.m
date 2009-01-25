//
//  ZNFormFieldFormatter.m
//  upside
//
//  Created by Victor Costan on 1/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ZNFormFieldFormatter.h"
#import "ZNFormFieldFormatter+Snake2LCamel.h"

#import <objc/runtime.h>

@implementation ZNFormFieldFormatter

- (NSString*) copyFormattedName: (NSString*)name {
  NSAssert1(NO, @"Form formatter %s did not implement -copyFormattedName",
            class_getName([self class]));
  return nil;
}

+ (ZNFormFieldFormatter*) formatterFromPropertiesTo: (ZNFormatterCasing)casing {
  switch (casing) {
    case kZNFormatterNoCase:
      return [self identityFormatter];
    case kZNFormatterSnakeCase:
      return [self lCamelToSnakeFormatter];
    case kZNFormatterLCamelCase:
      return [self identityFormatter];
    default:
      NSAssert(NO, @"Unsupported casing");
      return nil;
  }
}
@end


#pragma mark Identity Formatter

@interface ZNFormFieldFormatterIdentity : ZNFormFieldFormatter
@end

@implementation ZNFormFieldFormatterIdentity

- (NSString*) copyFormattedName: (NSString*)name {
  return [name copy];
}
@end



@implementation ZNFormFieldFormatter (Identity)

static ZNFormFieldFormatter* identityFormatterSingleton;

+ (ZNFormFieldFormatter*) identityFormatter {
  @synchronized ([ZNFormFieldFormatterIdentity class]) {
    if (identityFormatterSingleton == nil) {
      identityFormatterSingleton =
          [[ZNFormFieldFormatterIdentity alloc] init];
    }
  }
  return identityFormatterSingleton;  
}

@end

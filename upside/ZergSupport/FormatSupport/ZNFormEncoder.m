//
//  ZNFormEncoder.m
//  ZergSupport
//
//  Created by Victor Costan on 5/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNFormEncoder.h"

#include <objc/runtime.h>
#import "ModelSupport.h"
#import "ZNFormFieldFormatter.h"


@interface ZNFormEncoder ()
-(void)encode:(NSObject*)object keyPrefix:(NSString*)keyPrefix;

-(void)encodeKey:(NSString*)key
           value:(NSObject*)value
       keyPrefix:(NSString*)keyPrefix;
@end


@implementation ZNFormEncoder
@synthesize output;

#pragma mark Lifecycle

-(id)initWithFieldFormatter:(ZNFormFieldFormatter*)theFieldFormatter {
  if ((self = [super init])) {
    output = [[NSMutableData alloc] init];
    fieldFormatter = theFieldFormatter;
  }
  return self;
}
-(void)dealloc {
  [output release];
  [super dealloc];
}

+(NSData*)copyEncodingFor:(NSObject*)dictionaryOrModel
      usingFieldFormatter:(ZNFormFieldFormatter*)formatter {
  NSAssert1([dictionaryOrModel isKindOfClass:[NSDictionary class]] ||
            [dictionaryOrModel isKindOfClass:[ZNModel class]] ||
            !dictionaryOrModel,
            @"Object to be encoded is not a dictionary or a model: %@",
            [dictionaryOrModel description]);

  ZNFormEncoder* encoder = [[self alloc] initWithFieldFormatter:formatter];
  [encoder encode:dictionaryOrModel];
  NSMutableData* output = [[encoder output] retain];
  [encoder release];
  return output;
}

#pragma mark Generic Purpose Encoding

-(void)encode:(NSObject*)object {
  [self encode:object keyPrefix:@""];
}

-(void)encode:(NSObject*)object keyPrefix:(NSString*)keyPrefix {
  if ([object isKindOfClass:[NSArray class]]) {
    NSUInteger count = [(NSArray*)object count];
    for (NSUInteger i = 0; i < count; i++) {
      [self encodeKey:@""
                value:[(NSArray*)object objectAtIndex:i]
            keyPrefix:keyPrefix];
    }
  }
  else {
    NSDictionary* dictionary = [object isKindOfClass:[ZNModel class]] ?
        [(ZNModel*)object copyToDictionaryForcingStrings:YES] :
        (NSDictionary*)object;

    for (NSString* key in dictionary) {
      NSString* formattedKey = [fieldFormatter copyFormattedName:key];
      [self encodeKey:formattedKey
                value:[dictionary objectForKey:key]
            keyPrefix:keyPrefix];
      [formattedKey release];
    }

    if (dictionary != object) {
      [dictionary release];
    }
  }
}

-(void)encodeKey:(NSString*)key
           value:(NSObject*)value
       keyPrefix:(NSString*)keyPrefix {
  NSAssert([key isKindOfClass:[NSString class]],
           @"Attempting to encode non-String key!");

  if ([value isKindOfClass:[NSDictionary class]] ||
      [value isKindOfClass:[NSArray class]] ||
      [value isKindOfClass:[ZNModel class]]) {
    NSString* newPrefix;
    if ([keyPrefix length] != 0)
      newPrefix = [[NSString alloc] initWithFormat:@"%@[%@]", keyPrefix, key];
    else
      newPrefix = [key retain];
    [self encode:value keyPrefix:newPrefix];
    [newPrefix release];
  }
  else {
    NSString* stringValue = (NSString*)([value isKindOfClass:[NSString class]] ?
        value : [ZNModel copyStringForBoxedValue:value]);
    if (!stringValue) {
      return;
    }    
    NSAssert([stringValue isKindOfClass:[NSString class]],
             @"Attempting to encode non-String value!");

    NSString* outputKey;
    if ([keyPrefix length] != 0)
      outputKey = [[NSString alloc] initWithFormat:@"%@[%@]", keyPrefix, key];
    else
      outputKey = [key retain];

    [self outputValue:stringValue forKey:outputKey];
    if (stringValue != value) {
      [stringValue release];
    }
    [outputKey release];
  }
}

-(void)outputValue:(NSString*)value forKey:(NSString*)key {
  NSAssert1(NO,
            @"ZNFormEncoder subclass %s did not override +outputValue:forKey:"
            @"-outputValue:forString:",
            class_getName([self class]));
}

+(NSString*)copyContentTypeFor:(NSData*)encodedData {
  NSAssert1(NO,
            @"ZNFormEncoder subclass %s did not override +copyContentTypeFor:",
            class_getName([self class]));
  return nil;
}

@end

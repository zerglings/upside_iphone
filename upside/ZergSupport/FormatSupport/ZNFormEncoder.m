//
//  ZNFormEncoder.m
//  ZergSupport
//
//  Created by Victor Costan on 5/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNFormEncoder.h"

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

+(NSData*)copyEncodingFor:(NSDictionary*)dictionary
      usingFieldFormatter:(ZNFormFieldFormatter*)formatter {
  ZNFormEncoder* encoder = [[self alloc] initWithFieldFormatter:formatter];
  [encoder encode:dictionary];
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
    for (NSString* key in (NSDictionary*)object) {
      NSString* formattedKey = [fieldFormatter copyFormattedName:key];
      [self encodeKey:formattedKey
                value:[(NSDictionary*)object objectForKey:key]
            keyPrefix:keyPrefix];
      [formattedKey release];
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
    NSObject* realValue = [value isKindOfClass:[ZNModel class]] ?
    [(ZNModel*)value copyToDictionaryForcingStrings:YES] : value;

    NSString* newPrefix;
    if ([keyPrefix length] != 0)
      newPrefix = [[NSString alloc] initWithFormat:@"%@[%@]", keyPrefix, key];
    else
      newPrefix = [key retain];
    [self encode:realValue keyPrefix:newPrefix];
    [newPrefix release];

    if (realValue != value)
      [realValue release];
  }
  else {
    NSAssert([value isKindOfClass:[NSString class]],
             @"Attempting to encode non-String value!");

    NSString* outputKey;
    if ([keyPrefix length] != 0)
      outputKey = [[NSString alloc] initWithFormat:@"%@[%@]", keyPrefix, key];
    else
      outputKey = [key retain];

    [self outputValue:(NSString*)value forKey:outputKey];
    [outputKey release];
  }
}

-(void)outputValue:(NSString*)value forKey:(NSString*)key {
  NSAssert1(NO,
            @"ZNFormEncoder subclass %@ did not override "
            @"-outputValue:forString:",
            [self className]);
}

+(NSString*)copyContentTypeFor:(NSData*)encodedData {
  NSAssert1(NO,
            @"ZNFormEncoder subclass %@ did not override +copyContentTypeFor:",
            [self className]);
  return nil;
}

@end

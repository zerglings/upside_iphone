//
//  ZNFormURLEncoder.m
//  ZergSupport
//
//  Created by Victor Costan on 1/16/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNFormURLEncoder.h"


@implementation ZNFormURLEncoder

-(void)outputValue:(NSString*)value forKey:(NSString*)key {
  // & separates the key=value pairs.
  if ([output length] != 0)
    [output appendBytes:"&" length:1];

  NSString* encodedKey = (NSString*)
      CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                              (CFStringRef)key, NULL,
                                              (CFStringRef)@"&=+/;?:@",
                                              kCFStringEncodingUTF8);
  [output appendBytes:[encodedKey cStringUsingEncoding:NSUTF8StringEncoding]
               length:[encodedKey length]];
  [encodedKey release];

  [output appendBytes:"=" length:1];

  NSString* encodedValue = (NSString*)
      CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                              (CFStringRef)value,
                                              NULL,
                                              (CFStringRef)@"&=+/;?:@",
                                              kCFStringEncodingUTF8);
  [output appendBytes:[encodedValue cStringUsingEncoding:NSUTF8StringEncoding]
               length:[encodedValue length]];
  [encodedValue release];
}

+(NSData*)copyEncodingFor:(NSObject*)dictionaryOrModel
      usingFieldFormatter:(ZNFormFieldFormatter*)formatter {
  return [super copyEncodingFor:dictionaryOrModel
            usingFieldFormatter:formatter];
}

+(NSString*)copyContentTypeFor:(NSData*)encodedData {
  return [@"application/x-www-form-urlencoded" retain];
}

@end

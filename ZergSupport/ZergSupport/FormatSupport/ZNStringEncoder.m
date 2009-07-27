//
//  ZNStringEncoder.m
//  ZergSupport
//
//  Created by Victor Costan on 7/26/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNStringEncoder.h"


@implementation ZNStringEncoder

+(NSString*)copyHexStringForData:(NSData*)data {
  return [ZNStringEncoder copyHexStringForBytes:[data bytes]
                                         length:[data length]];
}

+(NSString*)copyHexStringForBytes:(const uint8_t*)bytes
                           length:(NSUInteger)length {
  NSMutableString* hexDigest = [[NSMutableString alloc] init];
  for (NSUInteger i = 0; i < length; i++) {
    [hexDigest appendFormat:@"%02x", bytes[i]];
  }
  NSString* returnValue = [[NSString alloc] initWithString:hexDigest];
  [hexDigest release];
  return returnValue;
}

@end

//
//  ZNMd5Digest.m
//  ZergSupport
//
//  Created by Victor Costan on 4/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNMd5Digest.h"

#import <CommonCrypto/CommonDigest.h>


@implementation ZNMd5Digest

+(NSData*)copyDigest:(NSData*)data {
  uint8_t digestBuffer[CC_MD5_DIGEST_LENGTH];
  CC_MD5([data bytes], [data length], digestBuffer);

  return [[NSData alloc] initWithBytes:digestBuffer
                                length:sizeof(digestBuffer)];
}

+(NSString*)copyHexDigest:(NSData*)data {
  uint8_t digestBuffer[CC_MD5_DIGEST_LENGTH];
  CC_MD5([data bytes], [data length], digestBuffer);

  NSMutableString* hexDigest = [[NSMutableString alloc] init];
  for (NSUInteger i = 0;
       i < sizeof(digestBuffer) / sizeof(*digestBuffer);
       i++) {
    [hexDigest appendFormat:@"%02x", digestBuffer[i]];
  }
  NSString* returnValue = [[NSString alloc] initWithString:hexDigest];
  [hexDigest release];
  return returnValue;
}

+(id<ZNDigester>)digester {
  return (id<ZNDigester>)[ZNMd5Digest class];
}
@end

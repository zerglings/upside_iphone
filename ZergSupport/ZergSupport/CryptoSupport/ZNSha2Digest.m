//
//  ZNSha2Digest.m
//  ZergSupport
//
//  Created by Victor Costan on 4/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNSha2Digest.h"

#import <CommonCrypto/CommonDigest.h>
#import "FormatSupport.h"


@implementation ZNSha2Digest

+(NSData*)copyDigest:(NSData*)data {
  uint8_t digestBuffer[CC_SHA256_DIGEST_LENGTH];
  CC_SHA256([data bytes], [data length], digestBuffer);

  return [[NSData alloc] initWithBytes:digestBuffer
                                length:sizeof(digestBuffer)];
}

+(NSString*)copyHexDigest:(NSData*)data {
  uint8_t digestBuffer[CC_SHA256_DIGEST_LENGTH];
  CC_SHA256([data bytes], [data length], digestBuffer);

  return [ZNStringEncoder copyHexStringForBytes:digestBuffer
                                         length:sizeof(digestBuffer)];
}

+(id<ZNDigester>)digester {
  return (id<ZNDigester>)[ZNSha2Digest class];
}
@end

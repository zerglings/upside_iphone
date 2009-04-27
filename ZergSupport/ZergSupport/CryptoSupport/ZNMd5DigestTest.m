//
//  ZNMd5DigestTest.m
//  ZergSupport
//
//  Created by Victor Costan on 4/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ZNMd5Digest.h"

@interface ZNMd5DigestTest : SenTestCase {
}
@end


@implementation ZNMd5DigestTest
-(void)testMd5Engine {
  uint8_t dataBytes[] = { 0x12, 0x55, 0xf9, 0x2b, 0x58, 0xb6, 0x8b, 0x25, 0xad,
                          0xb5, 0x71, 0xce, 0x5e, 0xf3, 0x46, 0x32 };
  NSData* data = [NSData dataWithBytes:dataBytes length:sizeof(dataBytes)];

  uint8_t goldBytes[] = { 0xce, 0x14, 0xe1, 0x9e, 0xbe, 0x57, 0x63, 0xac, 0x85,
                          0x5f, 0xf3, 0xad, 0x6f, 0x66, 0x0f, 0x76 };
  NSData* gold = [NSData dataWithBytes:goldBytes length:sizeof(goldBytes)];
  NSData* digest = [ZNMd5Digest copyDigest:data];
  STAssertEqualObjects(gold, digest, @"MD5 digest");

  NSString* goldHexDigest = @"ce14e19ebe5763ac855ff3ad6f660f76";
  NSString* hexDigest = [ZNMd5Digest copyHexDigest:data];
  STAssertEqualStrings(goldHexDigest, hexDigest, @"MD5 hex formatting");
}

@end

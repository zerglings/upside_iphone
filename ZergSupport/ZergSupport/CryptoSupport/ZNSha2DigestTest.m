//
//  ZNSha2DigestTest.m
//  ZergSupport
//
//  Created by Victor Costan on 4/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ZNSha2Digest.h"

@interface ZNSha2DigestTest : SenTestCase {
}
@end


@implementation ZNSha2DigestTest
-(void)testSha2Engine {
  uint8_t dataBytes[] = { 0x12, 0x55, 0xf9, 0x2b, 0x58, 0xb6, 0x8b, 0x25, 0xad,
                          0xb5, 0x71, 0xce, 0x5e, 0xf3, 0x46, 0x32 };
  NSData* data = [NSData dataWithBytes:dataBytes length:sizeof(dataBytes)];

  uint8_t goldBytes[] = { 0xc6, 0x80, 0x9f, 0xa3, 0x79, 0x70, 0x3a, 0xf0, 0x85,
                          0x89, 0x80, 0x46, 0x35, 0xb9, 0x23, 0xb6, 0xe9, 0xd5,
                          0xbc, 0xdc, 0x35, 0xca, 0xd3, 0xdd, 0x30, 0x33, 0xd6,
                          0x31, 0x31, 0xd2, 0x0e, 0x6c };
  NSData* gold = [NSData dataWithBytes:goldBytes length:sizeof(goldBytes)];
  NSData* digest = [ZNSha2Digest copyDigest:data];
  STAssertEqualObjects(gold, digest, @"SHA2 digest");

  NSString* goldHexDigest =
      @"c6809fa379703af08589804635b923b6e9d5bcdc35cad3dd3033d63131d20e6c";
  NSString* hexDigest = [ZNSha2Digest copyHexDigest:data];
  STAssertEqualStrings(goldHexDigest, hexDigest, @"SHA2 hex formatting");
}
@end

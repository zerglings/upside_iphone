//
//  ZNAesCipherTest.m
//  ZergSupport
//
//  Created by Victor Costan on 4/23/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ZNAesCipher.h"

@interface ZNAesCipherTest : SenTestCase {
  NSData* key;
  ZNAesCipher* cbcEncrypt;
  ZNAesCipher* cbcDecrypt;
  ZNAesCipher* ecbEncrypt;
  ZNAesCipher* ecbDecrypt;
}
@end


@implementation ZNAesCipherTest

-(void)setUp {
  uint8_t keyBytes[] = { 0xE8, 0xE9, 0xEA, 0xEB, 0xED, 0xEE, 0xEF, 0xF0, 0xF2,
                         0xF3, 0xF4, 0xF5, 0xF7, 0xF8, 0xF9, 0xFA };
  key = [[NSData alloc] initWithBytes:keyBytes
                                       length:sizeof(keyBytes)];
  
  cbcEncrypt = [[ZNAesCipher alloc] initWithKey:key encrypt:YES];
  cbcDecrypt = [[ZNAesCipher alloc] initWithKey:key encrypt:NO];
  ecbEncrypt = [[ZNAesCipher alloc] initWithKey:key encrypt:YES useCbc:NO];
  ecbDecrypt = [[ZNAesCipher alloc] initWithKey:key encrypt:NO useCbc:NO];
}
-(void)tearDown {
  [cbcEncrypt release];
  [cbcDecrypt release];
  [ecbEncrypt release];
  [ecbDecrypt release];
  [key release];
}

-(void)testAesEngine {
  uint8_t plainBytes[] = { 0x01, 0x4B, 0xAF, 0x22, 0x78, 0xA6, 0x9D, 0x33, 0x1D,
                           0x51, 0x80, 0x10, 0x36, 0x43, 0xE9, 0x9A };
  NSData* plain = [NSData dataWithBytes:plainBytes length:sizeof(plainBytes)];

  uint8_t ecbGoldBytes[] = { 0x67, 0x43, 0xC3, 0xD1, 0x51, 0x9A, 0xB4, 0xF2,
                             0xCD, 0x9A, 0x78, 0xAB, 0x09, 0xA5, 0x11, 0xBD };
  NSData* ecbGold = [NSData dataWithBytes:ecbGoldBytes
                                   length:sizeof(ecbGoldBytes)];  
  NSData* ecbCrypted = [ecbEncrypt crypt:plain];
  STAssertEqualObjects(ecbGold, ecbCrypted, @"AES ECB encryption failed");
  [ecbCrypted release];
  
  NSData* ecbDecrypted = [ecbDecrypt crypt:ecbGold];
  STAssertEqualObjects(plain, ecbDecrypted, @"AES ECB decryption failed");
  [ecbDecrypted release];
}

-(void)testCbc {
  uint8_t ivBytes[] = { 0xeb, 0x16, 0xba, 0xbb, 0x43, 0x13, 0xa8, 0xd1, 0x60,
                        0x97, 0xc4, 0x70, 0x1c, 0x20, 0xb5, 0x68 };
  NSData* iv = [NSData dataWithBytes:ivBytes length:sizeof(ivBytes)];

  uint8_t plainBytes[] = { 0x01, 0x4B, 0xAF, 0x22, 0x78, 0xA6, 0x9D, 0x33, 0x1D,
                           0x51, 0x80, 0x10, 0x36, 0x43, 0xE9, 0x9A };
  NSData* plain = [NSData dataWithBytes:plainBytes length:sizeof(plainBytes)];
  
  uint8_t cbcGoldBytes[] = { 0xc6, 0x80, 0x27, 0xd2, 0x7a, 0xfd, 0x0b, 0x98,
                             0xb0, 0xf6, 0xf2, 0x64, 0xdd, 0x6d, 0x4b, 0xf4 };
  NSData* cbcGold = [NSData dataWithBytes:cbcGoldBytes
                                   length:sizeof(cbcGoldBytes)];
  NSData* cbcCrypted = [cbcEncrypt crypt:plain withIv:iv];
  STAssertEqualObjects(cbcGold, cbcCrypted, @"AES CBC encryption failed");
  [cbcCrypted release];
  
  NSData* cbcDecrypted = [cbcDecrypt crypt:cbcGold withIv:iv];
  STAssertEqualObjects(plain, cbcDecrypted, @"AES CBC decryption failed");
  [cbcDecrypted release];
}

@end
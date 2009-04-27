//
//  ZNFileFprintTest.m
//  ZergSupport
//
//  Created by Victor Costan on 4/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TestSupport.h"

#import "ZNFileFprint.h"

#import "ZNAesCipher.h"
#import "ZNMd5Digest.h"


@interface ZNFileFprintTest : SenTestCase {
  NSString* filePath;
  NSData* key;
  NSData* iv;
}

@end


@implementation ZNFileFprintTest

-(void)setUp {
  uint8_t keyBytes[] = { 0xE8, 0xE9, 0xEA, 0xEB, 0xED, 0xEE, 0xEF, 0xF0, 0xF2,
  0xF3, 0xF4, 0xF5, 0xF7, 0xF8, 0xF9, 0xFA };
  key = [[NSData alloc] initWithBytes:keyBytes length:sizeof(keyBytes)];  
  uint8_t ivBytes[] = { 0xeb, 0x16, 0xba, 0xbb, 0x43, 0x13, 0xa8, 0xd1, 0x60,
                        0x97, 0xc4, 0x70, 0x1c, 0x20, 0xb5, 0x68 };
  iv = [[NSData alloc] initWithBytes:ivBytes length:sizeof(ivBytes)];
  filePath = [[[[NSBundle mainBundle] resourcePath]
               stringByAppendingPathComponent:@"ZNFileFprintTest.data"] retain];  
}

-(void)tearDown {
  [filePath release];
  [key release];
  [iv release];
}

-(void)testHexFprint {
  NSString* hexFprint = [ZNFileFprint copyHexFileFprint:filePath
                                                    key:key
                                                     iv:iv
                                            cipherClass:[ZNAesCipher
                                                         cipherClass]
                                               digester:[ZNMd5Digest digester]];
  STAssertEqualStrings(@"7e7e60c943d3bc6c011a862aa11dfe5a",
                       hexFprint, @"Hex fprint of data file");
  [hexFprint release];
} 

@end

//
//  ZNStringEncoderTest.m
//  ZergSupport
//
//  Created by Victor Costan on 7/26/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ZNStringEncoder.h"

@interface ZNStringEncoderTest : SenTestCase {
  NSData* hexEncodingData;
  NSString* goldHexEncoding;
}
@end


@implementation ZNStringEncoderTest

static uint8_t hexEncodingBytes[] = {0, 1, 5, 10, 16, 29, 36, 81, 255, 254, 93};

-(void)setUp {
  hexEncodingData = [[NSData alloc] initWithBytes:hexEncodingBytes
                                           length:sizeof(hexEncodingBytes)];
  goldHexEncoding = @"0001050a101d2451fffe5d";
}
-(void)tearDown {
  [hexEncodingData release];
}

-(void)testCopyHexStringForBytes {
  NSString* hexEncoding = [ZNStringEncoder
                           copyHexStringForBytes:hexEncodingBytes
                           length:[hexEncodingData length]];
  STAssertEqualStrings(goldHexEncoding, hexEncoding,
                       @"Incorrect hex-encoding");
  [hexEncoding release];
}

-(void)testCopyHexStringForData {
  NSString* hexEncoding = [ZNStringEncoder
                           copyHexStringForData:hexEncodingData];
  STAssertEqualStrings(goldHexEncoding, hexEncoding,
                       @"Incorrect hex-encoding");
  [hexEncoding release];
}

@end

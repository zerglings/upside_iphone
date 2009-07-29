//
//  ZNFormURLEncoderTest.m
//  ZergSupport
//
//  Created by Victor Costan on 1/16/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ZNFormFieldFormatter.h"
#import "ZNFormURLEncoder.h"


@interface ZNFormURLEncoderTest : SenTestCase {
  ZNFormFieldFormatter* identityFormatter;
  ZNFormFieldFormatter* snakeFormatter;
}
@end


@implementation ZNFormURLEncoderTest

-(void)setUp {
  identityFormatter = [ZNFormFieldFormatter identityFormatter];
  snakeFormatter = [ZNFormFieldFormatter formatterFromPropertiesTo:
                    kZNFormatterSnakeCase];
}

-(void)tearDown {
}

-(void)dealloc {
  [super dealloc];
}

-(void)testEmptyEncoding {
  NSDictionary* dict = [NSDictionary dictionary];
  NSData* data = [ZNFormURLEncoder copyEncodingFor:dict
                               usingFieldFormatter:identityFormatter];
  NSString* string = [[NSString alloc] initWithData:data
                       encoding:NSUTF8StringEncoding];
  STAssertEqualStrings(@"", string, @"Empty dictionary");
  NSString* contentType = [ZNFormURLEncoder copyContentTypeFor:data];
  STAssertEqualStrings(@"application/x-www-form-urlencoded",
                       contentType, @"Content-Type: directive value");
  [contentType release];
  [string release];
  [data release];
}

-(void)testEasyKeyValues {
  NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"val1", @"key1", @"val2", @"key2", nil];
  NSData* data = [ZNFormURLEncoder copyEncodingFor:dict
                               usingFieldFormatter:identityFormatter];
  NSString* string = [[NSString alloc] initWithData:data
                       encoding:NSUTF8StringEncoding];
  STAssertEqualStrings(@"key1=val1&key2=val2",
                       string, @"Straightforward one-level dictionary");
  NSString* contentType = [ZNFormURLEncoder copyContentTypeFor:data];
  STAssertEqualStrings(@"application/x-www-form-urlencoded",
                       contentType, @"Content-Type: directive value");
  [contentType release];
  [string release];
  [data release];
}

-(void)testEncoding {
  NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"val\0001", @"key\n1", @"val = 2", @"key&2", nil];
  NSData* data = [ZNFormURLEncoder copyEncodingFor:dict
                               usingFieldFormatter:identityFormatter];
  NSString* string = [[NSString alloc] initWithData:data
                       encoding:NSUTF8StringEncoding];
  STAssertEqualStrings(@"key%0A1=val%001&key%262=val%20%3D%202",
                       string, @"Escapes in keys and values");
  NSString* contentType = [ZNFormURLEncoder copyContentTypeFor:data];
  STAssertEqualStrings(@"application/x-www-form-urlencoded",
                       contentType, @"Content-Type: directive value");
  [contentType release];
  [string release];
  [data release];
}

-(void)testCharacterEscaping {
  uint8_t chars[256];
  for (size_t i = 0; i < 256; i++) chars[i] = i;

  NSString* allChars =
      [[NSString alloc] initWithBytes:chars
                               length:256
                             encoding:NSISOLatin1StringEncoding];
  NSDictionary* dict = [NSDictionary dictionaryWithObject:allChars
                                                   forKey:@"k"];
  NSString* goldenEncoding = @"k=%00%01%02%03%04%05%06%07%08%09%0A%0B%0C%0D%0E"
      @"%0F%10%11%12%13%14%15%16%17%18%19%1A%1B%1C%1D%1E%1F%20!%22%23$%25%26'()"
      @"*%2B,-.%2F0123456789%3A%3B%3C%3D%3E%3F%40ABCDEFGHIJKLMNOPQRSTUVWXYZ%5B"
      @"%5C%5D%5E_%60abcdefghijklmnopqrstuvwxyz%7B%7C%7D~%7F%C2%80%C2%81%C2%82"
      @"%C2%83%C2%84%C2%85%C2%86%C2%87%C2%88%C2%89%C2%8A%C2%8B%C2%8C%C2%8D%C2"
      @"%8E%C2%8F%C2%90%C2%91%C2%92%C2%93%C2%94%C2%95%C2%96%C2%97%C2%98%C2%99"
      @"%C2%9A%C2%9B%C2%9C%C2%9D%C2%9E%C2%9F%C2%A0%C2%A1%C2%A2%C2%A3%C2%A4%C2"
      @"%A5%C2%A6%C2%A7%C2%A8%C2%A9%C2%AA%C2%AB%C2%AC%C2%AD%C2%AE%C2%AF%C2%B0"
      @"%C2%B1%C2%B2%C2%B3%C2%B4%C2%B5%C2%B6%C2%B7%C2%B8%C2%B9%C2%BA%C2%BB%C2"
      @"%BC%C2%BD%C2%BE%C2%BF%C3%80%C3%81%C3%82%C3%83%C3%84%C3%85%C3%86%C3%87"
      @"%C3%88%C3%89%C3%8A%C3%8B%C3%8C%C3%8D%C3%8E%C3%8F%C3%90%C3%91%C3%92%C3"
      @"%93%C3%94%C3%95%C3%96%C3%97%C3%98%C3%99%C3%9A%C3%9B%C3%9C%C3%9D%C3%9E"
      @"%C3%9F%C3%A0%C3%A1%C3%A2%C3%A3%C3%A4%C3%A5%C3%A6%C3%A7%C3%A8%C3%A9%C3"
      @"%AA%C3%AB%C3%AC%C3%AD%C3%AE%C3%AF%C3%B0%C3%B1%C3%B2%C3%B3%C3%B4%C3%B5"
      @"%C3%B6%C3%B7%C3%B8%C3%B9%C3%BA%C3%BB%C3%BC%C3%BD%C3%BE%C3%BF";
  NSData* encoding = [ZNFormURLEncoder copyEncodingFor:dict
                                   usingFieldFormatter:identityFormatter];
  NSString* encodingStr = [[NSString alloc] initWithData:encoding
                                                encoding:NSUTF8StringEncoding];
  STAssertEqualStrings(goldenEncoding, encodingStr,
                       @"Escapes across the ASCII charset");
  [encoding release];
  [encodingStr release];
}

-(void)testKeyFormatting {
  NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"val1", @"keyOne",
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSDictionary dictionaryWithObjectsAndKeys:
                          @"val211", @"keyTwoOneOne", nil],
                         @"keyTwoOne", nil],
                        @"keyTwo", nil];
  NSData* data = [ZNFormURLEncoder copyEncodingFor:dict
                               usingFieldFormatter:snakeFormatter];
  NSString* string = [[NSString alloc] initWithData:data
                                           encoding:NSUTF8StringEncoding];
  STAssertEqualStrings(@"key_one=val1&key_two%5Bkey_two_one%5D"
                       @"%5Bkey_two_one_one%5D=val211",
                       string,
                       @"2 levels of nested dictionaries with key formatting");
  NSString* contentType = [ZNFormURLEncoder copyContentTypeFor:data];
  STAssertEqualStrings(@"application/x-www-form-urlencoded",
                       contentType, @"Content-Type: directive value");
  [contentType release];
  [string release];
  [data release];
}

@end

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

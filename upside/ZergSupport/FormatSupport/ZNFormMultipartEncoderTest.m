//
//  ZNFormMultipartEncoderTest.m
//  ZergSupport
//
//  Created by Victor Costan on 5/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "FormatSupport.h"
#import "ZNFormMultipartEncoder.h"


@interface ZNFormMultipartEncoder ()
// This is not part of the public API, but it needs to be stubbed out and tested
// individually.
+(NSData*)newRandomBoundary;
@end


// Stub out boundary generation, so the encoding is deterministic.
@interface ZNFormMultipartEncoderStub : ZNFormMultipartEncoder
@end
@implementation ZNFormMultipartEncoderStub
// Boundaries must be 16-characters long, just like in the encoder.
static NSString* kBoundaries[] = { @"ABoundary1235467",
                                   @"BBoundary1235467", @"CBoundary1235467" };
static NSUInteger boundaryOffset = 0;
+(NSData*)newRandomBoundary {
  return [[kBoundaries[boundaryOffset++] dataUsingEncoding:NSUTF8StringEncoding]
          retain];
}
+(void)resetBoundaryOffset {
  boundaryOffset = 0;
}
@end


@interface ZNFormMultipartEncoderTest : SenTestCase {
  ZNFormFieldFormatter* identityFormatter;
  ZNFormFieldFormatter* snakeFormatter;
}
@end


@implementation ZNFormMultipartEncoderTest

-(void)setUp {
  identityFormatter = [ZNFormFieldFormatter identityFormatter];
  snakeFormatter = [ZNFormFieldFormatter formatterFromPropertiesTo:
                    kZNFormatterSnakeCase];
  [ZNFormMultipartEncoderStub resetBoundaryOffset];
}

-(void)tearDown {
}

-(void)dealloc {
  [super dealloc];
}

-(void)testBoundaryGenerator {
  NSMutableArray* boundaries = [[NSMutableArray alloc] init];

  for (NSUInteger i = 0; i < 60; i++) {
    NSData* boundary = [ZNFormMultipartEncoder newRandomBoundary];
    [boundaries addObject:[[[NSString alloc] initWithData:boundary
                                                encoding:NSUTF8StringEncoding]
                           autorelease]];
    [boundary release];
  }
  [boundaries sortUsingSelector:@selector(compare:)];
  for (NSUInteger i = 1; i < [boundaries count]; i++) {
    STAssertEquals([[boundaries objectAtIndex:(i - 1)] length],
                   [[boundaries objectAtIndex:i] length],
                   @"Boundaries should have the same length");
    STAssertNotEqualStrings([boundaries objectAtIndex:(i - 1)],
                            [boundaries objectAtIndex:i],
                            @"Randomly generated boundaries should differ");
  }
  [boundaries release];
}

-(void)testEmptyEncoding {
  NSDictionary* dict = [NSDictionary dictionary];
  NSData* data = [ZNFormMultipartEncoderStub copyEncodingFor:dict
                                         usingFieldFormatter:identityFormatter];
  NSString* string = [[NSString alloc] initWithData:data
                                           encoding:NSUTF8StringEncoding];
  STAssertEqualStrings(@"--ABoundary1235467--\r\n", string,
                       @"Empty dictionary");
  NSString* contentType = [ZNFormMultipartEncoder copyContentTypeFor:data];
  STAssertEqualStrings(@"multipart/form-data; boundary=ABoundary1235467",
                       contentType, @"Content-Type: directive value");
  [contentType release];
  [string release];
  [data release];
}

-(void)testEasyKeyValues {
  NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"val1", @"key1", @"val2", @"key2", nil];
  NSData* data = [ZNFormMultipartEncoderStub copyEncodingFor:dict
                                         usingFieldFormatter:identityFormatter];
  NSString* string = [[NSString alloc] initWithData:data
                                           encoding:NSUTF8StringEncoding];
  STAssertEqualStrings(@"--ABoundary1235467\r\nContent-Disposition: form-data; "
                       @"name=\"key1\"\r\n"
                       @"Content-Type: text-plain; charset=utf8;\r\n\r\n"
                       @"val1\r\n"
                       @"--ABoundary1235467\r\nContent-Disposition: form-data; "
                       @"name=\"key2\"\r\n"
                       @"Content-Type: text-plain; charset=utf8;\r\n\r\n"
                       @"val2\r\n--ABoundary1235467--\r\n",
                       string, @"Straightforward one-level dictionary");
  NSString* contentType = [ZNFormMultipartEncoder copyContentTypeFor:data];
  STAssertEqualStrings(@"multipart/form-data; boundary=ABoundary1235467",
                       contentType, @"Content-Type: directive value");
  [contentType release];
  [string release];
  [data release];
}

-(void)testBoundaryDetection {
  NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"keyABoundary1235467", @"valueBBoundary1235467", nil];
  NSData* data = [ZNFormMultipartEncoderStub copyEncodingFor:dict
                                         usingFieldFormatter:identityFormatter];
  NSString* string = [[NSString alloc] initWithData:data
                                           encoding:NSUTF8StringEncoding];
  STAssertEqualStrings(@"--CBoundary1235467\r\nContent-Disposition: form-data; "
                       @"name=\"valueBBoundary1235467\"\r\n"
                       @"Content-Type: text-plain; charset=utf8;\r\n\r\n"
                       @"keyABoundary1235467\r\n"
                       @"--CBoundary1235467--\r\n",
                       string, @"Key and value containing boundaries");
  NSString* contentType = [ZNFormMultipartEncoder copyContentTypeFor:data];
  STAssertEqualStrings(@"multipart/form-data; boundary=CBoundary1235467",
                       contentType, @"Content-Type: directive value");
  [contentType release];
  [string release];
  [data release];
}

@end

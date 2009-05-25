//
//  ZNFormEncoderTest.m
//  ZergSupport
//
//  Created by Victor Costan on 5/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "FormatSupport.h"
#import "ModelSupport.h"
#import "ZNFormEncoder.h"


// Mock encoder subclass that appends the keys and values in the format
// key1:value1;key2:value2;
@interface ZNFormEncoderTestEncoder : ZNFormEncoder
@end
@implementation ZNFormEncoderTestEncoder
-(void)outputValue:(NSString*)value forKey:(NSString*)key {
  [output appendData:[key dataUsingEncoding:NSUTF8StringEncoding]];
  [output appendBytes:": " length:2];
  [output appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
  [output appendBytes:"; " length:2];
}
@end


// Mock ZergSupport model for testing the encoder.
@interface ZNFormEncoderTestModel: ZNModel {
  NSString* key11;
  NSUInteger key12;
}
@property (nonatomic, retain) NSString* key11;
@property (nonatomic) NSUInteger key12;
@end
@implementation ZNFormEncoderTestModel
@synthesize key11, key12;
-(void)dealloc {
  [key11 release];
  [super dealloc];
}
@end


@interface ZNFormEncoderTest : SenTestCase {
  ZNFormEncoderTestModel* testModel;
  ZNFormFieldFormatter* identityFormatter;
  ZNFormFieldFormatter* snakeFormatter;
}
@end


@implementation ZNFormEncoderTest

-(void)setUp {
  testModel = [[ZNFormEncoderTestModel alloc] initWithProperties:nil];
  testModel.key11 = @"val11";
  testModel.key12 = 31415;

  identityFormatter = [ZNFormFieldFormatter identityFormatter];
  snakeFormatter = [ZNFormFieldFormatter formatterFromPropertiesTo:
                    kZNFormatterSnakeCase];
}
-(void)tearDown {
  [testModel release];
}

-(void)testEmptyEncoding {
  NSDictionary* dict = [NSDictionary dictionary];
  NSData* data = [ZNFormEncoderTestEncoder copyEncodingFor:dict
                                       usingFieldFormatter:identityFormatter];
  NSString* string = [[NSString alloc] initWithData:data
                                           encoding:NSUTF8StringEncoding];
  STAssertEqualStrings(@"", string, @"Empty dictionary");
  [data release];
  [string release];
}

-(void)testEasyOneLevel {
  NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"val1", @"key1", @"val2", @"key2", nil];
  NSData* data = [ZNFormEncoderTestEncoder copyEncodingFor:dict
                                       usingFieldFormatter:identityFormatter];
  NSString* string = [[NSString alloc] initWithData:data
                                           encoding:NSUTF8StringEncoding];
  STAssertEqualStrings(@"key1: val1; key2: val2; ", string,
                       @"Straight-forward one-level dictionary");
  [data release];
  [string release];
}

-(void)testSubDictionary {
  NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"val1", @"key1",
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         @"val21", @"key21", @"val22", @"key22", nil],
                        @"key2", nil];
  NSData* data = [ZNFormEncoderTestEncoder copyEncodingFor:dict
                                       usingFieldFormatter:identityFormatter];
  NSString* string = [[NSString alloc] initWithData:data
                                           encoding:NSUTF8StringEncoding];
  // This is dependent on how NSStrings hash. Wish it weren't.
  STAssertEqualStrings(@"key1: val1; key2[key22]: val22; key2[key21]: val21; ",
                       string, @"Dictionary nested in another dictionary");
  [data release];
  [string release];
}

-(void)testSubSubDictionary {
  NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"val1", @"key1",
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSDictionary dictionaryWithObjectsAndKeys:
                          @"val211", @"key211", nil],
                         @"key21", nil],
                        @"key2", nil];
  NSData* data = [ZNFormEncoderTestEncoder copyEncodingFor:dict
                                       usingFieldFormatter:identityFormatter];
  NSString* string = [[NSString alloc] initWithData:data
                                           encoding:NSUTF8StringEncoding];
  STAssertEqualStrings(@"key1: val1; key2[key21][key211]: val211; ",
                       string, @"2 levels of nested dictionaries");
  [data release];
  [string release];
}

-(void)testSubArray {
  NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"val1", @"key1",
                        [NSArray arrayWithObjects: @"val21", @"val22", nil],
                        @"key2", nil];
  NSData* data = [ZNFormEncoderTestEncoder copyEncodingFor:dict
                                       usingFieldFormatter:identityFormatter];
  NSString* string = [[NSString alloc] initWithData:data
                                           encoding:NSUTF8StringEncoding];
  // This is dependent on how NSStrings hash. Wish it weren't.
  STAssertEqualStrings(@"key1: val1; key2[]: val21; key2[]: val22; ",
                       string, @"Array nested inside dictionary");
  [data release];
  [string release];
}

-(void)testModel {
  NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                        testModel, @"key1", nil];
  NSData* data = [ZNFormEncoderTestEncoder copyEncodingFor:dict
                                       usingFieldFormatter:identityFormatter];
  NSString* string = [[NSString alloc] initWithData:data
                                           encoding:NSUTF8StringEncoding];
  // This is dependent on how NSStrings hash. Wish it weren't.
  STAssertEqualStrings(@"key1[key11]: val11; key1[key12]: 31415; ",
                       string, @"Model inside dictionary");
  [data release];
  [string release];
}

-(void)testKeyFormatting {
  NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"val1", @"keyOne",
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSDictionary dictionaryWithObjectsAndKeys:
                          @"val211", @"keyTwoOneOne", nil],
                         @"keyTwoOne", nil],
                        @"keyTwo", nil];
  NSData* data = [ZNFormEncoderTestEncoder copyEncodingFor:dict
                                       usingFieldFormatter:snakeFormatter];
  NSString* string = [[NSString alloc] initWithData:data
                                           encoding:NSUTF8StringEncoding];
  STAssertEqualStrings(@"key_one: val1; key_two[key_two_one][key_two_one_one]: "
                       @"val211; ", string,
                       @"2 levels of nested dictionaries with key formatting");
  [data release];
  [string release];
}

@end

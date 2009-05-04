//
//  ZNDictionaryJsonParserTest.m
//  ZergSupport
//
//  Created by Victor Costan on 5/2/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ZNDictionaryJsonParser.h"

#import "ZNFormFieldFormatter+Snake2LCamel.h"

static NSString* kContextObject = @"This is the context";

@interface ZNDictionaryJsonParserTest :
    SenTestCase <ZNDictionaryJsonParserDelegate> {
  ZNDictionaryJsonParser* parser;
  NSDictionary* json;
  NSObject* parseContext;
  BOOL parseSuccess;
}

@end


@implementation ZNDictionaryJsonParserTest

-(void)setUp {
  parser = [[ZNDictionaryJsonParser alloc]
            initWithKeyFormatter:[ZNFormFieldFormatter snakeToLCamelFormatter]];
  parser.context = kContextObject;
  parser.delegate = self;

  NSString *filePath = [[[NSBundle mainBundle] resourcePath]
                        stringByAppendingPathComponent:
                        @"ZNDictionaryJsonParserTest.json"];

  NSData* data = [NSData dataWithContentsOfFile:filePath];
  json = nil;
  parseSuccess = [parser parseData:data];
}
-(void)parsedJson:(NSDictionary*)jsonData context:(id)context {
  json = jsonData;
  parseContext = context;
}
-(void)tearDown {
  [parser release];
  [json release];
}

-(void)testSuccess {
  STAssertEquals(YES, parseSuccess, @"JSON parsing unsuccessful");
  STAssertEquals(kContextObject, parseContext, @"Wrong parse context");
}

-(void)testPrimitives {
  NSDictionary* primitives = [json objectForKey:@"primitives"];
  STAssertNotNil(primitives, @"primitives object not parsed");

  STAssertEqualObjects([NSNumber numberWithBool:YES],
                       [primitives objectForKey:@"true"], @"true FAIL");
  STAssertEqualObjects([NSNumber numberWithBool:NO],
                       [primitives objectForKey:@"false"], @"false FAIL");
  STAssertEqualObjects([NSNull null],
                       [primitives objectForKey:@"null"], @"null FAIL");
}

-(void)testNumbers {
  NSDictionary* numbers = [json objectForKey:@"numbers"];
  STAssertNotNil(numbers, @"numbers object not parsed");

  STAssertEqualObjects([NSNumber numberWithInteger:0],
                       [numbers objectForKey:@"zero"], @"zero FAIL");
  STAssertEqualObjects([NSNumber numberWithInteger:-1000],
                       [numbers objectForKey:@"cash"], @"negative FAIL");
  STAssertEqualsWithAccuracy(3.141592,
                             [(NSNumber*)[numbers objectForKey:@"pi"]
                              doubleValue],
                             0.00000001, @"pi FAIL");
}

-(void)testArrays {
  NSDictionary* arrays = [json objectForKey:@"arrays"];
  STAssertNotNil(arrays, @"arrays object not parsed");

  NSArray* goldSimple =
      [NSArray arrayWithObjects:
       [NSNumber numberWithInteger:1], @"a", [NSNumber numberWithBool:YES],
       nil];
  STAssertEqualObjects(goldSimple, [arrays objectForKey:@"simple"],
                       @"simple array FAIL");

  NSArray* goldNested =
      [NSArray arrayWithObjects:
       [NSNumber numberWithInteger:1],
       [NSArray arrayWithObjects:
        [NSNumber numberWithInteger:2],
        [NSNumber numberWithInteger:3],
        nil],
       [NSDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithInteger:2], @"a",
        [NSArray arrayWithObject:[NSNumber numberWithInteger:3]], @"b",
        nil], nil];
  STAssertEqualObjects(goldNested, [arrays objectForKey:@"nested"],
                       @"nested array FAIL");
}

-(void)testStrings {
  NSDictionary* strings = [json objectForKey:@"strings"];
  STAssertNotNil(strings, @"strings object not parsed");

  STAssertEqualStrings(@"", [strings objectForKey:@"empty"],
                       @"empty FAIL");
  STAssertEqualStrings(@"awkward but not odd", [strings objectForKey:@"simple"],
                       @"simple FAIL");
  STAssertEqualStrings(@"boom \"headshot\"!\ndone",
                       [strings objectForKey:@"escaped"], @"escaped FAIL");
  STAssertEqualStrings(@"\u1234\u5678\u9abc\u0def",
                       [strings objectForKey:@"unicoded"], @"unicoded FAIL");
  STAssertEqualStrings(@"'double' quotes",
                       [strings objectForKey:@"dquotes"],
                       @"double quotes FAIL");
  STAssertEqualStrings(@"\"single\" quotes",
                       [strings objectForKey:@"squotes"],
                       @"single quotes FAIL");
}

-(void)testKeyFormatting {
  NSDictionary* formatting = [json objectForKey:@"caseFormatting"];
  STAssertNotNil(formatting, @"caseFormatting object not parsed");

  STAssertEqualStrings(@"more_snakes", [formatting objectForKey:@"snakeCase"],
                       @"snake to camel key conversion failed");
  STAssertEqualStrings(@"moreCamels",
                       [formatting objectForKey:@"camelCase"],
                       @"camel to camel key conversion failed");
}

-(void)testParseValue {
  NSDictionary* goldDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithInt:1], @"a",
                                  [NSNumber numberWithBool:NO], @"b", nil];
  STAssertEqualObjects(goldDictionary,
                       [ZNDictionaryJsonParser
                        parseValue:@"{'a': 1, 'b': false}"],
                       @"Dictionary value parsing");

  NSArray* goldArray = [NSArray arrayWithObjects:
                        @"a", [NSNumber numberWithInt:1], @"b", [NSNull null],
                        nil];
  STAssertEqualObjects(goldArray,
                       [ZNDictionaryJsonParser
                        parseValue:@"['a', 1, 'b', null]"],
                       @"Array value parsing");

  STAssertEqualStrings(@"vodka",
                       [ZNDictionaryJsonParser parseValue:@"'vodka'"],
                       @"String value parsing");

  STAssertEqualObjects([NSNumber numberWithDouble:3.141592],
                       [ZNDictionaryJsonParser parseValue:@"3.141592"],
                       @"Number value parsing");

  STAssertEqualObjects([NSNull null],
                       [ZNDictionaryJsonParser parseValue:@"null"],
                       @"Primitive parsing");
}

@end

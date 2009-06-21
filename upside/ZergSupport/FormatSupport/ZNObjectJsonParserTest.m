//
//  ZNObjectJsonParserTest.m
//  ZergSupport
//
//  Created by Victor Costan on 5/2/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ZNObjectJsonParser.h"

#import "ZNFormFieldFormatter+Snake2LCamel.h"

static NSString* kContextObject = @"This is the context";

@interface ZNObjectJsonParserTest :
    SenTestCase <ZNObjectJsonParserDelegate> {
  ZNObjectJsonParser* parser;
  NSDictionary* json;
  NSArray* jsonArray;
  NSObject* parseContext;
  NSObject** parseTarget;
  BOOL dictionaryParseSuccess, arrayParseSuccess;
}

@end


@implementation ZNObjectJsonParserTest

-(void)setUp {
  parser = [[ZNObjectJsonParser alloc]
            initWithKeyFormatter:[ZNFormFieldFormatter snakeToLCamelFormatter]];
  parser.context = kContextObject;
  parser.delegate = self;

  NSString *dictionaryFilePath = [[[self testBundle] resourcePath]
                                  stringByAppendingPathComponent:
                                  @"ZNObjectJsonParserTestDictionary.json"];
  NSString *arrayFilePath = [[[self testBundle] resourcePath]
                             stringByAppendingPathComponent:
                             @"ZNObjectJsonParserTestArray.json"];

  NSData* dictionaryData = [NSData dataWithContentsOfFile:dictionaryFilePath];
  NSData* arrayData = [NSData dataWithContentsOfFile:arrayFilePath];
  json = nil;
  parseTarget = &json;
  dictionaryParseSuccess = [parser parseData:dictionaryData];
  jsonArray = nil;
  parseTarget = &jsonArray;
  arrayParseSuccess = [parser parseData:arrayData];
}
-(void)parsedJson:(NSObject*)jsonData context:(id)context {
  *parseTarget = [jsonData retain];
  parseContext = context;
}
-(void)tearDown {
  [parser release];
  [json release];
  [jsonArray release];
}

-(void)testSuccess {
  STAssertEquals(YES, dictionaryParseSuccess,
                 @"JSON dictionary parsing unsuccessful");
  STAssertEquals(YES, arrayParseSuccess,
                 @"JSON array parsing unsuccessful");
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

-(void)testSets {
  NSDictionary* sets = [json objectForKey:@"sets"];
  STAssertNotNil(sets, @"sets object not parsed");

  NSSet* goldSimple =
      [NSSet setWithObjects:
       [NSNumber numberWithInteger:1], @"a", [NSNumber numberWithBool:YES],
       nil];
  STAssertEqualObjects(goldSimple, [sets objectForKey:@"simple"],
                       @"simple set FAIL");

  NSSet* goldNested =
      [NSSet setWithObjects:
       [NSNumber numberWithInteger:1],
       [NSSet setWithObjects:
        [NSNumber numberWithInteger:2],
        [NSNumber numberWithInteger:3],
        nil],
       [NSDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithInteger:2], @"a",
        [NSArray arrayWithObject:[NSNumber numberWithInteger:3]], @"b",
        nil], nil];
  STAssertEqualObjects(goldNested, [sets objectForKey:@"nested"],
                       @"nested set FAIL");

  NSSet* goldRepeated = [NSSet setWithObjects: @"a", @"d", nil];
  STAssertEqualObjects(goldRepeated, [sets objectForKey:@"repeated"],
                       @"set with repeated values FAIL");
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

-(void)testParsedArray {
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
  STAssertEqualObjects(goldNested, jsonArray, @"Failed to parse JSONP array");
}

-(void)testParseValue {
  NSDictionary* goldDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithInt:1], @"a",
                                  [NSNumber numberWithBool:NO], @"b", nil];
  STAssertEqualObjects(goldDictionary,
                       [ZNObjectJsonParser parseValue:@"{'a': 1, 'b': false}"],
                       @"Dictionary value parsing");

  NSArray* goldArray = [NSArray arrayWithObjects:
                        @"a", [NSNumber numberWithInt:1], @"b", [NSNull null],
                        nil];
  STAssertEqualObjects(goldArray,
                       [ZNObjectJsonParser parseValue:@"['a', 1, 'b', null]"],
                       @"Array value parsing");

  STAssertEqualStrings(@"vodka",
                       [ZNObjectJsonParser parseValue:@"'vodka'"],
                       @"String value parsing");

  STAssertEqualObjects([NSNumber numberWithDouble:3.141592],
                       [ZNObjectJsonParser parseValue:@"3.141592"],
                       @"Number value parsing");

  STAssertEqualObjects([NSNull null],
                       [ZNObjectJsonParser parseValue:@"null"],
                       @"Primitive parsing");
}

@end

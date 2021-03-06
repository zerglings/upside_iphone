//
//  ZNObjectQuery.m
//  ZergSupport
//
//  Created by Victor Costan on 5/2/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ZNObjectQuery.h"

#import "ZNObjectJsonParser.h"


@interface ZNObjectQuery ()

// Non-public API, to make testing easier.
+(NSMutableArray*)copyQueryStringSplit:(NSString*)queryString;

@end


@interface ZNObjectQueryTest : SenTestCase {
  NSObject* simpleHash;
  NSObject* simpleArray;
  NSObject* arrayOfHashes;
}

@end


@implementation ZNObjectQueryTest

-(void)setUp {
  simpleHash = [ZNObjectJsonParser parseValue:
                @"{'a': {'b': ['c', 'd'], 'e': {'f': 'g'}}}"];
  simpleArray =
      [ZNObjectJsonParser parseValue:
       @"[['a', 'b'], ['c', 'd'], [['e', 'f'], ['g', 'h', 'i', 'j']]]"];

  arrayOfHashes =
      [ZNObjectJsonParser parseValue:
       @"[{'awe': {'one': 'two'}}, {'boo': [4, 5]}, {'awe': 'three'}]"];
}
-(void)tearDown {
  [simpleHash release];
  [simpleArray release];
  [arrayOfHashes release];
}

-(void)testQuerySplitting {
  NSString* empty = @"/";
  NSArray* goldenEmpty = [NSArray array];
  STAssertEqualObjects(goldenEmpty,
                       [ZNObjectQuery copyQueryStringSplit:empty],
                       @"Empty query");

  NSString* simple = @"/one/two/3";
  NSArray* goldenSimple = [NSArray arrayWithObjects:@"one", @"two", @"3", nil];
  STAssertEqualObjects(goldenSimple,
                       [ZNObjectQuery copyQueryStringSplit:simple],
                       @"Simple query");

  NSString* wildcards = @"|*|two|?|3";
  NSArray* goldenWildcards = [NSArray arrayWithObjects:
                              [NSNumber numberWithBool:YES], @"two",
                              [NSNumber numberWithBool:NO], @"3", nil];
  STAssertEqualObjects(goldenWildcards,
                       [ZNObjectQuery copyQueryStringSplit:wildcards],
                       @"Wildcard query");
}

-(void)testEmptyQuery {
  ZNObjectQuery* query = [ZNObjectQuery newCompile:@"/"];
  NSArray* result = [query newRun:simpleHash];
  STAssertEqualObjects([NSArray arrayWithObject:simpleHash],
                       result, @"Empty query should yield original object");
}

-(void)testHashIndexing {
  ZNObjectQuery* query = [ZNObjectQuery newCompile:@"/a/b"];
  NSArray* result = [query newRun:simpleHash];
  STAssertEqualObjects([ZNObjectJsonParser parseValue:@"[['c', 'd']]"],
                       result, @"Hash indexing");
  [result release];
  [query release];
}

-(void)testArrayIndexing {
  ZNObjectQuery* query = [ZNObjectQuery newCompile:@"/2/1/0"];
  NSArray* result = [query newRun:simpleArray];
  STAssertEqualObjects([NSArray arrayWithObject:@"g"],
                       result, @"Array indexing");
  [result release];
  [query release];
}

-(void)testSimpleIndexing {
  ZNObjectQuery* query = [ZNObjectQuery newCompile:@"/a/b/1"];
  NSArray* result = [query newRun:simpleHash];
  STAssertEqualObjects([NSArray arrayWithObject:@"d"],
                       result, @"Hash+array indexing");
  [result release];
  [query release];
}

-(void)testSingleLevelInArraysImmediate {
  ZNObjectQuery* query = [ZNObjectQuery newCompile:@"/?/1"];
  NSArray* result = [query newRun:simpleArray];
  STAssertEqualObjects([ZNObjectJsonParser parseValue:@"[['c', 'd']]"],
                       result, @"Single-level wild card in arrays");
  [result release];
  [query release];
}

-(void)testSingleLevelInArraysNonImmediate {
  NSObject* object = [ZNObjectJsonParser parseValue:
                      @"[['a', 'b', 'c'], ['d', 'e', 'f']]"];
  ZNObjectQuery* query = [ZNObjectQuery newCompile:@"/?/2"];
  NSArray* result = [query newRun:object];
  NSArray* goldenResult = [NSArray arrayWithObjects:@"c", @"f", nil];
  STAssertEqualObjects(goldenResult,
                       result, @"Single-level wild card in arrays");
  [result release];
  [query release];
  [object release];
}

-(void)testSingleLevelInArraysFail {
  ZNObjectQuery* query = [ZNObjectQuery newCompile:@"/?/3"];
  NSArray* result = [query newRun:simpleHash];
  STAssertEqualObjects([NSArray array],
                       result, @"Single-level wild card in arrays");
  [result release];
  [query release];
}

-(void)testSingleLevelInArraysTerminal {
  ZNObjectQuery* query = [ZNObjectQuery newCompile:@"/2/?"];
  NSArray* result = [query newRun:simpleArray];
  STAssertEqualObjects([ZNObjectJsonParser parseValue:
                        @"[['e', 'f'], ['g', 'h', 'i', 'j']]"],
                       result, @"Single-level wild card in arrays");
  [result release];
  [query release];

}

-(void)testSingleLevelInHashesImmediate {
  ZNObjectQuery* query = [ZNObjectQuery newCompile:@"/?/a"];
  NSArray* result = [query newRun:simpleHash];
  STAssertEqualObjects([ZNObjectJsonParser parseValue:
                        @"[{'b': ['c', 'd'], 'e': {'f': 'g'}}]"],
                       result, @"Single-level wild card in hashes");
  [result release];
  [query release];
}

-(void)testSingleLevelInHashesNonImmediate {
  ZNObjectQuery* query = [ZNObjectQuery newCompile:@"/?/e"];
  NSArray* result = [query newRun:simpleHash];
  STAssertEqualObjects([ZNObjectJsonParser parseValue:@"[{'f': 'g'}]"],
                       result, @"Single-level wild card in hashes");
  [result release];
  [query release];
}

-(void)testSingleLevelInHashesFail {
  ZNObjectQuery* query = [ZNObjectQuery newCompile:@"/?/f"];
  NSArray* result = [query newRun:simpleHash];
  STAssertEqualObjects([NSArray array],
                       result, @"Single-level wild card in hashes");
  [result release];
  [query release];
}

-(void)testMultiLevelInArrays {
  ZNObjectQuery* query = [ZNObjectQuery newCompile:@"/*/3"];
  NSArray* result = [query newRun:simpleArray];
  STAssertEqualObjects([NSArray arrayWithObject:@"j"],
                       result, @"Multi-level wild card in arrays");
  [result release];
  [query release];
}

-(void)testMultiLevelInHashes {
  ZNObjectQuery* query = [ZNObjectQuery newCompile:@"/*/f"];
  NSArray* result = [query newRun:simpleHash];
  STAssertEqualObjects([NSArray arrayWithObject:@"g"],
                       result, @"Multi-level wild card in hashes");
  [result release];
  [query release];
}

-(void)testSingleLevelInArrayOfHashes {
  ZNObjectQuery* query = [ZNObjectQuery newCompile:@"/?/awe"];
  NSArray* result = [query newRun:arrayOfHashes];
  STAssertEqualObjects([ZNObjectJsonParser
                        parseValue:@"[{'one': 'two'}, 'three']"],
                       result, @"Single-level wild card in array of hashes");
  [result release];
  [query release];
}

@end

//
//  ZNObjectQuery.m
//  ZergSupport
//
//  Created by Victor Costan on 5/2/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ZNObjectQuery.h"

#import "ZNDictionaryJsonParser.h"


@interface ZNObjectQuery ()

// Non-public API, to make testing easier.
+(NSMutableArray*)splitQueryString:(NSString*)queryString;

@end


@interface ZNObjectQueryTest : SenTestCase {
  NSObject* simpleHash;
  NSObject* simpleArray;
}

@end


@implementation ZNObjectQueryTest

-(void)setUp {
  simpleHash = [ZNDictionaryJsonParser parseValue:
                @"{'a': {'b': ['c', 'd'], 'e': {'f': 'g'}}}"];
  simpleArray =
      [ZNDictionaryJsonParser parseValue:
       @"[['a', 'b'], ['c', 'd'], [['e', 'f'], ['g', 'h', 'i', 'j']]]"];
}
-(void)tearDown {
  [simpleHash release];
  [simpleArray release];
}

-(void)testQuerySplitting {
  NSString* simple = @"/one/two/3";
  NSArray* goldenSimple = [NSArray arrayWithObjects:@"one", @"two", @"3", nil];
  STAssertEqualObjects(goldenSimple,
                       [ZNObjectQuery splitQueryString:simple],
                       @"Simple query");

  NSString* wildcards = @"|*|two|?|3";
  NSArray* goldenWildcards = [NSArray arrayWithObjects:
                              [NSNumber numberWithBool:YES], @"two",
                              [NSNumber numberWithBool:NO], @"3", nil];
  STAssertEqualObjects(goldenWildcards,
                       [ZNObjectQuery splitQueryString:wildcards],
                       @"Wildcard query");
}

-(void)testHashIndexing {
  ZNObjectQuery* query = [ZNObjectQuery compile:@"/a/b"];
  NSArray* result = [query run:simpleHash];
  STAssertEqualObjects([ZNDictionaryJsonParser parseValue:@"[['c', 'd']]"],
                       result, @"Hash indexing");
  [result release];
  [query release];
}

-(void)testArrayIndexing {
  ZNObjectQuery* query = [ZNObjectQuery compile:@"/2/1/0"];
  NSArray* result = [query run:simpleArray];
  STAssertEqualObjects([NSArray arrayWithObject:@"g"],
                       result, @"Array indexing");
  [result release];
  [query release];
}

-(void)testSimpleIndexing {
  ZNObjectQuery* query = [ZNObjectQuery compile:@"/a/b/1"];
  NSArray* result = [query run:simpleHash];
  STAssertEqualObjects([NSArray arrayWithObject:@"d"],
                       result, @"Hash+array indexing");
  [result release];
  [query release];
}

-(void)testSingleLevelInArraysImmediate {
  ZNObjectQuery* query = [ZNObjectQuery compile:@"/?/1"];
  NSArray* result = [query run:simpleArray];
  STAssertEqualObjects([ZNDictionaryJsonParser parseValue:@"[['c', 'd']]"],
                       result, @"Single-level wild card in arrays");
  [result release];
  [query release];
}

-(void)testSingleLevelInArraysNonImmediate {
  NSObject* object = [ZNDictionaryJsonParser parseValue:
                      @"[['a', 'b', 'c'], ['d', 'e', 'f']]"];
  ZNObjectQuery* query = [ZNObjectQuery compile:@"/?/2"];
  NSArray* result = [query run:object];
  NSArray* goldenResult = [NSArray arrayWithObjects:@"c", @"f", nil];
  STAssertEqualObjects(goldenResult,
                       result, @"Single-level wild card in arrays");
  [result release];
  [query release];
  [object release];
}

-(void)testSingleLevelInArraysFail {
  ZNObjectQuery* query = [ZNObjectQuery compile:@"/?/3"];
  NSArray* result = [query run:simpleHash];
  STAssertEqualObjects([NSArray array],
                       result, @"Single-level wild card in arrays");
  [result release];
  [query release];
}

-(void)testSingleLevelInArraysTerminal {
  ZNObjectQuery* query = [ZNObjectQuery compile:@"/2/?"];
  NSArray* result = [query run:simpleArray];
  STAssertEqualObjects([ZNDictionaryJsonParser parseValue:
                        @"[['e', 'f'], ['g', 'h', 'i', 'j']]"],
                       result, @"Single-level wild card in arrays");
  [result release];
  [query release];

}

-(void)testSingleLevelInHashesImmediate {
  ZNObjectQuery* query = [ZNObjectQuery compile:@"/?/a"];
  NSArray* result = [query run:simpleHash];
  STAssertEqualObjects([ZNDictionaryJsonParser parseValue:
                        @"[{'b': ['c', 'd'], 'e': {'f': 'g'}}]"],
                       result, @"Single-level wild card in hashes");
  [result release];
  [query release];
}

-(void)testSingleLevelInHashesNonImmediate {
  ZNObjectQuery* query = [ZNObjectQuery compile:@"/?/e"];
  NSArray* result = [query run:simpleHash];
  STAssertEqualObjects([ZNDictionaryJsonParser parseValue:@"[{'f': 'g'}]"],
                       result, @"Single-level wild card in hashes");
  [result release];
  [query release];
}

-(void)testSingleLevelInHashesFail {
  ZNObjectQuery* query = [ZNObjectQuery compile:@"/?/f"];
  NSArray* result = [query run:simpleHash];
  STAssertEqualObjects([NSArray array],
                       result, @"Single-level wild card in hashes");
  [result release];
  [query release];
}

-(void)testMultiLevelInArrays {
  ZNObjectQuery* query = [ZNObjectQuery compile:@"/*/3"];
  NSArray* result = [query run:simpleArray];
  STAssertEqualObjects([NSArray arrayWithObject:@"j"],
                       result, @"Multi-level wild card in arrays");
  [result release];
  [query release];
}

-(void)testMultiLevelInHashes {
  ZNObjectQuery* query = [ZNObjectQuery compile:@"/*/f"];
  NSArray* result = [query run:simpleHash];
  STAssertEqualObjects([NSArray arrayWithObject:@"g"],
                       result, @"Multi-level wild card in hashes");
  [result release];
  [query release];
}

@end

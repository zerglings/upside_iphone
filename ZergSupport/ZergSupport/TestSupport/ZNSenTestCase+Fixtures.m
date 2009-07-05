//
//  SenTestCase+Fixtures.m
//  ZergSupport
//
//  Created by Victor Costan on 2/16/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNSenTestCase+Fixtures.h"

#import <objc/runtime.h>

#import "FormatSupport.h"
#import "ModelSupport.h"


@interface ZNFixtureParser : NSObject <ZNModelXmlParserDelegate> {
  ZNModelXmlParser* xmlParser;
}
-(NSArray*)parseData:(NSData*)data;
+(NSDictionary*)newParserSchema;
@end


@implementation ZNFixtureParser
-(id)init {
  if ((self = [super init])) {
    NSDictionary* parserSchema = [ZNFixtureParser newParserSchema];
    xmlParser = [[ZNModelXmlParser alloc] initWithSchema:parserSchema
                                          documentCasing:kZNFormatterSnakeCase];
    xmlParser.delegate = self;
    [parserSchema release];
  }
  return self;
}
-(void)dealloc {
  [xmlParser release];
  [super dealloc];
}

-(NSArray*)parseData:(NSData*)data {
  NSMutableArray* fixtures = [[NSMutableArray alloc] init];
  xmlParser.context = fixtures;
  BOOL parseSuccess = [xmlParser parseData:data];
  NSAssert(parseSuccess, @"Failed to parse fixture");

  NSArray* returnValue = [NSArray arrayWithArray:fixtures];
  [fixtures release];
  return returnValue;
}


+(NSDictionary*)newParserSchema {
  NSArray* modelClasses = [ZNModel allModelClasses];

  NSMutableDictionary* schema = [[NSMutableDictionary alloc] init];
  for (Class klass in modelClasses) {
    const char* classNameCString = class_getName(klass);
    NSString* className =
        [[NSString alloc] initWithBytes:classNameCString
                                 length:strlen(classNameCString)
                               encoding:NSASCIIStringEncoding];
    [schema setObject:klass forKey:className];
    [className release];
  }
  return schema;
}

-(void)parsedModel:(ZNModel*)model
           context:(id)context {
  [(NSMutableArray*)context addObject:model];
}
-(void)parsedItem:(NSDictionary*)itemData
             name:(NSString*)itemName
          context:(id)context {
  NSAssert(NO, @"-parsedItem called while parsing fixtures");
}
@end


@implementation SenTestCase (Fixtures)

-(NSBundle*)testBundle {
  return [NSBundle bundleForClass:[self class]];
}

-(NSArray*)fixturesFrom:(NSString*)fileName {
  NSString* fixturePath = [[[self testBundle] resourcePath]
                        stringByAppendingPathComponent:fileName];
  NSData* fixtureData = [NSData dataWithContentsOfFile:fixturePath];
  ZNFixtureParser* parser = [[ZNFixtureParser alloc] init];
  NSArray* fixtures = [parser parseData:fixtureData];
  [parser release];
  return fixtures;
}
@end

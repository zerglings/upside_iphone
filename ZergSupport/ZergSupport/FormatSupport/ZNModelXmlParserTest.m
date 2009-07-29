//
//  ZNModelXmlParserTest.m
//  ZergSupport
//
//  Created by Victor Costan on 2/16/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ModelSupport.h"
#import "ZNModelXmlParser.h"

// Model for the XML test file.
@interface ZNXmlParserTestModel : ZNModel {
  ZNXmlParserTestModel* subModel;
  NSString* theName;
  double number;
  BOOL boolean;
}
@property (nonatomic, retain) ZNXmlParserTestModel* subModel;
@property (nonatomic, retain) NSString* theName;
@property (nonatomic) double number;
@property (nonatomic) BOOL boolean;

@end

@implementation ZNXmlParserTestModel

@synthesize theName, number, boolean, subModel;
-(void)dealloc {
  [subModel release];
  [theName release];
  [super dealloc];
}

@end

@interface ZNModelXmlParserTest
: SenTestCase <ZNModelXmlParserDelegate> {
  ZNModelXmlParser* parser;

  NSMutableArray* items;
  NSMutableArray* dupItems;
  NSMutableArray* names;
  NSMutableArray* dupNames;
}

@end

static NSString* kContextObject = @"This is the context";

@implementation ZNModelXmlParserTest

-(void)setUp {
  NSDictionary* schema = [NSDictionary dictionaryWithObjectsAndKeys:
                          [ZNXmlParserTestModel class],
                          @"ZNXmlParserTestModel",
                          [NSNull class], @"itemA",
                          [NSArray arrayWithObjects:
                           [ZNXmlParserTestModel class],
                           [NSSet setWithObjects:@"theName", @"number",
                            @"boolean", nil],
                           nil],
                          @"ZNXmlParserTestModelSchema",
                          nil];

  parser = [[ZNModelXmlParser alloc] initWithSchema:schema
                                     documentCasing:kZNFormatterSnakeCase];
  parser.context = kContextObject;
  parser.delegate = self;

  items = [[NSMutableArray alloc] init];
  dupItems = [[NSMutableArray alloc] init];
  names = [[NSMutableArray alloc] init];
  dupNames = [[NSMutableArray alloc] init];

}

-(void)tearDown {
  [parser release];
  [items release];
  [dupItems release];
  [names release];
  [dupNames release];
}

-(void)dealloc {
  [super dealloc];
}

-(void)checkItems {
  STAssertEqualObjects(names, dupNames, @"Item names changed during parsing");
  STAssertEqualObjects(items, dupItems, @"Item data changed during parsing");

  NSArray* goldenNames = [NSArray arrayWithObjects:@"itemA", nil];
  STAssertEqualObjects(goldenNames, names,
                       @"Failed to parse the right items");

  ZNXmlParserTestModel* outerModel = [items objectAtIndex:0];
  STAssertTrue([outerModel isKindOfClass:[ZNXmlParserTestModel class]],
               @"Wrong model class instantiated for the outer model");
  STAssertEqualStrings(@"First name", outerModel.theName,
                       @"Wrong value for the outer model's string property");
  STAssertEqualsWithAccuracy(3.141592, outerModel.number, 0.0000001,
                             @"Wrong value for outer model's float property");
  STAssertEquals(YES, outerModel.boolean,
                 @"Wrong value for the outer model's boolean property");

  ZNXmlParserTestModel* innerModel = outerModel.subModel;
  STAssertTrue([innerModel isKindOfClass:[ZNXmlParserTestModel class]],
               @"Wrong model class instantiated for the inner item / model");
  STAssertEqualStrings(@"Second name", innerModel.theName,
                       @"Wrong value for the inner model's string property");
  STAssertEqualsWithAccuracy(64.0, innerModel.number, 0.0000001,
                             @"Wrong value for inner model's float property");
  STAssertEquals(NO, innerModel.boolean,
                 @"Wrong value for the inner model's boolean property");
  STAssertNil(innerModel.subModel,
              @"Wrong value for the inner model's submodel");

  NSDictionary* goldenSecond = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"A prime", @"keyA", @"B prime", @"keyB", nil];
  STAssertEqualObjects(goldenSecond, [items objectAtIndex:1],
                       @"Failed to parse item with no model");

  ZNXmlParserTestModel* schemaModel = [items objectAtIndex:2];
  STAssertTrue([outerModel isKindOfClass:[ZNXmlParserTestModel class]],
               @"Wrong model class instantiated for the model with schema");
  STAssertEqualStrings(@"Third name", schemaModel.theName,
                       @"Wrong value for the schema model's string property");
  STAssertEqualsWithAccuracy(42.0, schemaModel.number, 0.0000001,
                             @"Wrong value for schema model's float property");
  STAssertEquals(YES, schemaModel.boolean,
                 @"Wrong value for the schema model's boolean property");
  STAssertNil(schemaModel.subModel,
              @"The sub-model of the schema model should be suppressed");
}

-(void)testParsingURLs {
  NSString *filePath = [[[self testBundle] resourcePath]
                        stringByAppendingPathComponent:
                        @"ZNModelXmlParserTest.xml"];
  BOOL success = [parser parseURL:[NSURL fileURLWithPath:filePath]];
  STAssertTrue(success, @"Parsing failed on ZNModelXmlParserTest.xml");

  [self checkItems];
}

-(void)testParsingData {
  NSString *filePath = [[[self testBundle] resourcePath]
                        stringByAppendingPathComponent:
                        @"ZNModelXmlParserTest.xml"];
  BOOL success = [parser parseData:[NSData dataWithContentsOfFile:filePath]];
  STAssertTrue(success, @"Parsing failed on ZNModelXmlParserTest.xml");

  [self checkItems];
}

-(void)parsedItem:(NSDictionary*)itemData
             name:(NSString*)itemName
          context:(id)context {
  STAssertEquals(kContextObject, context,
                 @"Wrong context passed to -parsedItem");

  [names addObject:itemName];
  [dupNames addObject:[NSString stringWithString:itemName]];

  [items addObject:itemData];
  [dupItems addObject:[NSDictionary dictionaryWithDictionary:itemData]];
}

-(void)parsedModel:(ZNModel*)model
           context:(id)context {
  STAssertEquals(kContextObject, context,
                 @"Wrong context passed to -parsedModel");

  [items addObject:model];
  [dupItems addObject:model];
}

@end


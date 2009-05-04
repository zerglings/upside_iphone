//
//  ZNModelJsonParserTest.m
//  ZergSupport
//
//  Created by Victor Costan on 5/3/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ZNModelJsonParser.h"

#import "ModelSupport.h"

// Model for the JSON test file.
@interface ZNJsonParserTestModel : ZNModel {
  NSString* theName;
  double number;
  BOOL boolean;
}
@property (nonatomic, retain) NSString* theName;
@property (nonatomic) double number;
@property (nonatomic) BOOL boolean;
@end

@implementation ZNJsonParserTestModel

@synthesize theName, number, boolean;

-(void)dealloc {
  [theName release];
  [super dealloc];
}
@end


@interface ZNModelJsonParserTest : SenTestCase <ZNModelJsonParserDelegate> {
  ZNModelJsonParser* parser;

  NSMutableArray* items;
  NSMutableArray* dupItems;
}
@end

static NSString* kContextObject = @"This is the context";

@implementation ZNModelJsonParserTest

-(void)setUp {
  NSArray* queries = [NSArray arrayWithObjects:
                      [ZNJsonParserTestModel class], @"/models/?",
                      [NSNull class], @"/raw", nil];

  parser = [[ZNModelJsonParser alloc] initWithQueries:queries
                                       documentCasing:kZNFormatterSnakeCase];
  parser.context = kContextObject;
  parser.delegate = self;

  items = [[NSMutableArray alloc] init];
  dupItems = [[NSMutableArray alloc] init];
}

-(void)tearDown {
  [parser release];
  [items release];
  [dupItems release];
}

-(void)dealloc {
  [super dealloc];
}

-(void)checkParseResults {
  STAssertEqualObjects(items, dupItems, @"Object data changed during parsing");

  ZNJsonParserTestModel* firstModel = [items objectAtIndex:0];
  STAssertTrue([firstModel isKindOfClass:[ZNJsonParserTestModel class]],
               @"Wrong model class instantiated for first model");
  STAssertEqualStrings(@"First name", firstModel.theName,
                       @"Wrong value for first model's string property");
  STAssertEqualsWithAccuracy(3.141592, firstModel.number, 0.0000001,
                             @"Wrong value for first model's float property");
  STAssertEquals(YES, firstModel.boolean,
                 @"Wrong value for first model's boolean property");

  ZNJsonParserTestModel* secondModel = [items objectAtIndex:1];
  STAssertTrue([secondModel isKindOfClass:[ZNJsonParserTestModel class]],
               @"Wrong model class instantiated for second model");
  STAssertEqualStrings(@"Second name", secondModel.theName,
                       @"Wrong value for second model's string property");
  STAssertEqualsWithAccuracy(64.0, secondModel.number, 0.0000001,
                             @"Wrong value for second model's float property");
  STAssertEquals(NO, secondModel.boolean,
                 @"Wrong value for second model's boolean property");

  NSDictionary* goldenRaw = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithInt:1], @"one",
                             @"My Name", @"name", nil];
  STAssertEqualObjects(goldenRaw, [items objectAtIndex:2],
                       @"Failed to parse object with no model");
}


-(void)testParsingData {
  NSString *filePath = [[[NSBundle mainBundle] resourcePath]
                        stringByAppendingPathComponent:
                        @"ZNModelJsonParserTest.json"];
  BOOL success = [parser parseData:[NSData dataWithContentsOfFile:filePath]];
  STAssertTrue(success, @"Parsing failed on ZNModelJsonParserTest.json");

  [self checkParseResults];
}

-(void)parsedObject:(NSObject*)object
            context:(id)context {
  STAssertEquals(kContextObject, context,
                 @"Wrong context passed to -parsedObject");

  [items addObject:object];
  [dupItems addObject:[NSDictionary
                       dictionaryWithDictionary:(NSDictionary*)object]];
}

-(void)parsedModel:(ZNModel*)model
           context:(id)context {
  STAssertEquals(kContextObject, context,
                 @"Wrong context passed to -parsedModel");

  [items addObject:model];
  [dupItems addObject:model];
}
@end

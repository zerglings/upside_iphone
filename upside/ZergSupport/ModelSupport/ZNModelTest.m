//
//  ZNModelTest.m
//  ZergSupport
//
//  Created by Victor Costan on 1/15/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"
#import "ZNTestModels.h"

#import "ZNModelDefinitionAttribute.h"
#import "ZNModelDefinition.h"


@interface ZNModelTest : SenTestCase {
  ZNTestDate* dateModel;
  ZNTestSubmodel* subModel;
  NSDate* date;
  NSString* dateString;
  ZNTestNumbers* numbersModel;
  NSNumber* trueObject;
  NSNumber* falseObject;
  NSNumber* doubleObject;
  NSNumber* integerObject;
  NSNumber* uintegerObject;
  NSString* testString;
  NSData* testData;
  NSString* testDataString;
  double testDouble;
  NSInteger testInteger;
  NSUInteger testUInteger;
}
@end


@implementation ZNModelTest

-(void)setUp {
  date = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
  dateModel = [[ZNTestDate alloc] initWithProperties: nil];
  dateModel.pubDate = date;
  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];  
  dateString = [[formatter stringFromDate:date] retain];
  [formatter release];
  
  subModel = [[ZNTestSubmodel alloc] initWithProperties:nil];
  subModel.dateModel = dateModel;

  testDouble = 3.141592;
  testInteger = -3141592;
  testUInteger = 0x87654321;
  testString = @"Awesome \0 test String";
  uint8_t dataBytes[] = {0x03, 0x07, 0x00, 0xFC, 0x85, 0xEC, 0xDD};
  testData = [[NSData alloc] initWithBytes:dataBytes length:sizeof(dataBytes)];
  testDataString = [[NSString alloc] initWithBytes:dataBytes
                                            length:sizeof(dataBytes)
                                          encoding:NSASCIIStringEncoding];
  numbersModel = [[ZNTestNumbers alloc] initWithProperties:nil];
  numbersModel.trueVal = YES;
  numbersModel.falseVal = NO;
  numbersModel.doubleVal = testDouble;
  numbersModel.integerVal = testInteger;
  numbersModel.stringVal = testString;
  numbersModel.dataVal = testData;
  numbersModel.uintegerVal = testUInteger;
  trueObject = [[NSNumber alloc] initWithBool:YES];
  falseObject = [[NSNumber alloc] initWithBool:NO];
  doubleObject = [[NSNumber alloc] initWithDouble:testDouble];
  integerObject = [[NSNumber alloc] initWithInteger:testInteger];
  uintegerObject = [[NSNumber alloc] initWithUnsignedInteger:testUInteger];
}

-(void)tearDown {
  [date release];
  [dateString release];
  [dateModel release];
  [testData release];
  [testDataString release];
  [numbersModel release];
  [trueObject release];
  [falseObject release];
  [doubleObject release];
  [integerObject release];
  [uintegerObject release];
}

-(void)dealloc {
  [super dealloc];
}

-(void)testPrimitiveBoxing {
  NSDictionary* numbersDict = [numbersModel
                               copyToDictionaryForcingStrings:NO];
  STAssertEqualObjects(trueObject, [numbersDict objectForKey:@"trueVal"],
                       @"Boxed YES should reflect the original value");
  STAssertEqualObjects(falseObject, [numbersDict objectForKey:@"falseVal"],
                       @"Boxed NO should reflect the original value");
  STAssertEqualObjects(doubleObject, [numbersDict objectForKey:@"doubleVal"],
                       @"Boxed double should reflect the original value");
  STAssertEqualObjects(integerObject, [numbersDict
                                       objectForKey:@"integerVal"],
                       @"Boxed integer should reflect the original value");
  STAssertEqualObjects(uintegerObject, [numbersDict
                                        objectForKey:@"uintegerVal"],
                       @"Boxed uinteger should reflect the original value");
  STAssertEqualStrings(testString, [numbersDict objectForKey:@"stringVal"],
                       @"Boxed string should equal the original value");
  STAssertEqualObjects(testData, [numbersDict objectForKey:@"dataVal"],
                       @"Boxed NSData should equal the original value");
  ZNTestNumbers* thawedModel = [[ZNTestNumbers alloc]
                                initWithProperties:numbersDict];
  STAssertEquals(YES, thawedModel.trueVal,
                 @"Unboxed YES should equal original");
  STAssertEquals(NO, thawedModel.falseVal,
                 @"Unboxed NO should equal original");
  STAssertEquals(testDouble, thawedModel.doubleVal,
                 @"Unboxed double should equal original");
  STAssertEquals(testInteger, thawedModel.integerVal,
                 @"Unboxed integer should equal original");
  STAssertEquals(testUInteger, thawedModel.uintegerVal,
                 @"Unboxed uinteger should equal original");
  STAssertEqualStrings(testString, thawedModel.stringVal,
                       @"Unboxed string should equal original");
  STAssertEqualObjects(testData, thawedModel.dataVal,
                       @"Unboxed NSData should equal original");
  [numbersDict release];
  [thawedModel release];

  numbersDict = [numbersModel copyToDictionaryForcingStrings:YES];
  STAssertEqualStrings(@"true", [numbersDict objectForKey:@"trueVal"],
                       @"String-boxed YES should reflect original");
  STAssertEqualStrings(@"false", [numbersDict objectForKey:@"falseVal"],
                       @"String-boxed NO should reflect original");
  STAssertEqualStrings(@"3.141592", [numbersDict objectForKey:@"doubleVal"],
                       @"String-boxed double should reflect original");
  STAssertEqualStrings(@"-3141592", [numbersDict objectForKey:@"integerVal"],
                       @"String-boxed integer should reflect original");
  STAssertEqualStrings(@"2271560481", [numbersDict
                                       objectForKey:@"uintegerVal"],
                       @"String-boxed uinteger should reflect original");
  STAssertEqualStrings(testString, [numbersDict objectForKey:@"stringVal"],
                       @"String-boxed string should equal original");
  STAssertEqualStrings(testDataString, [numbersDict objectForKey:@"dataVal"],
                       @"String-boxed NSData should reflect original");
  thawedModel = [[ZNTestNumbers alloc] initWithProperties:numbersDict];
  STAssertEquals(YES, thawedModel.trueVal,
                 @"String-unboxed YES should equal original");
  STAssertEquals(NO, thawedModel.falseVal,
                 @"String-unboxed NO should equal original");
  STAssertEquals(testDouble, thawedModel.doubleVal,
                 @"String-unboxed double should equal original");
  STAssertEquals(testInteger, thawedModel.integerVal,
                 @"String-unboxed integer should equal original");
  STAssertEquals(testUInteger, thawedModel.uintegerVal,
                 @"String-unboxed uinteger should equal original");
  STAssertEqualStrings(testString, thawedModel.stringVal,
                       @"String-unboxed string should equal original");
  STAssertEqualObjects(testData, thawedModel.dataVal,
                       @"String-unboxed NSData should equal original");
  [numbersDict release];
  [thawedModel release];
}

-(void)testDateBoxing {
  NSDictionary* dateDict = [dateModel copyToDictionaryForcingStrings:NO];
  STAssertEqualObjects(date, [dateDict objectForKey:@"pubDate"],
                       @"Boxed date should equal original date");
  ZNTestDate* thawedModel = [[ZNTestDate alloc] initWithProperties:dateDict];
  STAssertEqualObjects(date, thawedModel.pubDate,
                       @"Unboxed date should equal original date");
  [dateDict release];
  [thawedModel release];

  dateDict = [dateModel copyToDictionaryForcingStrings:YES];
  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
  NSDate* date2 = [formatter dateFromString:[dateDict objectForKey:@"pubDate"]];
  [formatter release];
  STAssertEqualsWithAccuracy(0.0, [date2 timeIntervalSinceDate:date], 1.0,
                             @"String-boxed date should equal original date");
  thawedModel = [[ZNTestDate alloc] initWithProperties:dateDict];
  STAssertEqualsWithAccuracy(0.0, [thawedModel.pubDate
                                   timeIntervalSinceDate:date],
                             1.0,
                             @"String-unboxed date should equal original");
  [dateDict release];
  [thawedModel release];
}

-(void)testModelBoxing {
  NSDictionary* nestedDict = [subModel copyToDictionaryForcingStrings:NO];
  STAssertEqualObjects(date, [[nestedDict objectForKey:@"dateModel"]
                              objectForKey:@"pubDate"],
                       @"Boxed date should equal original date");
  ZNTestSubmodel* thawedModel = [[ZNTestSubmodel alloc]
                                 initWithProperties:nestedDict];
  STAssertTrue([thawedModel.dateModel isKindOfClass:[ZNTestDate class]],
               @"Unboxed model has the wrong class");
  STAssertEqualObjects(date, thawedModel.dateModel.pubDate,
                       @"Unboxed date should equal original date");
  [nestedDict release];
  [thawedModel release];

  nestedDict = [subModel copyToDictionaryForcingStrings:YES];
  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
  NSDate* date2 = [formatter dateFromString:[[nestedDict
                                              objectForKey:@"dateModel"]
                                             objectForKey:@"pubDate"]];
  [formatter release];
  STAssertEqualsWithAccuracy(0.0, [date2 timeIntervalSinceDate:date], 1.0,
                             @"String-boxed date should equal original date");
  thawedModel = [[ZNTestSubmodel alloc] initWithProperties:nestedDict];
  STAssertTrue([thawedModel.dateModel isKindOfClass:[ZNTestDate class]],
               @"String-unboxed model has the wrong class");
  STAssertEqualsWithAccuracy(0.0, [thawedModel.dateModel.pubDate
                                   timeIntervalSinceDate:date],
                             1.0,
                             @"String-unboxed date should equal original");
  [nestedDict release];
  [thawedModel release];

}

-(void)testNullPrimitiveBoxing {
  ZNTestNumbers* nullCarrier = [[[ZNTestNumbers alloc] init] autorelease];
  nullCarrier.stringVal = nil;
  nullCarrier.dataVal = nil;

  NSDictionary* dict = [nullCarrier copyToDictionaryForcingStrings:NO];
  STAssertNil([dict objectForKey:@"stringVal"],
              @"Nil strings should be ignored while boxing");
  STAssertNil([dict objectForKey:@"dataVal"],
              @"Nil NSDatas should be ignored while boxing");
  ZNTestNumbers* thawedNulls = [[ZNTestNumbers alloc] initWithProperties:dict];
  STAssertNil(thawedNulls.stringVal,
              @"Nil strings should be unboxed to nil strings");
  STAssertNil(thawedNulls.dataVal,
              @"Nil NSDatas should be unboxed to nil NSDatas");
  [dict release];
  [thawedNulls release];

  dict = [nullCarrier copyToDictionaryForcingStrings:YES];
  STAssertNil([dict objectForKey:@"stringVal"],
              @"Nil strings should be ignored while string-boxing");
  STAssertNil([dict objectForKey:@"dataVal"],
              @"Nil NSDatas should be ignored while string-boxing");
  thawedNulls = [[ZNTestNumbers alloc] initWithProperties:dict];
  STAssertNil(thawedNulls.stringVal,
              @"Nil strings should be string-unboxed to nil strings");
  STAssertNil(thawedNulls.dataVal,
              @"Nil NSDatas should be string-unboxed to nil NSDatas");
  [dict release];
  [thawedNulls release];

  dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNull null], @"dataVal",
          [NSNull null], @"stringVal", nil];
  thawedNulls = [[ZNTestNumbers alloc] initWithProperties:dict];
  STAssertNil(thawedNulls.stringVal,
              @"NSNull instances should be string-unboxed to nil strings");
  STAssertNil(thawedNulls.dataVal,
              @"NSNull instances should be string-unboxed to nil NSDatas");
  [thawedNulls release];
}

-(void)testNullModelBoxing {
  ZNTestSubmodel* nullCarrier = [[[ZNTestSubmodel alloc] init] autorelease];
  nullCarrier.dateModel = nil;

  NSDictionary* dict = [nullCarrier copyToDictionaryForcingStrings:NO];
  STAssertNil([dict objectForKey:@"dateModel"],
              @"Nil models should be ignored while boxing");
  ZNTestSubmodel* thawedNulls = [[ZNTestSubmodel alloc] initWithProperties:dict];
  STAssertNil(thawedNulls.dateModel,
              @"Nil models should be unboxed to nil models");
  [dict release];
  [thawedNulls release];

  dict = [nullCarrier copyToDictionaryForcingStrings:YES];
  STAssertNil([dict objectForKey:@"dateModel"],
              @"Nil models should be ignored while string-boxing");
  thawedNulls = [[ZNTestSubmodel alloc] initWithProperties:dict];
  STAssertNil(thawedNulls.dateModel,
              @"Nil models should be string-unboxed to nil models");
  [dict release];
  [thawedNulls release];

  dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNull null], @"dateModel",
          nil];
  thawedNulls = [[ZNTestSubmodel alloc] initWithProperties:dict];
  STAssertNil(thawedNulls.dateModel,
              @"NSNull instances should be string-unboxed to nil models");
  [thawedNulls release];
}

-(void)testExtendedAttributesStringBoxing {
  NSDictionary* dict =
      [NSDictionary dictionaryWithObjectsAndKeys:
       doubleObject, @"doubleVal", integerObject, @"integerVal",
       uintegerObject, @"uintegerVal", testString, @"stringVal",
       testData, @"dataVal", date, @"dateVal",
       subModel, @"model", [NSNull null], @"nullVal", nil];
  
  NSDictionary* goldenStringDict = 
      [NSDictionary dictionaryWithObjectsAndKeys:
       [NSString stringWithFormat:@"%lf", testDouble], @"doubleVal",
       [NSString stringWithFormat:@"%d", testInteger], @"integerVal",
       [NSString stringWithFormat:@"%u", testUInteger], @"uintegerVal",
       testString, @"stringVal", testDataString, @"dataVal",
       dateString, @"dateVal", 
       [NSDictionary dictionaryWithObjectsAndKeys:
        [NSDictionary dictionaryWithObjectsAndKeys:
         dateString, @"pubDate", nil],
        @"dateModel", nil],
       @"model", nil];
  
  ZNTestDate* model = [[ZNTestDate alloc] initWithProperties:dict];
  NSDictionary* stringDict = [model copyToDictionaryForcingStrings:YES];
  STAssertEqualObjects(goldenStringDict, stringDict,
                       @"Incorrect string-boxing from extended attributes");
  
  [stringDict release];
  [model release];
}

-(void)testIsModelClass {
  STAssertTrue([ZNModel isModelClass:[ZNTestDate class]],
               @"ZNTestDate is a model class");
  STAssertTrue([ZNModel isModelClass:[ZNTestNumbers class]],
               @"ZNTestNumbers is a model class");

  STAssertFalse([ZNModel isModelClass:[NSObject class]],
                @"NSObject is not a model class");

  STAssertFalse([ZNModel isModelClass:date],
                @"A date is not a model class");
  STAssertFalse([ZNModel isModelClass:dateModel],
                @"A model instance is not a model class");
}

-(void)testAllModelClasses {
  NSArray* allModelClasses = [ZNModel allModelClasses];
  STAssertTrue([allModelClasses containsObject:[ZNTestDate class]],
               @"ZNTestDate is a model class");
  STAssertTrue([allModelClasses containsObject:[ZNTestNumbers class]],
               @"ZNTestNumbers is a model class");
  STAssertFalse([allModelClasses containsObject:[NSObject class]],
                @"NSObject is not a model class");
}

-(void)testExtendedAttributes {
  ZNModel* testModel = [[ZNTestNumbers alloc] initWithProperties:
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         testString, @"undefined property", nil]];
  NSDictionary* dict = [testModel copyToDictionaryForcingStrings:NO];
  STAssertEqualStrings(testString, [dict objectForKey:@"undefined property"],
                       @"Extended property in serialized model");
  [dict release];

  dict = [testModel copyToDictionaryForcingStrings:YES];
  STAssertEqualStrings(testString, [dict objectForKey:@"undefined property"],
                       @"Extended property in string-serialized model");
  [dict release];

  [testModel release];
}

-(void)testJsonInitialization {
  NSString* jsonString =
      @"{'trueVal': true, 'falseVal': false, 'doubleVal': 3.141592,"
      @"'integerVal': -3141592, 'uintegerVal': 2271560481, "
      @"'stringVal': 'Awesome \\u0000 test String',"
      @"'dataVal': '\\u0003\\u0007\\u0000\\u00fc\\u0085\\u00ec\\u00dd'}";
  ZNModel* testModel = [[ZNTestNumbers alloc] initWithJson:jsonString];

  STAssertEqualStrings([numbersModel description], [testModel description],
                       @"JSON initialization failed");
  [testModel release];
}

@end

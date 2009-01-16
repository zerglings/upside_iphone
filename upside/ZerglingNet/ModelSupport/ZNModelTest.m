//
//  ZNModelTest.m
//  upside
//
//  Created by Victor Costan on 1/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GTMSenTestCase.h"
#import "ZNTestModels.h"

#import "ZNModelDefinitionAttribute.h"
#import "ZNModelDefinition.h"

@interface ZNModelTest : SenTestCase {
	ZNTestDate* dateModel;
	NSDate* date;
	ZNTestNumbers* numbersModel;
	NSNumber* doubleObject;
	NSNumber* integerObject;
	NSNumber* uintegerObject;
	double testDouble;
	NSInteger testInteger;
	NSUInteger testUInteger;
}
@end

@implementation ZNModelTest

- (void) setUp {
	date = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
	dateModel = [[ZNTestDate alloc] initWithProperties: nil];
	dateModel.pubDate = date;
	
	testDouble = 3.141592;
	testInteger = -3141592;
	testUInteger = 0x87654321;
	numbersModel = [[ZNTestNumbers alloc] initWithProperties:nil];
	numbersModel.doubleVal = testDouble;
	numbersModel.integerVal = testInteger;
	numbersModel.uintegerVal = testUInteger;
	doubleObject = [[NSNumber alloc] initWithDouble:testDouble];
	integerObject = [[NSNumber alloc] initWithInteger:testInteger];
	uintegerObject = [[NSNumber alloc] initWithUnsignedInteger:testUInteger];
}

- (void) tearDown {
	[dateModel release];
	[date release];
	[numbersModel release];
	[doubleObject release];
	[integerObject release];
	[uintegerObject release];
}

- (void) testDateBoxing {
	NSDictionary* dateDict = [dateModel copyToDictionaryForcingStrings:NO];
	STAssertEqualObjects(date, [dateDict objectForKey:@"pubDate"],
						 @"Boxed date should equal original date");
	ZNTestDate* thawedModel = [[ZNTestDate alloc] initWithProperties:dateDict];
	STAssertEqualObjects(date, thawedModel.pubDate,
						 @"Unboxed date should equal original date");
	[dateDict release];
	[thawedModel release];
	
	dateDict = [dateModel copyToDictionaryForcingStrings:YES];
	NSDate* date2 = [NSDate dateWithString:
					 [dateDict objectForKey:@"pubDate"]];
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

- (void) testNumberBoxing {
	NSDictionary* numbersDict = [numbersModel
								 copyToDictionaryForcingStrings:NO];
	STAssertEqualObjects(doubleObject, [numbersDict objectForKey:@"doubleVal"],
						 @"Boxed double should reflect the original value");
	STAssertEqualObjects(integerObject, [numbersDict
										 objectForKey:@"integerVal"],
						 @"Boxed integer should reflect the original value");
	STAssertEqualObjects(uintegerObject, [numbersDict
										  objectForKey:@"uintegerVal"],
						 @"Boxed uinteger should reflect the original value");
	ZNTestNumbers* thawedModel = [[ZNTestNumbers alloc]
								  initWithProperties:numbersDict];
	STAssertEquals(testDouble, thawedModel.doubleVal,
				   @"Unboxed double should equal original");
	STAssertEquals(testInteger, thawedModel.integerVal,
				   @"Unboxed integer should equal original");
	STAssertEquals(testUInteger, thawedModel.uintegerVal,
				   @"Unboxed uinteger should equal original");
	[numbersDict release];
	[thawedModel release];
	
	numbersDict = [numbersModel copyToDictionaryForcingStrings:YES];
	STAssertEqualStrings(@"3.141592", [numbersDict objectForKey:@"doubleVal"],
						 @"String-boxed double should reflect original");
	STAssertEqualStrings(@"-3141592", [numbersDict objectForKey:@"integerVal"],
						 @"String-boxed integer should reflect original");
	STAssertEqualStrings(@"2271560481", [numbersDict
										 objectForKey:@"uintegerVal"],
						 @"String-boxed uinteger should reflect original");
	thawedModel = [[ZNTestNumbers alloc] initWithProperties:numbersDict];
	STAssertEquals(testDouble, thawedModel.doubleVal,
				   @"String-unboxed double should equal original");
	STAssertEquals(testInteger, thawedModel.integerVal,
				   @"String-unboxed integer should equal original");
	STAssertEquals(testUInteger, thawedModel.uintegerVal,
				   @"String-unboxed uinteger should equal original");
	[numbersDict release];
	[thawedModel release];
}

@end
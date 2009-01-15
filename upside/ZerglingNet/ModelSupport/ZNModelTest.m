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
}
@end

@implementation ZNModelTest

- (void) setUp {
	date = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
	dateModel = [[ZNTestDate alloc] initWithProperties: nil];
	dateModel.pubDate = date;
}

- (void) tearDown {
	[dateModel release];
	[date release];
}

- (void) testDateBoxing {
	NSDictionary* dateDict = [dateModel copyToDictionaryForcingStrings:NO];
	STAssertEqualObjects(date, [dateDict objectForKey:@"pubDate"],
						 @"Boxed date should equal original date");
	[dateDict release];
	
	dateDict = [dateModel copyToDictionaryForcingStrings:YES];
	NSDate* date2 = [NSDate dateWithString:
					 [dateDict objectForKey:@"pubDate"]];
	STAssertEqualsWithAccuracy(0.0, [date2 timeIntervalSinceDate:date], 1.0,
							   @"String-boxed date should equal original date");
	[dateDict release];
}

@end
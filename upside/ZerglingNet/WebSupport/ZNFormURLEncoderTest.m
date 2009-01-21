//
//  ZNFormURLEncoderTest.m
//  upside
//
//  Created by Victor Costan on 1/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TestSupport.h"

#import "ModelSupport.h"
#import "ZNFormURLEncoder.h"

@interface ZNFormURLEncoderTestModel: ZNModel {
	NSString* key11;
	NSUInteger key12;
}

@property (nonatomic, retain) NSString* key11;
@property (nonatomic) NSUInteger key12;
@end

@implementation ZNFormURLEncoderTestModel

@synthesize key11, key12;

- (void) dealloc {
	[key11 release];
	[super dealloc];
}
@end



@interface ZNFormURLEncoderTest : SenTestCase {
	ZNFormURLEncoderTestModel* testModel;
}

@end


@implementation ZNFormURLEncoderTest

- (void) setUp {
	testModel = [[ZNFormURLEncoderTestModel alloc] initWithProperties:nil];
	testModel.key11 = @"val11";
	testModel.key12 = 31415;
}
- (void) dealloc {
	[super dealloc];
}

- (void) testEmptyEncoding {
	NSDictionary* dict = [NSDictionary dictionary];
	NSData* data = [ZNFormURLEncoder createEncodingFor:dict];
	NSString* string = [[NSString alloc] initWithData:data
											 encoding:NSUTF8StringEncoding];
	STAssertEqualStrings(@"",
						 string,
						 @"Empty dictionary");
	[data release];
	[string release];
}

- (void) testEasyOneLevel {
	NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  @"val1", @"key1", @"val2", @"key2", nil];
	NSData* data = [ZNFormURLEncoder createEncodingFor:dict];
	NSString* string = [[NSString alloc] initWithData:data
											 encoding:NSUTF8StringEncoding];
	STAssertEqualStrings(@"key1=val1&key2=val2",
						 string,
						 @"Empty dictionary");
	[data release];
	[string release];	
}

- (void) testEncodedOneLevel {
	NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  @"val\0001", @"key\n1", @"val = 2", @"key&2", nil];
	NSData* data = [ZNFormURLEncoder createEncodingFor:dict];
	NSString* string = [[NSString alloc] initWithData:data
											 encoding:NSUTF8StringEncoding];
	STAssertEqualStrings(@"key%0A1=val%001&key%262=val%20%3D%202",
						 string,
						 @"Escapes in keys and values");
	[data release];
	[string release];
}

- (void) testSubDictionary {
	NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  @"val1", @"key1",
						  [NSDictionary dictionaryWithObjectsAndKeys:
						   @"val21", @"key21", @"val22", @"key22", nil],
						  @"key2", nil];
	NSData* data = [ZNFormURLEncoder createEncodingFor:dict];
	NSString* string = [[NSString alloc] initWithData:data
											 encoding:NSUTF8StringEncoding];
	// This is dependent on how NSStrings hash. Wish it weren't.
	STAssertEqualStrings(@"key1=val1&key2%5Bkey22%5D=val22&key2%5Bkey21%5D=val21",
						 string,
						 @"Empty dictionary");
	[data release];
	[string release];
}

- (void) testModel {
	NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  testModel, @"key1", nil];
	NSData* data = [ZNFormURLEncoder createEncodingFor:dict];
	NSString* string = [[NSString alloc] initWithData:data
											 encoding:NSUTF8StringEncoding];
	// This is dependent on how NSStrings hash. Wish it weren't.
	STAssertEqualStrings(@"key1%5Bkey11%5D=val11&key1%5Bkey12%5D=31415",
						 string,
						 @"Empty dictionary");
	[data release];
	[string release];
}

@end

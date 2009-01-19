//
//  ZNXmlHttpRequestTest.m
//  upside
//
//  Created by Victor Costan on 1/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GTMSenTestCase.h"

#import "ZNXmlHttpRequest.h"

#import "ModelSupport.h"

// Model for the response returned by the testbed.
@interface ZNXmlHttpRequestTestModel : ZNModel
{
	NSString* method;
	NSString* headers;
	NSString* body;
}

@property (nonatomic, retain) NSString* method;
@property (nonatomic, retain) NSString* headers;
@property (nonatomic, retain) NSString* body;

@end

@implementation ZNXmlHttpRequestTestModel

@synthesize method, headers, body;
- (void) dealloc {
	[method release];
	[headers release];
	[body release];
	[super dealloc];
}

@end



@interface ZNXmlHttpRequestTest : SenTestCase {
	NSString* service;
	BOOL receivedResponse;
}

@end

@implementation ZNXmlHttpRequestTest

- (void) setUp {
	service = @"http://zn-testbed.zergling.net/web_support/echo.xml";
	receivedResponse = NO;
}

- (void) tearDown {
	[service release];
	service = nil;
}

- (void) dealloc {
	[service release];
	[super dealloc];
}

- (void) testOnlineRequest {
	ZNXmlHttpRequestTestModel* requestModel = [[[ZNXmlHttpRequestTestModel
												 alloc] init] autorelease];
	requestModel.method = @"Awesome method";
	requestModel.headers = @"Awesome headers";
	requestModel.body = @"Awesome body";
	
	NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  requestModel, @"model",
						  @"someString", @"stringKey",
						  nil];
	[ZNXmlHttpRequest issueRequestToService:service
									   data:dict
							 responseModels:[NSDictionary
											 dictionaryWithObjectsAndKeys:
											 [ZNXmlHttpRequestTestModel class],
											 @"hash", nil]
									 target:self
									 action:@selector(checkOnlineResponse:)];
	
	[[NSRunLoop currentRunLoop] runUntilDate:
	 [NSDate dateWithTimeIntervalSinceNow:1.0]];
	
	STAssertEquals(YES, receivedResponse,
				   @"Response never received");
}

- (void) checkOnlineResponse: (NSArray*)responseArray {
	receivedResponse = YES;
	STAssertFalse([responseArray isKindOfClass:[NSError class]],
				  @"Error occured %@", responseArray);
	
	ZNXmlHttpRequestTestModel* response = [responseArray objectAtIndex:0];
	STAssertTrue([response isKindOfClass:[ZNXmlHttpRequestTestModel class]],
				 @"Response not deserialized using proper model");
	
	STAssertEqualStrings(@"post", response.method,
						 @"Request not issued using POST");
	
	NSString* headersPath = [[[NSBundle mainBundle] resourcePath]
							 stringByAppendingPathComponent:
							 @"ZNXmlHttpRequestTest.hdrs"];
	STAssertEqualStrings([NSString stringWithContentsOfFile:headersPath],
						 response.headers, @"Wrong headers in request");

	NSString* bodyPath = [[[NSBundle mainBundle] resourcePath]
						  stringByAppendingPathComponent:
						  @"ZNXmlHttpRequestTest.body"];
	STAssertEqualStrings([NSString stringWithContentsOfFile:bodyPath],
						 response.body, @"Wrong body in request");
}

- (void) testFileRequest {
	NSString* filePath = [[[NSBundle mainBundle] resourcePath]
						  stringByAppendingPathComponent:
						  @"ZNXmlHttpRequestTest.xml"];
	NSString* fileUrl = [[NSURL fileURLWithPath:filePath] absoluteString];
	
	[ZNXmlHttpRequest issueRequestToService:fileUrl
									   data:nil
							 responseModels:[NSDictionary
											 dictionaryWithObjectsAndKeys:
											 [ZNXmlHttpRequestTestModel class],
											 @"model",
											 [NSNull null],
											 @"nonmodel",
											 nil]
									 target:self
									 action:@selector(checkFileResponse:)];
	
	[[NSRunLoop currentRunLoop] runUntilDate:
	 [NSDate dateWithTimeIntervalSinceNow:1.0]];
	
	STAssertEquals(YES, receivedResponse,
				   @"Response never received");
}

- (void) checkFileResponse: (NSArray*)responseArray {
	receivedResponse = YES;	
	STAssertFalse([responseArray isKindOfClass:[NSError class]],
				  @"Error occured %@", responseArray);
	
	ZNXmlHttpRequestTestModel* model = [responseArray objectAtIndex:0];
	STAssertTrue([model isKindOfClass:[ZNXmlHttpRequestTestModel class]],
				 @"Model in response not deserialized properly");

	NSDictionary* nonmodel = [responseArray objectAtIndex:1];
	STAssertTrue([nonmodel isKindOfClass:[NSDictionary class]],
				 @"Non-model in response not deserialized with NSDictionary");
	
	NSDictionary* golden_nonmodel = [NSDictionary dictionaryWithObjectsAndKeys:
									 @"val1", @"key1", @"val2", @"key2", nil];
	STAssertEqualObjects(golden_nonmodel, nonmodel,
						 @"Non-model deserialized incorrectly");	
}

@end

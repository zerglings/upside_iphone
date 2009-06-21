//
//  ZNJsonHttpRequestTest.m
//  ZergSupport
//
//  Created by Victor Costan on 5/3/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ZNJsonHttpRequest.h"

#import "ModelSupport.h"


// Model for the response returned by the testbed.
@interface ZNJsonHttpRequestTestModel : ZNModel {
  NSString* method;
  NSString* uri;
  NSString* headers;
  NSString* body;
}
@property (nonatomic, retain) NSString* method;
@property (nonatomic, retain) NSString* uri;
@property (nonatomic, retain) NSString* headers;
@property (nonatomic, retain) NSString* body;
@end


@implementation ZNJsonHttpRequestTestModel

@synthesize method, uri, headers, body;
-(void)dealloc {
  [method release];
  [uri release];
  [headers release];
  [body release];
  [super dealloc];
}
@end


@interface ZNJsonHttpRequestTest : SenTestCase {
  NSString* service;
  BOOL receivedResponse;
}

@end

@implementation ZNJsonHttpRequestTest

-(void)warmUpHerokuService:(NSString*)herokuService {
  // Issues a request to the testbed, so heroku loads it up on a machine
  [NSString stringWithContentsOfURL:[NSURL URLWithString:herokuService]];
}

-(void)setUp {
  service = @"http://zn-testbed.heroku.com/web_support/echo.json";
  receivedResponse = NO;
  [self warmUpHerokuService:service];
  [ZNJsonHttpRequest deleteCookiesForService:service];
}

-(void)tearDown {
  [service release];
  service = nil;
}

-(void)dealloc {
  [super dealloc];
}

-(void)testOnlineGet {
  [ZNJsonHttpRequest callService:service
                          method:kZNHttpMethodGet
                            data:nil
                 responseQueries:[NSArray arrayWithObjects:
                                 [ZNJsonHttpRequestTestModel class], @"/echo",
                                 nil]
                         target:self
                         action:@selector(checkOnlineGetResponse:)];
  [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:
                                            1.0]];

  STAssertEquals(YES, receivedResponse, @"Response never received");
}

-(void)checkOnlineGetResponse:(NSArray*)responseArray {
  receivedResponse = YES;
  STAssertFalse([responseArray isKindOfClass:[NSError class]],
                @"Error occured %@", responseArray);

  ZNJsonHttpRequestTestModel* response = [responseArray objectAtIndex:0];
  STAssertTrue([response isKindOfClass:[ZNJsonHttpRequestTestModel class]],
               @"Response not deserialized using proper model");

  STAssertEqualStrings(@"get", response.method,
                       @"Request not issued using GET");
  STAssertEqualStrings(@"/web_support/echo.json", response.uri,
                       @"Incorrect request URI was used");
}

-(void)testOnlineRequest {
  ZNJsonHttpRequestTestModel* requestModel = [[[ZNJsonHttpRequestTestModel
                                                alloc] init] autorelease];
  requestModel.method = @"Awesome method";
  requestModel.uri = @"Awesome uri";
  requestModel.headers = @"Awesome headers";
  requestModel.body = @"Awesome body";

  NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                        requestModel, @"model",
                        @"someString", @"stringKey", nil];
  [ZNJsonHttpRequest callService:service
                          method:kZNHttpMethodPut
                            data:dict
                 responseQueries:[NSArray arrayWithObjects:
                                  [ZNJsonHttpRequestTestModel class], @"/echo",
                                  nil]
                          target:self
                          action:@selector(checkOnlineResponse:)];

  [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:
                                            1.0]];
  STAssertEquals(YES, receivedResponse, @"Response never received");
}

-(void)checkOnlineResponse:(NSArray*)responseArray {
  receivedResponse = YES;
  STAssertFalse([responseArray isKindOfClass:[NSError class]],
                @"Error occured %@", responseArray);

  ZNJsonHttpRequestTestModel* response = [responseArray objectAtIndex:0];
  STAssertTrue([response isKindOfClass:[ZNJsonHttpRequestTestModel class]],
               @"Response not deserialized using proper model");

  STAssertEqualStrings(@"put", response.method,
                       @"Request not issued using PUT");
  STAssertEqualStrings(@"/web_support/echo.json", response.uri,
                       @"Incorrect request URI was used");

  NSString* bodyPath = [[[self testBundle] resourcePath]
                        stringByAppendingPathComponent:
                        @"ZNJsonHttpRequestTest.body"];
  STAssertEqualStrings([NSString stringWithContentsOfFile:bodyPath],
                       response.body, @"Wrong body in request");
}

-(void)testFileRequest {
  NSString* filePath = [[[self testBundle] resourcePath]
                        stringByAppendingPathComponent:
                        @"ZNJsonHttpRequestTest.json"];
  NSString* fileUrl = [[NSURL fileURLWithPath:filePath] absoluteString];

  [ZNJsonHttpRequest callService:fileUrl
                          method:kZNHttpMethodGet
                            data:nil
                 responseQueries:[NSArray arrayWithObjects:
                                  [ZNJsonHttpRequestTestModel class], @"/model",
                                  [NSNull class], @"/nonmodel", nil]
                          target:self
                          action:@selector(checkFileResponse:)];

  [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:
                                            1.0]];
  STAssertEquals(YES, receivedResponse, @"Response never received");
}

-(void)checkFileResponse:(NSArray*)responseArray {
  receivedResponse = YES;
  STAssertFalse([responseArray isKindOfClass:[NSError class]],
                @"Error occured %@", responseArray);

  ZNJsonHttpRequestTestModel* model = [responseArray objectAtIndex:0];
  STAssertTrue([model isKindOfClass:[ZNJsonHttpRequestTestModel class]],
               @"Model in response not deserialized properly");
  STAssertEqualStrings(@"Body", model.body,
                       @"Model's body not deserialized properly");
  STAssertEqualStrings(@"Headers", model.headers,
                       @"Model's headers not deserialized properly");
  STAssertEqualStrings(@"Method", model.method,
                       @"Model's method not deserialized properly");
  STAssertEqualStrings(@"Uri", model.uri,
                       @"Model's uri not deserialized properly");

  NSDictionary* nonmodel = [responseArray objectAtIndex:1];
  STAssertTrue([nonmodel isKindOfClass:[NSDictionary class]],
               @"Non-model in response not deserialized with NSDictionary");

  NSDictionary* golden_nonmodel = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:1], @"key1",
                                   @"val2", @"key2", @"val3", @"keyThree", nil];
  STAssertEqualObjects(golden_nonmodel, nonmodel,
                       @"Non-model deserialized incorrectly");
}

@end

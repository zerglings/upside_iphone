//
//  ZNHttpRequestTest.m
//  ZergSupport
//
//  Created by Victor Costan on 1/21/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "FormatSupport.h"
#import "ModelSupport.h"
#import "ZNHttpRequest.h"

// Model that tests serialization.
@interface ZNHttpRequestTestModel : ZNModel
{
  NSString* textVal;
  NSUInteger uintVal;
  BOOL trueVal;
  NSDate* nilVal;
}

@property (nonatomic, retain) NSString* textVal;
@property (nonatomic) NSUInteger uintVal;
@property (nonatomic) BOOL trueVal;
@property (nonatomic, retain) NSDate* nilVal;

@end

@implementation ZNHttpRequestTestModel

@synthesize textVal, uintVal, trueVal, nilVal;

-(void)dealloc {
  [textVal release];
  [nilVal release];
  [super dealloc];
}

@end


@interface ZNHttpRequestTest : SenTestCase {
  ZNHttpRequestTestModel* requestModel;
  NSString* service;
  NSString* notFoundService;
  BOOL receivedResponse;
}

@end

@implementation ZNHttpRequestTest

-(void)warmUpHerokuService:(NSString*)herokuService {
  // Issues a request to the testbed, so heroku loads it up on a machine
  [NSString stringWithContentsOfURL:[NSURL URLWithString:herokuService]];
}

-(void)setUp {
  service = @"http://zn-testbed.heroku.com/web_support/echo.xml";
  notFoundService = @"http://zn-testbed.heroku.com/web_support/not_found";
  receivedResponse = NO;
  [self warmUpHerokuService:service];
  [ZNHttpRequest deleteCookiesForService:service];

  requestModel = [[[ZNHttpRequestTestModel alloc] init] autorelease];
  requestModel.textVal = @"Something\0special";
  requestModel.uintVal = 3141592;
  requestModel.trueVal = YES;
  requestModel.nilVal = nil;
}

-(void)tearDown {
  [service release];
  service = nil;
  [notFoundService release];
  notFoundService = nil;
}

-(void)dealloc {
  [super dealloc];
}

-(void)testOnlinePut {
  NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                        requestModel, @"model",
                        @"someString", @"stringKey", nil];
  [ZNHttpRequest callService:service
                      method:kZNHttpMethodPut
                        data:dict
                 fieldCasing:kZNFormatterSnakeCase
                encoderClass:[ZNFormURLEncoder class]
                      target:self
                      action:@selector(checkOnlineAndFileResponse:)];

  [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:
                                            1.0]];

  STAssertEquals(YES, receivedResponse, @"Response never received");
}

-(void)checkOnlineAndFileResponse:(NSData*)response {
  receivedResponse = YES;
  STAssertFalse([response isKindOfClass:[NSError class]],
                @"Error occured %@", response);

  NSString* responseString =
  [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
  NSString* bodyPath = [[[NSBundle mainBundle] resourcePath]
                        stringByAppendingPathComponent:
                        @"ZNHttpRequestTest.put"];
  STAssertEqualStrings([NSString stringWithContentsOfFile:bodyPath],
                       responseString, @"Wrong request");
}

-(void)testOnlineMultipartPut {
  srand(2912);  // Makes the random MIME boundary deterministic.

  NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                        requestModel, @"model",
                        @"someString", @"stringKey", nil];
  [ZNHttpRequest callService:service
                      method:kZNHttpMethodPut
                        data:dict
                 fieldCasing:kZNFormatterSnakeCase
                encoderClass:[ZNFormMultipartEncoder class]
                      target:self
                      action:@selector(checkOnlineMultipartResponse:)];

  [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:
                                            1.0]];

  STAssertEquals(YES, receivedResponse, @"Response never received");
}

-(void)checkOnlineMultipartResponse:(NSData*)response {
  receivedResponse = YES;
  STAssertFalse([response isKindOfClass:[NSError class]],
                @"Error occured %@", response);

  NSString* responseString =
      [[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]
       autorelease];
  responseString = [responseString stringByReplacingOccurrencesOfString:@"\r\n"
                                                             withString:@"\n"];

  NSString* bodyPath = [[[NSBundle mainBundle] resourcePath]
                        stringByAppendingPathComponent:
                        @"ZNHttpRequestTest.put.multipart"];
  STAssertEqualStrings([NSString stringWithContentsOfFile:bodyPath],
                       responseString, @"Wrong request");
}

-(void)testFileRequest {
  NSString* filePath = [[[NSBundle mainBundle] resourcePath]
                        stringByAppendingPathComponent:
                        @"ZNHttpRequestTest.put"];
  NSString* fileUrl = [[NSURL fileURLWithPath:filePath] absoluteString];

  [ZNHttpRequest callService:fileUrl
                      method:kZNHttpMethodGet
                        data:nil
                 fieldCasing:kZNFormatterSnakeCase
                encoderClass:[ZNFormURLEncoder class]
                      target:self
                      action:@selector(checkOnlineAndFileResponse:)];

  [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:
                                            1.0]];

  STAssertEquals(YES, receivedResponse, @"Response never received");
}

-(void)testOnlineGetWithoutQuery {
  NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                        requestModel, @"model",
                        @"someString", @"stringKey", nil];
  [ZNHttpRequest callService:service
                      method:kZNHttpMethodGet
                        data:dict
                 fieldCasing:kZNFormatterSnakeCase
                encoderClass:[ZNFormURLEncoder class]
                      target:self
                      action:@selector(checkOnlineGetWithoutQuery:)];

  [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:
                                            1.0]];

  STAssertEquals(YES, receivedResponse, @"Response never received");
}
-(void)checkOnlineGetWithoutQuery:(NSData*)response {
  receivedResponse = YES;
  STAssertFalse([response isKindOfClass:[NSError class]],
                @"Error occured %@", response);

  NSString* responseString =
      [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
  NSString* bodyPath = [[[NSBundle mainBundle] resourcePath]
                        stringByAppendingPathComponent:
                        @"ZNHttpRequestTest.get1"];
  STAssertEqualStrings([NSString stringWithContentsOfFile:bodyPath],
                       responseString, @"Wrong request");
}

-(void)testOnlineGetWithQuery {
  NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                        requestModel, @"model",
                        @"someString", @"stringKey", nil];
  [ZNHttpRequest callService:[NSString stringWithFormat:@"%@?xarg=yes", service]
                      method:kZNHttpMethodGet
                        data:dict
                 fieldCasing:kZNFormatterSnakeCase
                encoderClass:[ZNFormURLEncoder class]
                      target:self
                      action:@selector(checkOnlineGetWithQuery:)];

  [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:
                                           1.0]];

  STAssertEquals(YES, receivedResponse, @"Response never received");
}
-(void)checkOnlineGetWithQuery:(NSData*)response {
  receivedResponse = YES;
  STAssertFalse([response isKindOfClass:[NSError class]],
                @"Error occured %@", response);

  NSString* responseString =
  [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
  NSString* bodyPath = [[[NSBundle mainBundle] resourcePath]
                        stringByAppendingPathComponent:
                        @"ZNHttpRequestTest.get2"];
  STAssertEqualStrings([NSString stringWithContentsOfFile:bodyPath],
                       responseString, @"Wrong request");
}

-(void)testHttpErrorCode {
  [ZNHttpRequest callService:notFoundService
                      method:kZNHttpMethodGet
                        data:nil
                 fieldCasing:kZNFormatterSnakeCase
                encoderClass:[ZNFormURLEncoder class]
                      target:self
                      action:@selector(checkHttpErrorCode:)];

  [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:
                                            1.0]];

  STAssertEquals(YES, receivedResponse, @"Response never received");
}
-(void)checkHttpErrorCode:(NSError*)response {
  receivedResponse = YES;
  STAssertTrue([response isKindOfClass:[NSError class]],
               @"Error not reported %@", response);
  STAssertEquals(kZNHttpErrorDomain, [response domain],
                 @"Incorrect error domain");
  STAssertEquals(404, [response code], @"Incorrect error code");
}

@end

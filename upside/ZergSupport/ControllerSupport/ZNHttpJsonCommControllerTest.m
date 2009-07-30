//
//  ZNHttpJsonCommControllerTest.m
//  ZergSupport
//
//  Created by Victor Costan on 6/21/09.
//  Copyright 2009 MIT. All rights reserved.
//

#import "TestSupport.h"

#import "ModelSupport.h"
#import "WebSupport.h"
#import "ZNHttpJsonCommController.h"


// Model for the response returned by the testbed.
@interface ZNHttpJsonCommControllerTestModel : ZNModel {
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

@implementation ZNHttpJsonCommControllerTestModel
@synthesize method, uri, headers, body;

-(void)dealloc {
  [method release];
  [uri release];
  [headers release];
  [body release];
  [super dealloc];
}
@end


@interface ZNHttpJsonCommControllerTestController : ZNHttpJsonCommController {
}
@end

@implementation ZNHttpJsonCommControllerTestController
+(NSArray*)copyResponseQueries {
  return [[NSArray alloc] initWithObjects:
          [ZNHttpJsonCommControllerTestModel class], @"/echo", nil];
}
-(void)callService:(NSString*)service {
  [self callService:service method:kZNHttpMethodGet
               data:[NSDictionary dictionaryWithObjectsAndKeys:
                     @"value1", @"key1", nil]];
}
@end


@interface ZNHttpJsonCommControllerTest : SenTestCase {
  NSString* service;
  BOOL receivedResponse;
  UIApplication* app;
  ZNHttpJsonCommControllerTestController* commController;
}
@end


@implementation ZNHttpJsonCommControllerTest
-(void)warmUpHerokuService:(NSString*)herokuService {
  // Issues a request to the testbed, so heroku loads it up on a machine
  [NSString stringWithContentsOfURL:[NSURL URLWithString:herokuService]
                           encoding:NSUTF8StringEncoding
                              error:NULL];
}

-(void)setUp {
  service = @"http://zn-testbed.heroku.com/web_support/echo.json";
  receivedResponse = NO;
  [self warmUpHerokuService:service];
  app = [UIApplication sharedApplication];
  [ZNJsonHttpRequest deleteCookiesForService:service];
  commController = [[ZNHttpJsonCommControllerTestController alloc]
                    initWithTarget:self action:@selector(checkResponse:)];
}

-(void)tearDown {
  [service release];
  service = nil;
}

-(void)testNormalRun {
  [commController callService:service];

  STAssertTrue([app isNetworkActivityIndicatorVisible],
               @"Comm controller did not anounce start of net request");
  [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:
                                            1.0]];

  STAssertEquals(YES, receivedResponse, @"Never received response");
  STAssertFalse([app isNetworkActivityIndicatorVisible],
                @"Comm controller did not anounce end of net request");
}

-(void)checkResponse:(NSArray*)responseArray {
  receivedResponse = YES;
  STAssertFalse([responseArray isKindOfClass:[NSError class]],
                @"Error occured %@", responseArray);

  ZNHttpJsonCommControllerTestModel* response = [responseArray objectAtIndex:0];
  STAssertTrue([response isKindOfClass:[ZNHttpJsonCommControllerTestModel
                                        class]],
               @"Response not deserialized using proper model");

  STAssertEqualStrings(@"get", response.method,
                       @"Request not issued using GET");
  STAssertEqualStrings(@"/web_support/echo.json?key1=value1", response.uri,
                       @"Incorrect request URI was used");
}

@end

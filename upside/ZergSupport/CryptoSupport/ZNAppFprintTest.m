//
//  ZNAppFprintTest.m
//  ZergSupport
//
//  Created by Victor Costan on 4/27/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ZNAppFprint.h"

#import "FormatSupport.h"
#import "ImobileSupport.h"
#import "WebSupport.h"


@interface ZNAppFprint ()
// This methods aren't part of the public API. They are used for testing
// convenience.
+(NSString*)manifestPath;
+(NSString*)executablePath;
@end


@interface ZNAppFprintTest : SenTestCase {
  NSDictionary* deviceAttributes;
  NSString* testService;
  NSData* manifest;
  BOOL receivedResponse;
}

@end


@implementation ZNAppFprintTest

-(void)warmUpHerokuService:(NSString*)herokuService {
  // Issues a request to the testbed, so heroku loads it up on a machine
  [NSString stringWithContentsOfURL:[NSURL URLWithString:herokuService]
                           encoding:NSUTF8StringEncoding
                              error:NULL];
}

-(void)setUp {
  deviceAttributes = [ZNAppFprint copyDeviceAttributes];
  manifest = [[NSData alloc] initWithContentsOfFile:[ZNAppFprint
                                                     executablePath]];
              

  testService =
      @"http://zn-testbed.heroku.com/crypto_support/app_fprint.xml";
  receivedResponse = NO;
  [self warmUpHerokuService:testService];
}

-(void)tearDown {
  [deviceAttributes release];
  [manifest release];

  [testService release];
  testService = nil;
}

-(void)testFprint {
  // Wait to get a push token, so the fingerprint is stable.
  if (![ZNImobileDevice inSimulator]) {
    for (NSUInteger i = 0; i < 100; i++) {
      [[NSRunLoop currentRunLoop] runUntilDate:
       [NSDate dateWithTimeIntervalSinceNow:0.1]];
      if ([ZNImobileDevice appPushToken]) {
        break;
      }
    }
  }
    
  NSDictionary* request = [NSDictionary dictionaryWithObjectsAndKeys:
                           deviceAttributes, @"attributes",
                           manifest, @"manifest",
                           nil];

  [ZNXmlHttpRequest callService:testService
                         method:kZNHttpMethodPost
                           data:request
                    fieldCasing:kZNFormatterSnakeCase
                   encoderClass:[ZNFormMultipartEncoder class]
                 responseModels:[NSDictionary dictionaryWithObject:[NSNull null]
                                                            forKey:@"fprint"]
                 responseCasing:kZNFormatterSnakeCase
                         target:self
                         action:@selector(checkFprints:)];

  // Heroku can take a looong time to compute the fingerprint.
  for (NSUInteger i = 0; i < 60; i++) {
    [[NSRunLoop currentRunLoop] runUntilDate:
     [NSDate dateWithTimeIntervalSinceNow:1.0]];
    if (receivedResponse == YES)
      break;
  }

  STAssertEquals(YES, receivedResponse, @"Verification service didn't respond");
}
-(void)checkFprints:(NSArray*)response {
  NSDictionary* goldenFprints = [response objectAtIndex:0];
  receivedResponse = YES;

  NSString* goldenHexFprint = [goldenFprints objectForKey:@"hexFprint"];
  NSString* hexFprint = [ZNAppFprint copyHexAppFprint];
  STAssertEqualStrings(goldenHexFprint, hexFprint,
                       @"Application fingerprint formatted as hex");
  [hexFprint release];
}


@end

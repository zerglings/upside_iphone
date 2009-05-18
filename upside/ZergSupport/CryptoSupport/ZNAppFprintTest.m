//
//  ZNAppFprintTest.m
//  ZergSupport
//
//  Created by Victor Costan on 4/27/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ZNAppFprint.h"

#import "WebSupport.h"
#import "ZNDeviceFprint.h"


@interface ZNAppFprint ()
// This method isn't part of the public API. It's used for testing
// convenience.
+(NSString*)executablePath;
@end


@interface ZNAppFprintTest : SenTestCase {
  NSDictionary* deviceAttributes;
  NSString* testService;
  NSString* manifest;
  BOOL receivedResponse;
}

@end


@implementation ZNAppFprintTest

-(void)warmUpHerokuService:(NSString*)herokuService {
  // Issues a request to the testbed, so heroku loads it up on a machine
  [NSString stringWithContentsOfURL:[NSURL URLWithString:herokuService]];
}

-(void)setUp {
  deviceAttributes = [[ZNDeviceFprint deviceAttributes] retain];
  NSData* manifestData = [NSData
                          dataWithContentsOfFile:[ZNAppFprint manifestPath]];
  manifest = [[NSString alloc] initWithData:manifestData
                                   encoding:NSASCIIStringEncoding];

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
  NSDictionary* request = [NSDictionary dictionaryWithObjectsAndKeys:
                           deviceAttributes, @"attributes",
                           manifest, @"manifest",
                           nil];

  [ZNXmlHttpRequest callService:testService
                         method:kZNHttpMethodPost
                           data:request
                 responseModels:[NSDictionary dictionaryWithObject:[NSNull null]
                                                            forKey:@"fprint"]
                         target:self
                         action:@selector(checkFprints:)];

  [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:
                                            1.0]];

  STAssertEquals(YES, receivedResponse, @"Verification service didn't respond");
}
-(void)checkFprints:(NSArray*)response {
  NSDictionary* goldenFprints = [response objectAtIndex:0];
  receivedResponse = YES;

  NSString* goldenHexFprint = [goldenFprints objectForKey:@"hexFprint"];
  NSString* hexFprint = [ZNAppFprint hexAppFprint];
  STAssertEqualStrings(goldenHexFprint, hexFprint,
                       @"Application fingerprint formatted as hex");
}


@end

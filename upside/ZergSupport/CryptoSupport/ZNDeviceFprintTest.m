//
//  ZNDeviceFprintTest.m
//  ZergSupport
//
//  Created by Victor Costan on 4/25/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ZNDeviceFprint.h"

#import "WebSupport.h"
#import "ZNMd5Digest.h"


@interface ZNDeviceFprint ()
// This method isn't part of the public API. It's tested for debugging
// convenience, because its failure log can helps debug most of the logic.
+(NSData*)fprintData;
@end


@interface ZNDeviceFprintTest : SenTestCase {
  NSDictionary* deviceAttributes;
  NSString* testService;
  BOOL receivedResponse;
}

@end


@implementation ZNDeviceFprintTest

-(void)warmUpHerokuService:(NSString*)herokuService {
  // Issues a request to the testbed, so heroku loads it up on a machine
  [NSString stringWithContentsOfURL:[NSURL URLWithString:herokuService]];
}

-(void)setUp {
  deviceAttributes = [[ZNDeviceFprint deviceAttributes] retain];

  testService =
      @"http://zn-testbed.heroku.com/crypto_support/device_fprint.xml";
  receivedResponse = NO;
  [self warmUpHerokuService:testService];
}

-(void)tearDown {
  [deviceAttributes release];

  [testService release];
  testService = nil;
}


-(void)testDeviceAttributes {
  NSCharacterSet* digits = [NSCharacterSet decimalDigitCharacterSet];
  NSDictionary* attributes = deviceAttributes;

  // NOTE: The appVersion below is hard-coded in the Info.plist for
  //       ZergSupportTests. The test will probably fail when included in
  //       another suite.
  STAssertEqualStrings(@"1.9.8.3", [attributes objectForKey:@"appVersion"],
                       @"appVersion");

  // NOTE: The checks below make assumptions on Apple's future moves. They
  //       will break if the assumptions are wrong. The main point of the tests
  //       is to make sure that the value in each key looks right.

  // hardwareModel should be i386 or somethingX,Y where X and Y are digits.
  NSString* model = [attributes objectForKey:@"hardwareModel"];
  NSRange comma = [model rangeOfString:@","];
  if (comma.length == 0) {
    STAssertEqualStrings(@"i386", model,
                        @"Simulator hardwareModel should be i386");
  }
  else {
    STAssertTrue([digits characterIsMember:
                  [model characterAtIndex:(comma.location - 1)]],
                 @"Device hardwareModel should have a digit before ,");
    STAssertTrue([digits characterIsMember:
                  [model characterAtIndex:(comma.location + 1)]],
                 @"Device hardwareModel should have a digit after ,");
  }

  STAssertEqualObjects(@"iPhone OS", [attributes objectForKey:@"osName"],
                       @"osName");

  NSString* osVersion = [attributes objectForKey:@"osVersion"];
  STAssertTrue([digits characterIsMember:[osVersion characterAtIndex:0]],
               @"osVersion should start with a digit");
  STAssertEquals((unichar)'.', [osVersion characterAtIndex:1],
                 @"osVersion should have a . after the first digit");
  STAssertTrue([digits characterIsMember:[osVersion characterAtIndex:2]],
               @"osVersion should have a digit after the first .");

  STAssertEquals(40U, [[attributes objectForKey:@"uniqueId"] length],
                 @"UDID length");
}

-(void)testDigests {
  NSDictionary* request = [NSDictionary dictionaryWithObject:deviceAttributes
                                                      forKey:@"attributes"];

  [ZNXmlHttpRequest callService:testService
                         method:kZNHttpMethodPost
                           data:request
                 responseModels:[NSDictionary dictionaryWithObject:[NSNull null]
                                                            forKey:@"fprint"]
                         target:self
                         action:@selector(checkDigests:)];

  [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:
                                            1.0]];

  STAssertEquals(YES, receivedResponse, @"Verification service didn't respond");
}
-(void)checkDigests:(NSArray*)response {
  NSDictionary* goldenDigests = [response objectAtIndex:0];
  receivedResponse = YES;

  // This method isn't part of the public API. It's tested for debugging
  // convenience, because its failure log can helps debug most of the logic.
  NSString* goldenDataString = [goldenDigests objectForKey:@"data"];
  NSString* dataString = [[NSString alloc] initWithData:[ZNDeviceFprint
                                                         fprintData]
                                               encoding:NSASCIIStringEncoding];
  STAssertEqualStrings(goldenDataString, dataString, @"Fingerprint data");
  [dataString release];

  NSString* goldenHexDigest = [goldenDigests objectForKey:@"hexMd5"];
  NSString* hexDigest = [ZNDeviceFprint
                         copyHexFprintUsingDigest:[ZNMd5Digest digester]];
  STAssertEqualStrings(goldenHexDigest, hexDigest,
                       @"Fingerprint MD5 hexdigest");
  [hexDigest release];

  NSData* goldenDigest = [ZNMd5Digest copyDigest:[ZNDeviceFprint fprintData]];
  NSData* digest = [ZNDeviceFprint copyFprintUsingDigest:[ZNMd5Digest
                                                          digester]];
  STAssertEqualObjects(goldenDigest, digest, @"Fingerprint MD5 digest");
  [digest release];
}

@end

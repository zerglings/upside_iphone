//
//  ZNDeviceFprintTest.m
//  ZergSupport
//
//  Created by Victor Costan on 4/25/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ZNDeviceFprint.h"

#import "ImobileSupport.h"
#import "WebSupport.h"
#import "ZNMd5Digest.h"


@interface ZNDeviceFprint ()
// Thess methods aren't part of the public API. It's tested for debugging
// convenience, because their failure logs can help debug most of the logic.
+(NSString*)copyProvisioningStringFor:(NSUInteger)provisioning;
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
  [NSString stringWithContentsOfURL:[NSURL URLWithString:herokuService]
                           encoding:NSUTF8StringEncoding
                              error:NULL];
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

-(void)testAppProvisioning {
  NSUInteger provisioning[] = {
    kZNImobileProvisioningSimulatorDebug,
    kZNImobileProvisioningSimulatorRelease,
    kZNImobileProvisioningDeviceDebug,
    kZNImobileProvisioningDeviceRelease,
    kZNImobileProvisioningDeviceDistribution,
  };
  NSString* golden[] = {@"s", @"S", @"h", @"H", @"D"};
  
  for (NSUInteger i = 0; i < sizeof(golden) / sizeof(*golden); i++) {
    STAssertEqualStrings(golden[i],
                         [ZNDeviceFprint copyProvisioningStringFor:
                          provisioning[i]],
                         @"Provisioning string mapping failed");
  }
}

-(void)testDeviceAttributes {
  NSDictionary* attributes = deviceAttributes;

  STAssertEqualStrings(@"us.costan.ZergSupportTests",
                       [attributes objectForKey:@"appId"], @"appId");
  STAssertEqualStrings(@"1.9.8.3", [attributes objectForKey:@"appVersion"],
                       @"appVersion");
  
  STAssertEqualStrings([ZNImobileDevice hardwareModel],
                       [attributes objectForKey:@"hardwareModel"],
                       @"hardwareModel");
  
  STAssertEqualObjects(@"iPhone OS", [attributes objectForKey:@"osName"],
                       @"osName");
  STAssertEqualStrings([ZNImobileDevice osVersion],
                       [attributes objectForKey:@"osVersion"],
                       @"osVersion");

  STAssertEquals(40U, [[attributes objectForKey:@"uniqueId"] length],
                 @"UDID length");

  NSString* appProvisioning = [attributes objectForKey:@"appProvisioning"];
  STAssertEquals(1U, [appProvisioning length], @"appProvisioning length");
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
  NSString* dataString =
      [[NSString alloc] initWithData:[ZNDeviceFprint fprintData]
                            encoding:NSISOLatin1StringEncoding];
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

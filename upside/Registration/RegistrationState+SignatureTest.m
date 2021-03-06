//
//  RegistrationState+SignatureTest.m
//  StockPlay
//
//  Created by Victor Costan on 1/29/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "TestSupport.h"

#import "Device.h"
#import "RegistrationState+Signature.h"


@interface RegistrationStateSignatureTest : SenTestCase {
  NSString* testUdid;
  Device* testDevice;
  RegistrationState* testState;
}
@end


@implementation RegistrationStateSignatureTest

-(void)setUp {
  testUdid = @"1234512345123451234512345123451234512345";
  testDevice = [[Device alloc] initWithProperties:
                [NSDictionary dictionaryWithObjectsAndKeys:
                 testUdid, @"uniqueId", nil]];
  testState = [[RegistrationState alloc] init];
  [testState setDeviceInfo:testDevice];
}

-(void)tearDown {
  [testDevice release];
  [testState release];
}

-(void)testSignature {
  NSDictionary* goldenSig =
      [[NSDictionary alloc] initWithObjectsAndKeys:
       testUdid, @"uniqueID",
       @"c9acca7ec91004c549b09699d9404af28196e5488b94f70c87c44be05a19c694",
       @"deviceSig", @"1", @"deviceSigV", nil];

  STAssertEqualObjects(goldenSig, [testState requestSignature],
                       @"Invalid signature for Web requests");
}

@end

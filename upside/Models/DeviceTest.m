//
//  DeviceTest.m
//  upside
//
//  Created by Victor Costan on 3/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TestSupport.h"

#import "Device.h"

@interface DeviceTest : SenTestCase {
  Device* current;
  Device* registered;
  Device* copied;
  Device* outdated;
  NSUInteger userId;
  NSUInteger modelId;
}

@end

@implementation DeviceTest

-(void)setUp {
  current = [Device copyCurrentDevice];
  registered = [[Device alloc] initWithProperties:
                [NSDictionary dictionaryWithObjectsAndKeys:
                 [NSString stringWithFormat:@"%u", modelId], @"modelId",
                 [NSString stringWithFormat:@"%u", userId], @"userId",
                 @"1.1.4", @"osVersion", @"iPhone OS", @"osName", nil]];
  copied = [current copyAndUpdate];
  outdated = [[Device alloc] initWithModel:current properties:
              [NSDictionary dictionaryWithObjectsAndKeys:
               @"1.1.4", @"osVersion", nil]];
              
}

-(void)tearDown {
  [current release];
  [registered release];
  [copied release];
  [outdated release];
}

-(void)dealloc {
  [super dealloc];
}

-(void)testCurrentDevice {
  STAssertEquals(40U, [[current uniqueId] length], @"Device ID length");
  STAssertEqualStrings([Device currentHardwareModel],
                       [current hardwareModel], @"Device model");
  STAssertEqualStrings([[UIDevice currentDevice] systemName],
                       [current osName], @"Device model");
  STAssertEqualStrings([[UIDevice currentDevice] systemVersion],
                       [current osVersion], @"Device model");
  STAssertEqualStrings([[NSBundle mainBundle] objectForInfoDictionaryKey:
                        (NSString*)kCFBundleVersionKey],
                       [current appVersion], @"App version");
}
-(void)testIsEqualToCurrentDevice {
  STAssertTrue([current isEqualToCurrentDevice],
               @"Obtained from copyCurrentDevice");
  STAssertFalse([registered isEqualToCurrentDevice], @"Outdated device data");
}
-(void)testCopyAndUpdateDevice {
  STAssertTrue([copied isEqualToCurrentDevice],
               @"The copied device is current");
  STAssertEquals(userId, [copied userId], @"Copied user ID");
  STAssertEquals(modelId, [copied modelId], @"Copied model ID");
}
@end

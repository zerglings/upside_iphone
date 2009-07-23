//
//  ZNDeviceFprint.m
//  ZergSupport
//
//  Created by Victor Costan on 4/25/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNDeviceFprint.h"


#import "ImobileSupport.h"


@implementation ZNDeviceFprint

// Produces the device attributes returned by -deviceAttributes.
//
// The result of this method does not change throughout the duration of program
// execution, therefore it is cached. Never call this method directly.
+(NSDictionary*)copyDeviceAttributes {
  return [[NSMutableDictionary alloc] initWithObjectsAndKeys:
          [ZNImobileDevice appId], @"appId",
          [ZNImobileDevice appVersion], @"appVersion",
          [ZNImobileDevice hardwareModel], @"hardwareModel",
          [ZNImobileDevice osName], @"osName",
          [ZNImobileDevice osVersion], @"osVersion",
          [ZNImobileDevice uniqueDeviceId], @"uniqueId",
          nil];
}

// Holds the cached dictionary of device attributes.
static NSDictionary* cachedDeviceAttributes;

+(NSDictionary*)deviceAttributes {
  @synchronized ([ZNDeviceFprint class]) {
    if (!cachedDeviceAttributes) {
      cachedDeviceAttributes = [ZNDeviceFprint copyDeviceAttributes];
    }
  }
  return cachedDeviceAttributes;
}

// Holds the cached data used for fingerprinting the device.
static NSData* cachedFprintData;

// The data used for fingerprinting the device.
+(NSData*)fprintData {
  @synchronized ([ZNDeviceFprint class]) {
    if (!cachedFprintData) {
      NSMutableData* data = [[NSMutableData alloc] initWithBytes:"D" length:1];
      NSDictionary* deviceAttrs = [self deviceAttributes];
      NSArray* sortedKeys =
          [[deviceAttrs allKeys] sortedArrayUsingSelector:@selector(compare:)];
      for (NSString* key in sortedKeys) {
        [data appendBytes:"|" length:1];
        [data appendData:[[deviceAttrs valueForKey:key]
                          dataUsingEncoding:NSUTF8StringEncoding]];
      }
      // cachedFprintData is private. We don't need to convert it into a
      // NSDictionary, because we know nobody will modify it.
      cachedFprintData = data;
    }
  }
  return cachedFprintData;
}

// The device fingerprint.
+(NSData*)copyFprintUsingDigest:(id<ZNDigester>)digester {
  return [digester copyDigest:[ZNDeviceFprint fprintData]];
}

// The hexadecimal string for the device fingerprint.
+(NSString*)copyHexFprintUsingDigest:(id<ZNDigester>)digester {
  return [digester copyHexDigest:[ZNDeviceFprint fprintData]];
}

@end

//
//  ZNDeviceFprint.m
//  ZergSupport
//
//  Created by Victor Costan on 4/25/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNDeviceFprint.h"


#import "ImobileSupport.h"


@interface ZNDeviceFprint ()
+(NSString*)copyProvisioningStringFor:(NSUInteger)provisioning;
@end


@implementation ZNDeviceFprint

// Produces the device attributes returned by -deviceAttributes.
//
// The result of this method does not change throughout the duration of program
// execution, therefore it is cached. Never call this method directly.
+(NSDictionary*)copyDeviceAttributes {
  NSString* provisioningString = [self copyProvisioningStringFor:
                                  [ZNImobileDevice appProvisioning]];
  NSDictionary *attributes =
      [[NSMutableDictionary alloc] initWithObjectsAndKeys:
       [ZNImobileDevice appId], @"appId",
       provisioningString, @"appProvisioning",
       [ZNImobileDevice appVersion], @"appVersion",
       [ZNImobileDevice hardwareModel], @"hardwareModel",
       [ZNImobileDevice osName], @"osName",
       [ZNImobileDevice osVersion], @"osVersion",
       [ZNImobileDevice uniqueDeviceId], @"uniqueId",
       nil];
  [provisioningString release];
  return attributes;
}

+(NSString*)copyProvisioningStringFor:(NSUInteger)provisioning {
  const unichar provisioningChars[] = {0, 's', 'S', 'h', 'H', 'D'};
  NSAssert1(provisioning < sizeof(provisioningChars) /
            sizeof(*provisioningChars), @"Unknown appProvisioning %u",
            provisioning);
  return [[NSString alloc] initWithCharacters:(provisioningChars + provisioning)
                                       length:1];
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

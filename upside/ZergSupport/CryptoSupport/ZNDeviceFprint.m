//
//  ZNDeviceFprint.m
//  ZergSupport
//
//  Created by Victor Costan on 4/25/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNDeviceFprint.h"

#include <sys/types.h>
#include <sys/sysctl.h>

#import <UIKit/UIKit.h>


@implementation ZNDeviceFprint

// A unique device ID (UDID) normalized across phones and simulators.
//
// The UDID has 40 characters a real iPhone / iPod, but only 36 characters on
// the simulator. To make up for that, simulator UDIDs are padded by "sim:".
+(NSString*)uniqueDeviceId {
  NSString* udid = [[UIDevice currentDevice] uniqueIdentifier];
  if ([udid length] == 40)
    return udid;
  return [NSString stringWithFormat:@"sim:%@", udid];
}

// Retrieves the device's hardware model from the kernel.
+(NSString*)hardwareModel {
  // NOTE: This method is not well covered by unit tests, because I couldn't
  //       figure out a good golden value. I could hard-code the golden value
  //       to "i386" (what the simulator returns) but that would cause tests to
  //       fail on a device. On the bright side, the method is unlikely to
  //       change, because it relies on OSX kernel functionality.

  size_t keySize;
  sysctlbyname("hw.machine", NULL, &keySize, NULL, 0);
  char *key = malloc(keySize);
  sysctlbyname("hw.machine", key, &keySize, NULL, 0);
  NSString *hardwareModel = [NSString stringWithCString:key
                                               encoding:NSUTF8StringEncoding];
  free(key);
  return hardwareModel;
}

// Retrieves the running application's version.
+(NSString*)appVersion {
  return [[NSBundle mainBundle]
          objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
}

// Produces the device attributes returned by -deviceAttributes.
//
// The result of this method does not change throughout the duration of program
// execution, therefore it is cached. Never call this method directly.
+(NSDictionary*)copyDeviceAttributes {
  UIDevice* device = [UIDevice currentDevice];
  return [[NSMutableDictionary alloc] initWithObjectsAndKeys:
          [ZNDeviceFprint appVersion], @"appVersion",
          [ZNDeviceFprint hardwareModel], @"hardwareModel",
          [device systemName], @"osName",
          [device systemVersion], @"osVersion",
          [ZNDeviceFprint uniqueDeviceId], @"uniqueId",
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

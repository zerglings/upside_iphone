//
//  ZNAppFprint.m
//  ZergSupport
//
//  Created by Victor Costan on 4/27/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNAppFprint.h"

#import "ControllerSupport.h"
#import "FormatSupport.h"
#import "ImobileSupport.h"
#import "ZNAesCipher.h"
#import "ZNFileFprint.h"
#import "ZNMd5Digest.h"
#import "ZNSha2Digest.h"


@interface ZNAppFprint ()
+(NSString*)copyProvisioningStringFor:(NSUInteger)provisioning;
+(NSData*)copyFprintData;
@end


@implementation ZNAppFprint

#pragma mark Caching and Push Notifications

// Holds the cached dictionary of device attributes.
static NSDictionary* cachedDeviceAttributes = nil;
// Holds the hex-formatted app fprint for the entire application lifetime.
static NSString* cachedHexAppFprint;
// Set to YES when the +pushTokenChanged: is hooked into the target-action site
// for push notifications.
static BOOL hookedIntoPushNotifications = NO;

// Called when the application's push token changes.
+(void)pushTokenChanged:(NSData*)newPushToken {
  // Reset the cached attribute data. It will be recomputed on-demand.
  @synchronized ([ZNAppFprint class]) {
    [cachedDeviceAttributes release];
    cachedDeviceAttributes = nil;

    [cachedHexAppFprint release];
    cachedHexAppFprint = nil;
  }
}
// Hooks +pushTokenChanged: into the its desigated target-action site.
+(void)hookIntoPushNotifications {
  if (!hookedIntoPushNotifications) {
    [[ZNPushNotifications pushTokenChangedSite]
     addTarget:[ZNAppFprint class]
     action:@selector(pushTokenChanged:)];
    hookedIntoPushNotifications = YES;
  }
}

#pragma mark Device and Application Attributes

// Produces the device attributes returned by -copyDeviceAttributes.
//
// The result of this method does not change throughout the duration of program
// execution, therefore it is cached. Never call this method directly.
+(NSDictionary*)newDeviceAttributes {
  NSString* provisioningString = [self copyProvisioningStringFor:
                                  [ZNImobileDevice appProvisioning]];
  NSString* pushTokenString =
      [ZNStringEncoder copyHexStringForData:[ZNImobileDevice appPushToken]];

  NSDictionary *attributes =
  [[NSMutableDictionary alloc] initWithObjectsAndKeys:
   [ZNImobileDevice appId], @"appId",
   provisioningString, @"appProvisioning",
   pushTokenString, @"appPushToken",
   [ZNImobileDevice appVersion], @"appVersion",
   [ZNImobileDevice hardwareModel], @"hardwareModel",
   [ZNImobileDevice osName], @"osName",
   [ZNImobileDevice osVersion], @"osVersion",
   [ZNImobileDevice uniqueDeviceId], @"uniqueId",
   nil];
  [provisioningString release];
  [pushTokenString release];
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

+(NSDictionary*)copyDeviceAttributes {
  NSDictionary* returnValue;
  @synchronized ([ZNAppFprint class]) {
    if (!cachedDeviceAttributes) {
      cachedDeviceAttributes = [ZNAppFprint newDeviceAttributes];
      [ZNAppFprint hookIntoPushNotifications];
    }
    returnValue = [cachedDeviceAttributes retain];
  }
  return returnValue;
}

#pragma mark Device and Application Fingerprint

+(NSData*)copyFprintUsingDigest:(id<ZNDigester>)digester {
  NSData* fprintData = [ZNAppFprint copyFprintData];
  NSData* digestedData = [digester copyDigest:fprintData];
  [fprintData release];
  return digestedData;
}

// The data used for fingerprinting the device.
+(NSData*)copyFprintData {
  NSMutableData* data = [[NSMutableData alloc] initWithBytes:"D" length:1];
  NSDictionary* deviceAttrs = [self copyDeviceAttributes];
  NSArray* sortedKeys =
      [[deviceAttrs allKeys] sortedArrayUsingSelector:@selector(compare:)];
  for (NSString* key in sortedKeys) {
    [data appendBytes:"|" length:1];
    [data appendData:[[deviceAttrs valueForKey:key]
                      dataUsingEncoding:NSUTF8StringEncoding]];
  }
  [deviceAttrs release];

  NSData* returnValue = [[NSData alloc] initWithData:data];
  [data release];
  return returnValue;
}

// The hexadecimal string for the device fingerprint.
+(NSString*)copyHexFprintUsingDigest:(id<ZNDigester>)digester {
  NSData* fprintData = [ZNAppFprint copyFprintData];
  NSString* hexDigest = [digester copyHexDigest:fprintData];
  [fprintData release];
  return hexDigest;
}

#pragma mark Application Fingerprint

// The path to the application's manifest file (Info.plist).
+(NSString*)manifestPath {
  return [[[NSBundle mainBundle] bundlePath]
          stringByAppendingPathComponent:@"Info.plist"];
}

// The path to the application's executable file.
+(NSString*)executablePath {
  return [[NSBundle mainBundle] executablePath];
}

// Computes the hex-formatted application fingerprint.
//
// Since this fingerprint will not change while the application is running,
// the computed fingerprint is cached by -copyHexAppFprint. Clients should use
// -copyHexAppFprint, instead of using this method directly.

+(NSString*)newHexAppFprint {
  NSData* key = [ZNAppFprint copyFprintUsingDigest:[ZNMd5Digest digester]];
  NSString* filePath = [ZNAppFprint executablePath];
  NSString* hexFprint = [ZNFileFprint copyHexFprint:filePath
                                                key:key
                                                 iv:nil
                                        cipherClass:[ZNAesCipher cipherClass]
                                           digester:[ZNSha2Digest digester]];
  [key release];
  return hexFprint;
}

+(NSString*)copyHexAppFprint {
  NSString* returnValue;
  @synchronized ([ZNAppFprint class]) {
    if (!cachedHexAppFprint) {
      cachedHexAppFprint = [ZNAppFprint newHexAppFprint];
      [ZNAppFprint hookIntoPushNotifications];
    }
    returnValue = [cachedHexAppFprint retain];
  }
  return returnValue;
}

@end

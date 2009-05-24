//
//  ZNAppFprint.m
//  ZergSupport
//
//  Created by Victor Costan on 4/27/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNAppFprint.h"

#import "ZNAesCipher.h"
#import "ZNDeviceFprint.h"
#import "ZNFileFprint.h"
#import "ZNMd5Digest.h"
#import "ZNSha2Digest.h"


@implementation ZNAppFprint

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
// the computed fingerprint is cached by -hexAppFprint.
+(NSString*)copyHexAppFprint {
  NSData* key = [ZNDeviceFprint copyFprintUsingDigest:[ZNMd5Digest digester]];
  NSString* filePath = [ZNAppFprint executablePath];
  NSString* hexFprint = [ZNFileFprint copyHexFprint:filePath
                                                key:key
                                                 iv:nil
                                        cipherClass:[ZNAesCipher cipherClass]
                                           digester:[ZNSha2Digest digester]];
  [key release];
  return hexFprint;
}

// Holds the hex-formatted app fprint for the entire application lifetime.
static NSString* cachedHexAppFprint;

+(NSString*)hexAppFprint {
  @synchronized ([ZNAppFprint class]) {
    if (!cachedHexAppFprint) {
      cachedHexAppFprint = [ZNAppFprint copyHexAppFprint];
    }
  }
  return cachedHexAppFprint;
}

@end

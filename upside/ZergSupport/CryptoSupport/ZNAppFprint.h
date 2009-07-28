//
//  ZNAppFprint.h
//  ZergSupport
//
//  Created by Victor Costan on 4/27/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

@protocol ZNDigester;


// Produces a fingerprint that can be used to verify an application's integrity.
//
// The fingerprint is a based on the characteristics of the device and
// application, as well as on the application's executable file.
//
// The characteristics can be obtained by calling +deviceAttributes.
@interface ZNAppFprint : NSObject {
}

// The application fingerprint.
//
// TODO(overmind): document the fingerprinting process.
//
// The unit tests verify this computation against the code at:
// http://github.com/costan/zn_testbed/blob/master/lib/crypto_support/app_fprint.rb
+(NSString*)copyHexAppFprint;

// The device and application attributes included in the fingerprinting process.
//
// A dictionary with the following keys (with example values):
//   * appId: @"us.costan.ZergSupportTests" (from Info.plist in the main app)
//   * appProvisioning: @"s" (s / S / h / H / D)
//   * appPushToken: @"c04046356452..." (64 hex digits, or empty)
//   * appVersion: @"1.0" (taken from Info.plist in the main app)
//   * hardwareModel: @"iPhone1,1"
//   * osName: @"iPhone OS"
//   * osVersion: @"2.0"
//   * uniqueId: @"sim:EEAE137F-205A-587E-8F62-C6855680879E" (or a real UDID)
+(NSDictionary*)copyDeviceAttributes;

// The device fingerprint.
//
// The fingerprint is the message digest over the device's attributes. The
// digest is computed by sorting the attribute dictionary according to the keys,
// then joining the values by |, and prefixing D| to the result. For example,
// the dictionary above would be fingerprinted as the digest of:
//   D|1.0|iPhone1,1|iPhone OS|2.0|sim:EEAE137F-205A-587E-8F62-C6855680879E
//
// The unit tests verify this computation against the code at:
// http://github.com/costan/zn_testbed/blob/master/lib/crypto_support/device_fprint.rb
+(NSData*)copyFprintUsingDigest:(id<ZNDigester>)digestClass;

// The hexadecimal string for the device fingerprint.
//
// This uses the same algorithm as -copyFprintUsingDigest, but produces a digest
// formatted as a string of hexadecimal digits, for ease of use with Web
// services.
+(NSString*)copyHexFprintUsingDigest:(id<ZNDigester>)digestClass;

@end

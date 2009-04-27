//
//  ZNDeviceFprint.h
//  ZergSupport
//
//  Created by Victor Costan on 4/25/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

#import "ZNDigester.h"

// Produces a fingerprint representing the current device.
//
// The fingerprint is a message digest over a dictionary containing the device's
// characteristics. The dictionary can be obtained from +deviceAttributes.
@interface ZNDeviceFprint : NSObject {
}

// The device attributes included in the fingerprinting process.
//
// A dictionary with the following keys (with example values):
//   * appVersion: @"1.0" (taken from Info.plist in the main app)
//   * hardwareModel: @"iPhone1,1"
//   * osName: @"iPhone OS"
//   * osVersion: @"2.0"
//   * uniqueId: @"sim:EEAE137F-205A-587E-8F62-C6855680879E" (or a real UDID)
+(NSDictionary*)deviceAttributes;

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

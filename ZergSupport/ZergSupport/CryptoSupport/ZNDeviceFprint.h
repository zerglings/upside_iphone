//
//  ZNDeviceFprint.h
//  ZergSupport
//
//  Created by Victor Costan on 4/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZNDigester.h"

// Produces a fingerprint representing the current device.
//
// The fingerprint is a dictionary including 
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
+(NSData*)copyFprintUsingDigest:(id<ZNDigester>)digestClass;

// The hexadecimal string for the device fingerprint.
+(NSString*)copyHexFprintUsingDigest:(id<ZNDigester>)digestClass;

@end

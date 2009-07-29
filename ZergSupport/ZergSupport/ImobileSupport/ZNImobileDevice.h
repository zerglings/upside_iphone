//
//  ZNImobileDevice.h
//  ZergSupport
//
//  Created by Victor Costan on 7/22/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>


// Data about the iMobile device running on this phone.
@interface ZNImobileDevice : NSObject {
}

// The running application's bundle ID.
//
// This is grabbed from the main bundle's Info.plist. It is shown as "Bundle
// Identifier" in the App Details screen from iTunes Connect.
+(NSString*)appId;

// The running application's provisioning status (how it got on the device).
//
// The following results are possible values:
// * kZNImobileProvisioningSimulatorDebug
// * kZNImobileProvisioningSimulatorRelease
// * kZNImobileProvisioningDeviceDebug
// * kZNImobileProvisioningDeviceRelease
// * kZNImobileProvisioningDeviceDistribution
+(NSUInteger)appProvisioning;

// The application's token for Push Notifications on this device.
+(NSData*)appPushToken;

// The running application's version.
//
// This is grabbed from the main bundle's Info.plist. It is shown as "Bundle
// Version" in the App Details screen from iTunes Connect.
+(NSString*)appVersion;

// The device's hardware model, fetched from the kernel.
//
// Hardware model strings look like iPhone1,2 / iPod2,1 and are much more useful
// than the device name given by UIDevice.
+(NSString*)hardwareModel;

// If YES, the application is running in the simulator.
+(BOOL)inSimulator;

// The name of the device's OS.
//
// Right now, this will always return "iPhone OS".
+(NSString*)osName;

// The version of the device's OS.
//
// Examples: "2.2.1", "3.0".
+(NSString*)osVersion;

// A unique device ID (UDID) normalized across phones and simulators.
//
// The UDID has 40 characters a real iPhone / iPod, but only 36 characters on
// the simulator. To make up for that, simulator UDIDs are padded by "sim:".
+(NSString*)uniqueDeviceId;

@end

// In simulator, debug build (assertions enabled).
const extern NSUInteger kZNImobileProvisioningSimulatorDebug;
// In simulator, release build (assertions disabled, optimizations enabled).
const extern NSUInteger kZNImobileProvisioningSimulatorRelease;
// On real hardware, debug build (assertions enabled).
const extern NSUInteger kZNImobileProvisioningDeviceDebug;
// On real hardware, release build (assertions disabled, optimizations enabled).
const extern NSUInteger kZNImobileProvisioningDeviceRelease;
// On real hardware, distribution build.
// This is the build that ships in the iTunes store.
// It has assertions disabled, optimizations enabled, and talks to Apple's
// production backends for Push Notification and In-App Purchase.
const extern NSUInteger kZNImobileProvisioningDeviceDistribution;

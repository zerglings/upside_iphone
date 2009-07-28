//
//  Device.h
//  StockPlay
//
//  Created by Victor Costan on 1/16/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ModelSupport.h"


// Information about a portable device (iPhone, iPod) running the game.
@interface Device : ZNModel {
  NSString* appId;
  NSString* appProvisioning;
  NSString* appPushToken;
  NSString* appVersion;
  NSString* hardwareModel;
  NSString* osName;
  NSString* osVersion;
  NSString* uniqueId;

  NSUInteger userId;
  NSUInteger modelId;
}
// The application bundle ID (us.costan.StockPlay).
@property (nonatomic, readonly, retain) NSString* appId;
// The application's provisioning method (debug / release / distribution).
@property (nonatomic, readonly, retain) NSString* appProvisioning;
// The token for sending Push Notifications to the application version.
@property (nonatomic, readonly, retain) NSString* appPushToken;
// The application version (e.g. 1.0).
@property (nonatomic, readonly, retain) NSString* appVersion;
// The device's hardware model (e.g. iPhone1,2 or iPod2,1).
@property (nonatomic, readonly, retain) NSString* hardwareModel;
// The the device's OS (e.g. iPhone OS).
@property (nonatomic, readonly, retain) NSString* osName;
// The device's OS version (e.g. 2.2.1).
@property (nonatomic, readonly, retain) NSString* osVersion;
// The device's 40-character UDID.
@property (nonatomic, readonly, retain) NSString* uniqueId;
// The id of this device in the server database.
@property (nonatomic, readonly) NSUInteger modelId;
// The user that the device belongs to.
@property (nonatomic, readonly) NSUInteger userId;

// Creates a Device holding information about the current device.
+(Device*)copyCurrentDevice;

// Returns TRUE if this model accurately represets the device we're running on.
-(BOOL)isEqualToCurrentDevice;

// Copies this device and updates it to represent the device we're running on.
-(Device*)copyAndUpdate;
@end

//
//  RegistrationState.h
//  StockPlay
//
//  Created by Victor Costan on 1/2/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Device;
@class User;

@interface RegistrationState : NSObject {
  Device* deviceInfo;
  User* user;
}

// Device data from the server. Nil if the device is not registered.
@property (nonatomic, retain) Device* deviceInfo;
// The user playing on this device. Nil if the device is not registered.
@property (nonatomic, retain) User* user;

// YES if the device is registered, NO if it needs to be registered.
-(BOOL)isRegistered;

// YES if we have enough information to login the device's user, NO otherwise.
-(BOOL)canLogin;

// YES if the application is activated and can be used.
-(BOOL)isActivated;

// Updates the device information to represent the device we're running on.
-(void)updateDeviceInfo;

# pragma mark Singleton

// The singleton ActivationState instance.
+(RegistrationState*)sharedState;

#pragma mark I/O

// Archives state into an NSData instance.
-(NSData*)archiveToData;

// Restores previously archived state from an NSData instance.
-(void)unarchiveFromData:(NSData*)data;

// Saves state on disk.
-(void)save;

// Loads state from disk.
-(void)load;

// Removes the state saved on disk. Intended for testing.
+(void)removeSavedState;

@end

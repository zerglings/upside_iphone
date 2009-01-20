//
//  Device.h
//  upside
//
//  Created by Victor Costan on 1/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ModelSupport.h"

@interface Device : ZNModel {
	NSUInteger modelId;
	NSUInteger userId;
	NSString* uniqueId;
}

// The id of this device in the server database.
@property (nonatomic, readonly) NSUInteger modelId;
// The user that the device belongs to.
@property (nonatomic, readonly) NSUInteger userId;
// The device's 40-character UDID.
@property (nonatomic, readonly, retain) NSString* uniqueId;

// Wraps UIDevice, adjusting simulator IDs to be 40-characters. 
+ (NSString*) currentDeviceId;

@end

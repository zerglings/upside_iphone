//
//  Device.m
//  StockPlay
//
//  Created by Victor Costan on 1/16/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "Device.h"

#import "CryptoSupport.h"


@implementation Device

@synthesize modelId, userId;
@synthesize appId, appProvisioning, appPushToken, appVersion, hardwareModel;
@synthesize osName, osVersion, uniqueId;

-(void)dealloc {
  [uniqueId release];
  [super dealloc];
}

+(Device*)copyCurrentDevice {
  NSDictionary* attributes = [ZNAppFprint copyDeviceAttributes];
  Device* returnValue = [[Device alloc] initWithProperties:attributes];
  [attributes release];
  return returnValue;
}

-(BOOL)isEqualToCurrentDevice {
  NSDictionary* attributes = [ZNAppFprint copyDeviceAttributes];
  BOOL returnValue =
      [uniqueId isEqualToString:[attributes objectForKey:@"uniqueId"]] &&
      [hardwareModel isEqualToString:[attributes
                                      objectForKey:@"hardwareModel"]] &&
      [osName isEqualToString:[attributes objectForKey:@"osName"]] &&
      [osVersion isEqualToString:[attributes objectForKey:@"osVersion"]] &&
      [appId isEqualToString:[attributes objectForKey:@"appId"]] &&  
      [appProvisioning isEqualToString:[attributes
                                        objectForKey:@"appProvisioning"]] &&  
      [appPushToken isEqualToString:[attributes
                                     objectForKey:@"appPushToken"]] &&  
      [appVersion isEqualToString:[attributes objectForKey:@"appVersion"]];
  [attributes release];
  return returnValue;
}

-(Device*)copyAndUpdate {
  Device *currentDevice = [Device copyCurrentDevice];
  Device* returnValue =
      [[Device alloc] initWithModel:self
                         properties:[currentDevice
                                     attributeDictionaryForcingStrings:NO]];
  [currentDevice release];
  return returnValue;
}
@end

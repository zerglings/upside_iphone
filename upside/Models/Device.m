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
@synthesize uniqueId, hardwareModel, osName, osVersion, appVersion;

-(void)dealloc {
	[uniqueId release];
	[super dealloc];
}

+(Device*)copyCurrentDevice {
  return [[Device alloc] initWithProperties:[ZNDeviceFprint deviceAttributes]];
}

-(BOOL)isEqualToCurrentDevice {
  NSDictionary* attributes = [ZNDeviceFprint deviceAttributes];  
  return [uniqueId isEqualToString:[attributes objectForKey:@"uniqueId"]] &&
      [hardwareModel isEqualToString:[attributes
                                      objectForKey:@"hardwareModel"]] &&
      [osName isEqualToString:[attributes objectForKey:@"osName"]] &&
      [osVersion isEqualToString:[attributes objectForKey:@"osVersion"]] &&
      [appVersion isEqualToString:[attributes objectForKey:@"appVersion"]];
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

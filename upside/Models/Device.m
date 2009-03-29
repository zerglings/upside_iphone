//
//  Device.m
//  StockPlay
//
//  Created by Victor Costan on 1/16/09.
//  Copyright Zergling.Net. All rights reserved.
//

#include <sys/types.h>
#include <sys/sysctl.h>

#import "Device.h"

@implementation Device

@synthesize modelId, userId;
@synthesize uniqueId, hardwareModel, osName, osVersion, appVersion;

-(void)dealloc {
	[uniqueId release];
	[super dealloc];
}



+(NSString*)currentDeviceId {
	NSString* udid = [[UIDevice currentDevice] uniqueIdentifier];
	if ([udid length] == 40)
		return udid;
	return [NSString stringWithFormat:@"sim:%@", udid];
}

+(NSString*)currentHardwareModel {
  size_t keySize;
  sysctlbyname("hw.machine", NULL, &keySize, NULL, 0);
  char *key = malloc(keySize);
  sysctlbyname("hw.machine", key, &keySize, NULL, 0);
  NSString *hardwareModel = [NSString stringWithCString:key
                                               encoding:NSUTF8StringEncoding];
  free(key);
  return hardwareModel;
}
+(NSString*)currentOsName {
  return [[UIDevice currentDevice] systemName];
}
+(NSString*)currentOsVersion {
  return [[UIDevice currentDevice] systemVersion];
}
+(NSString*)currentAppVersion {
  return [[NSBundle mainBundle]
          objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
}

+(Device*)copyCurrentDevice {
  return [[Device alloc] initWithProperties:
          [NSDictionary dictionaryWithObjectsAndKeys:
           [Device currentDeviceId], @"uniqueId",
           [Device currentHardwareModel], @"hardwareModel",
           [Device currentOsName], @"osName",
           [Device currentOsVersion], @"osVersion",
           [Device currentAppVersion], @"appVersion",
           nil]];
}

-(BOOL)isEqualToCurrentDevice {
  return [uniqueId isEqualToString:[Device currentDeviceId]] &&
      [hardwareModel isEqualToString:[Device currentHardwareModel]] &&
      [osName isEqualToString:[Device currentOsName]] &&
      [osVersion isEqualToString:[Device currentOsVersion]] &&
      [appVersion isEqualToString:[Device currentAppVersion]];
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

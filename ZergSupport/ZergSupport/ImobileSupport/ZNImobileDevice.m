//
//  ZNImobileDevice.m
//  ZergSupport
//
//  Created by Victor Costan on 7/22/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNImobileDevice.h"

#include <mach-o/dyld.h>
#include <sys/types.h>
#include <sys/sysctl.h>

#import <TargetConditionals.h>
#import <UIKit/UIKit.h>
#import "ZNPushNotifications.h"


@interface ZNImobileDevice ()
+(NSUInteger)appProvisioningInSimulator:(BOOL)inSimulator
                                inDebug:(BOOL)inDebug
                        encryptedBinary:(BOOL)encryptedBinary;
+(BOOL)isEncryptedBinary:(NSString*)path;
@end


@implementation ZNImobileDevice

+(NSString*)uniqueDeviceId {
  NSString* udid = [[UIDevice currentDevice] uniqueIdentifier];
#if TARGET_IPHONE_SIMULATOR
  return [NSString stringWithFormat:@"sim:%@", udid];
#else  // TARGET_IPHONE_SIMULATOR
  return udid;
#endif  // TARGET_IPHONE_SIMULATOR
}

+(NSString*)hardwareModel {
  // NOTE: This method is not well covered by unit tests, because I couldn't
  //       figure out a good golden value. I could hard-code the golden value
  //       to "i386" (what the simulator returns) but that would cause tests to
  //       fail on a device. On the bright side, the method is unlikely to
  //       change, because it relies on OSX kernel functionality.

  size_t keySize;
  sysctlbyname("hw.machine", NULL, &keySize, NULL, 0);
  char *key = malloc(keySize);
  sysctlbyname("hw.machine", key, &keySize, NULL, 0);
  NSString *hardwareModel = [NSString stringWithCString:key
                                               encoding:NSUTF8StringEncoding];
  free(key);
  return hardwareModel;
}

+(NSString*)appVersion {
  return [[NSBundle mainBundle]
          objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
}

+(NSString*)appId {
  return [[NSBundle mainBundle]
          objectForInfoDictionaryKey:(NSString*)kCFBundleIdentifierKey];
}

+(NSUInteger)appProvisioning {
  BOOL inSimulator = [ZNImobileDevice inSimulator];

#if defined(DEBUG) || (!defined(NS_BLOCK_ASSERTIONS) && !defined(NDEBUG))
  BOOL inDebug = YES;
#else
  BOOL inDebug = NO;
#endif

  BOOL encryptedBinary = [self isEncryptedBinary:[[NSBundle mainBundle]
                                                   executablePath]];
  return [self appProvisioningInSimulator:inSimulator
                                  inDebug:inDebug
                          encryptedBinary:encryptedBinary];
}

+(NSUInteger)appProvisioningInSimulator:(BOOL)inSimulator
                                inDebug:(BOOL)inDebug
                        encryptedBinary:(BOOL)encryptedBinary {
  if (inSimulator) {
    return inDebug ?  kZNImobileProvisioningSimulatorDebug :
        kZNImobileProvisioningSimulatorRelease;
  }
  if (encryptedBinary) {
    return kZNImobileProvisioningDeviceDistribution;
  }
  return inDebug ? kZNImobileProvisioningDeviceDebug :
      kZNImobileProvisioningDeviceRelease;
}

+(BOOL)inSimulator {
#if TARGET_IPHONE_SIMULATOR
  return YES;
#else  // TARGET_IPHONE_SIMULATOR
  return NO;
#endif  // TARGET_IPHONE_SIMULATOR
}

+(NSData*)appPushToken {
  return [ZNPushNotifications pushToken];
}

+(NSString*)osName {
  return [[UIDevice currentDevice] systemName];
}

+(NSString*)osVersion {
  return [[UIDevice currentDevice] systemVersion];
}

#pragma mark Binary Encryption Detection

#if !defined(LC_ENCRYPTION_INFO)
#define  LC_ENCRYPTION_INFO 0x21
struct encryption_info_command {
  uint32_t  cmd;
  uint32_t  cmdsize;
  uint32_t  cryptoff;
  uint32_t  cryptsize;
  uint32_t  cryptid;
};
#endif  // LC_ENCRYPTION_INFO

+(BOOL)isEncryptedBinary:(NSString*)path {
  BOOL foundEncryptionInfo = NO;

  NSFileHandle* fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];

  // Read the Mach-O header to find out how many loader commands.
  NSData* headerData = [fileHandle readDataOfLength:sizeof(struct mach_header)];
  if ([headerData length] != sizeof(struct mach_header)) {
    return NO;  // Not a Mach-O binary.
  }
  const struct mach_header* header = (const struct mach_header*)[headerData
                                                                 bytes];
  uint32_t numCommands = header->ncmds;

  // Read through loader commands, looking for encryption signs.
  unsigned long long fileOffset = sizeof(struct mach_header);
  for(NSUInteger i = 0; i < numCommands; i++) {
    // Read command header.
    NSData* commandData = [fileHandle
                           readDataOfLength:sizeof(struct load_command)];
    if ([commandData length] != sizeof(struct load_command)) {
      return NO;  // Not a Mach-O binary.
    }
    const struct load_command* command =
        (const struct load_command*)[commandData bytes];
    uint32_t commandSize = command->cmdsize;

    if (command->cmd == LC_ENCRYPTION_INFO) {
      // Patch in the rest of the loader command.
      struct encryption_info_command encryption_command;
      memcpy(&encryption_command, command, sizeof(struct load_command));
      NSAssert2(sizeof(encryption_command) <= commandSize,
                @"LC_ENCRYPTION_INFO command does not match struct "
                @"encryption_info_command (expected size %d actual size %d)",
                sizeof(encryption_command), commandSize);
      NSUInteger fragmentLength = sizeof(encryption_command) -
          sizeof(struct load_command);
      NSData* fragmentData = [fileHandle readDataOfLength:fragmentLength];
      if ([fragmentData length] != fragmentLength) {
        return NO;
      }
      memcpy((uint8_t*)&encryption_command + sizeof(struct load_command),
             [fragmentData bytes], fragmentLength);

      // Is encryption active?
      if (encryption_command.cryptid < 1) {
        return NO;
      }
      foundEncryptionInfo = YES;
    }

    fileOffset += commandSize;
    [fileHandle seekToFileOffset:fileOffset];
  }

  [fileHandle closeFile];
  return foundEncryptionInfo;
}

#pragma mark Constants

const NSUInteger kZNImobileProvisioningSimulatorDebug = 1;
const NSUInteger kZNImobileProvisioningSimulatorRelease = 2;
const NSUInteger kZNImobileProvisioningDeviceDebug = 3;
const NSUInteger kZNImobileProvisioningDeviceRelease = 4;
const NSUInteger kZNImobileProvisioningDeviceDistribution = 5;

@end

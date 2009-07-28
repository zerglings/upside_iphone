//
//  RegistrationState.m
//  StockPlay
//
//  Created by Victor Costan on 1/2/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "RegistrationState.h"

#import "Device.h"
#import "User.h"

@implementation RegistrationState

# pragma mark I/O

// Key for the device information.
static NSString* kDeviceInfo = @"deviceInfo";
// Key for the current user.
static NSString* kUser = @"user";

static NSString* kStateFileName = @".ActivationState";

-(NSData*)archiveToData {
  if (!deviceInfo)
    return nil;

  NSMutableData* stateData = [NSMutableData data];
  NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]
                 initForWritingWithMutableData:stateData];
  [archiver encodeObject:[deviceInfo attributeDictionaryForcingStrings:NO]
          forKey:kDeviceInfo];
  if (user != nil) {
    [archiver encodeObject:[user attributeDictionaryForcingStrings:NO]
            forKey:kUser];
  }
  [archiver finishEncoding];
  [archiver release];

  return stateData;
}

-(void)unarchiveFromData:(NSData*)data {
  [deviceInfo release];
  deviceInfo = nil;
  [user release];
  user = nil;

  if (!data)
    return;

  NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]
                   initForReadingWithData:data];
  NSDictionary* deviceProperties = [unarchiver
                    decodeObjectForKey:kDeviceInfo];
  if (deviceProperties)
    deviceInfo = [[Device alloc] initWithProperties:deviceProperties];

  NSDictionary* userProperties = [unarchiver
                  decodeObjectForKey:kUser];
  if (userProperties)
    user = [[User alloc] initWithProperties:userProperties];
  [unarchiver release];
}

+(NSString*)filePath {
  NSArray* docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                              NSUserDomainMask,
                              YES);
  return [[docPaths objectAtIndex:0]
      stringByAppendingPathComponent:kStateFileName];
}

-(void)load {
  NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
  if ([defaults boolForKey:@"reset_activation"]) {
    [defaults setBool:NO forKey:@"reset_activation"];
    [defaults synchronize];
    [RegistrationState removeSavedState];
  }

  NSData* data = [NSData dataWithContentsOfFile:[RegistrationState filePath]];
  [self unarchiveFromData:data];
}

-(void)save {
  NSData* data = [self archiveToData];
  if (!data) {
    [[NSFileManager defaultManager]
     removeItemAtPath:[RegistrationState filePath] error:nil];
  }
  else {
    [data writeToFile:[RegistrationState filePath] atomically:YES];
  }
}

+(void)removeSavedState {
  [[NSFileManager defaultManager] removeItemAtPath:[RegistrationState filePath]
                         error:nil];
}

# pragma mark Lifecycle

-(id)init {
  if ((self = [super init])) {
    [self load];
  }
  return self;
}

-(void)dealloc {
  [deviceInfo release];
  [user release];
  [super dealloc];
}

@synthesize deviceInfo, user;

-(BOOL)isRegistered {
  return deviceInfo != nil;
}

-(BOOL)canLogin {
  return [user password] != nil;
}

-(BOOL)isActivated {
  return [self isRegistered] && [self canLogin];
}


-(void)setDeviceInfo:(Device*)theDeviceInfo {
  NSAssert(deviceInfo == nil, @"Trying to register twice");
  NSAssert(theDeviceInfo != nil, @"Trying to register with nil device");

  [theDeviceInfo retain];
  [deviceInfo release];
  deviceInfo = theDeviceInfo;
}

-(void)updateDeviceInfo {
  NSAssert(deviceInfo != nil, @"Not registered yet");
  if ([deviceInfo isEqualToCurrentDevice])
    return;

  Device* newDeviceInfo = [deviceInfo copyAndUpdate];
  [deviceInfo release];
  deviceInfo = newDeviceInfo;
  [self save];
}

#pragma mark Singleton

static RegistrationState* sharedState = nil;

+(RegistrationState*)sharedState {
  @synchronized(self) {
    if (sharedState == nil) {
      sharedState = [[RegistrationState alloc] init];
    }
  }
  return sharedState;
}

@end

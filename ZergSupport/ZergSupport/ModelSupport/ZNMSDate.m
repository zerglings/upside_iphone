//
//  NZMSDate.m
//  ZergSupport
//
//  Created by Victor Costan on 1/14/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNMSDate.h"

#import "ZNModelDefinitionAttribute.h"

@implementation ZNMSDate

#pragma mark Lifecycle

-(id)init {
  if ((self = [super init])) {
    osxFormatter = [[NSDateFormatter alloc] init];
    [osxFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [osxFormatter setLenient:YES];
    osxFormatter2 = [[NSDateFormatter alloc] init];
    [osxFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
    [osxFormatter2 setLenient:YES];
    railsFormatter = [[NSDateFormatter alloc] init];
    [railsFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    [railsFormatter setLenient:YES];
    rssFormatter = [[NSDateFormatter alloc] init];
    [rssFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
    [rssFormatter setLenient:YES];
  }
  return self;
}

-(void)dealloc {
  [osxFormatter release];
  [osxFormatter2 release];
  [railsFormatter release];
  [rssFormatter release];
  [super dealloc];
}

#pragma mark Boxing

-(NSObject*)copyBoxedAttribute:(ZNModelDefinitionAttribute*)attribute
                    inInstance:(ZNModel*)instance
                   forceString:(BOOL)forceString {
  NSDate* date = object_getIvar(instance, [attribute runtimeIvar]);
  if (forceString)
    return [[osxFormatter stringFromDate:date] retain];
  else
    return [date retain];
}

-(void)unboxAttribute:(ZNModelDefinitionAttribute*)attribute
           inInstance:(ZNModel*)instance
                 from:(NSObject*)boxedObject {
  NSDate* date;
  if ([boxedObject isKindOfClass:[NSString class]]) {
    date = [osxFormatter dateFromString:(NSString*)boxedObject];
    if (!date) {
      date = [osxFormatter2 dateFromString:(NSString*)boxedObject];
    }
    if (!date) {
      date = [railsFormatter dateFromString:(NSString*)boxedObject];
    }
    if (!date) {
      date = [rssFormatter dateFromString:(NSString*)boxedObject];
    }
  }
  else if ([boxedObject isKindOfClass:[NSDate class]]) {
    date = (NSDate*)boxedObject;
  }
  else if ([boxedObject isKindOfClass:[NSNull class]]) {
    date = nil;
  }
  else {
    date = nil;
  }

  Ivar runtimeIvar = [attribute runtimeIvar];
  switch ([attribute setterStrategy]) {
    case kZNPropertyWantsCopy: {
      date = [date copy];
      NSDate* oldDate = object_getIvar(instance, runtimeIvar);
      [oldDate release];
      break;
    }
    case kZNPropertyWantsRetain: {
      [date retain];
      NSDate* oldDate = object_getIvar(instance, runtimeIvar);
      [oldDate release];
      break;
    }
    case kZNPropertyWantsAssign:
      break;
    default:
      NSAssert(NO, @"Unknown attribute setter strategy");
  }
  object_setIvar(instance, runtimeIvar, date);
}

@end

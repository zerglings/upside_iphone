//
//  ZNMSAttributeTypes.m
//  ZergSupport
//
//  Created by Victor Costan on 1/14/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNMSRegistry.h"

#import <objc/runtime.h>

#import "ZNModelDefinition.h"
#import "ZNMSBoolean.h"
#import "ZNMSData.h"
#import "ZNMSDate.h"
#import "ZNMSDouble.h"
#import "ZNMSInteger.h"
#import "ZNMSString.h"
#import "ZNMSUInteger.h"

@implementation ZNMSRegistry

@synthesize booleanType, doubleType, integerType, uintegerType;
@synthesize dataType, dateType, stringType;

#pragma mark Lifecycle

-(id)init {
  if ((self = [super init])) {
    modelDefinitions = [[NSMutableDictionary alloc] init];

    booleanType = [[ZNMSBoolean alloc] init];
    dataType = [[ZNMSData alloc] init];
    dateType = [[ZNMSDate alloc] init];
    doubleType = [[ZNMSDouble alloc] init];
    integerType = [[ZNMSInteger alloc] init];
    stringType = [[ZNMSString alloc] init];
    uintegerType = [[ZNMSUInteger alloc] init];
  }
  return self;
}

-(void)dealloc {
  [modelDefinitions release];

  [booleanType release];
  [dataType release];
  [dateType release];
  [doubleType release];
  [integerType release];
  [stringType release];
  [uintegerType release];

  [super dealloc];
}

#pragma mark Model Definition Registry

-(ZNModelDefinition*)definitionForModelClass:(Class)klass {
  // TODO(overmind): There has to be a faster way.
  const char* classNameCString = class_getName(klass);
  NSString* className = [[NSString alloc] initWithBytes:classNameCString
                                                 length:strlen(classNameCString)
                                               encoding:NSASCIIStringEncoding];

  ZNModelDefinition* definition;
  @synchronized (self) {
    definition = [modelDefinitions objectForKey:className];
    if (!definition) {
      definition = [ZNModelDefinition newDefinitionForClass:klass];
      [modelDefinitions setObject:definition forKey:className];
      [definition release];
    }
  }
  [className release];
  return definition;
}

-(ZNModelDefinition*)definitionForModelClassNamed:(NSString*)className {
  ZNModelDefinition* definition;
  @synchronized (self) {
    definition = [modelDefinitions objectForKey:className];
    if (!definition) {
      Class klass = objc_getClass([className UTF8String]);
      definition = [ZNModelDefinition newDefinitionForClass:klass];
      [modelDefinitions setObject:definition forKey:className];
      [definition release];
    }
  }
  return definition;
}

#pragma mark Singleton

static ZNMSRegistry* sharedInstance = nil;

+(ZNMSRegistry*)sharedRegistry {
  @synchronized ([ZNMSRegistry class]) {
    if (sharedInstance == nil) {
      sharedInstance = [[ZNMSRegistry alloc] init];
    }
  }
  return sharedInstance;
}

@end

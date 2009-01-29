//
//  Model.h
//  upside
//
//  Created by Victor Costan on 1/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Base class for the models using ModelSupport.
@interface ZNModel : NSObject {
	NSDictionary* props;
}

@property (nonatomic, readonly) NSDictionary* supplementalProperties;

#pragma mark Initializers

// Designated initializer.
- (id) initWithModel: (ZNModel*)model properties: (NSDictionary*)dictionary;

- (id) initWithProperties: (NSDictionary*)dictionary;

- (id) initWithModel: (ZNModel*)model;

#pragma mark Saving Attributes

- (NSDictionary*) copyToDictionaryForcingStrings: (BOOL)forceStrings;

- (NSMutableDictionary*)
copyToMutableDictionaryForcingStrings: (BOOL)forceStrings;

- (NSDictionary*) attributeDictionaryForcingStrings: (BOOL)forceStrings;

- (NSMutableDictionary*)
attributeMutableDictionaryForcingStrings: (BOOL)forceStrings;

#pragma mark Dynamic Instantiation

+ (BOOL) isModelClass: (id)maybeModelClass;

@end

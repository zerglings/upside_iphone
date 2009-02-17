//
//  Model.h
//  ZergSupport
//
//  Created by Victor Costan on 1/14/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

// Base class for the models using ModelSupport.
@interface ZNModel : NSObject {
	NSDictionary* props;
}

@property (nonatomic, readonly) NSDictionary* supplementalProperties;

#pragma mark Initializers

// Designated initializer.
-(id)initWithModel:(ZNModel*)model properties:(NSDictionary*)dictionary;

-(id)initWithProperties:(NSDictionary*)dictionary;

-(id)initWithModel:(ZNModel*)model;

#pragma mark Saving Attributes

-(NSDictionary*)copyToDictionaryForcingStrings:(BOOL)forceStrings;

-(NSMutableDictionary*)copyToMutableDictionaryForcingStrings:(BOOL)forceStrings;

-(NSDictionary*)attributeDictionaryForcingStrings:(BOOL)forceStrings;

-(NSMutableDictionary*)attributeMutableDictionaryForcingStrings:(BOOL)forceStrings;

#pragma mark Dynamic Instantiation

+(BOOL)isModelClass:(id)maybeModelClass;

+(NSArray*)allModelClasses;

@end

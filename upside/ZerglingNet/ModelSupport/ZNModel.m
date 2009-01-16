//
//  Model.m
//  upside
//
//  Created by Victor Costan on 1/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ZNModel.h"

#import "ZNModelDefinition.h"
#import "ZNModelDefinitionAttribute.h"
#import "ZNMSAttributeType.h"
#import "ZNMSRegistry.h"

@interface ZNModel ()
- (void) loadFromDictionary: (NSDictionary*)dictionary;
@end


@implementation ZNModel

@synthesize supplementalProperties = props;

#pragma mark Lifecycle

- (id) initWithProperties: (NSDictionary*)dictionary {
	if ((self = [super init])) {
		props = nil;
		[self loadFromDictionary:dictionary];
	}
	return self;
}

- (id) initWithModel: (ZNModel*)model {
	NSMutableDictionary* modelAttributes =
	    [model copyToMutableDictionaryForcingStrings:NO];
	id returnModel = [self initWithProperties:modelAttributes];
	[modelAttributes release];
	return returnModel;
}

- (void) dealloc {
	[props release];
	[super dealloc];
}

#pragma mark Boxing

- (void) loadFromDictionary: (NSDictionary*)dictionary {
	NSMutableDictionary* supplementalProps = [[NSMutableDictionary alloc] init];

	ZNModelDefinition* definition = [[ZNMSRegistry sharedRegistry]
									 definitionForModelClass:[self class]];
	NSDictionary* defAttributes = [definition attributes];
	for(NSString* attributeName in dictionary) {
		NSObject* boxedObject = [dictionary objectForKey:attributeName];
		ZNModelDefinitionAttribute* attribute = [defAttributes
												 objectForKey:attributeName];
		if (attribute) {
			ZNMSAttributeType* attributeType = [attribute type];
			[attributeType unboxAttribute:attribute
							   inInstance:self
									 from:boxedObject];
		}
		else {
			[supplementalProps setObject:boxedObject forKey:attributeName];
		}
	}
	
}



- (NSMutableDictionary*)
copyToMutableDictionaryForcingStrings: (BOOL)forceStrings {
	NSMutableDictionary* attributes = [[NSMutableDictionary alloc]
						 			   initWithDictionary:props];
	ZNModelDefinition* definition = [[ZNMSRegistry sharedRegistry]
									 definitionForModelClass:[self class]];
	
	NSDictionary* defAttributes = [definition attributes];
	for (NSString* attributeName in defAttributes) {
		ZNModelDefinitionAttribute* attribute = [defAttributes
												 objectForKey:attributeName];
		ZNMSAttributeType* attributeType = [attribute type];
		NSObject* boxedValue = [attributeType boxAttribute:attribute															  
												inInstance:self
											   forceString:forceStrings];
		[attributes setObject:boxedValue forKey:attributeName];
	}
	return attributes;
}

- (NSDictionary*) copyToDictionaryForcingStrings: (BOOL)forceStrings {
	NSMutableDictionary* attributes =
	    [self copyToMutableDictionaryForcingStrings:forceStrings];
	
	NSDictionary* dictionary = [[NSDictionary alloc]
								initWithDictionary:attributes];
	[attributes release];
	return dictionary;
}

- (NSDictionary*) attributeDictionaryForcingStrings: (BOOL)forceStrings {
	return [[self copyToDictionaryForcingStrings:forceStrings] autorelease];
}

- (NSMutableDictionary*)
attributeMutableDictionaryForcingStrings: (BOOL)forceStrings {
	return [[self copyToMutableDictionaryForcingStrings:forceStrings]
			autorelease];
}

#pragma mark Debugging

- (NSString*) description {
	return [NSString stringWithFormat:@"<ZNModel name=%s attributes=%@>",
			class_getName([self class]),
			[[self attributeDictionaryForcingStrings:YES] description]];
}

@end

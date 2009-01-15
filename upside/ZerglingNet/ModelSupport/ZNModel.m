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

@implementation ZNModel

@synthesize supplementalProperties = props;

- (id) initWithProperties: (NSDictionary*)dictionary {
	if ((self = [super init])) {
		props = nil;
		[self loadFromDictionary:dictionary];
	}
	return self;
}

- (void) dealloc {
	[props release];
	[super dealloc];
}

- (void) loadFromDictionary: (NSDictionary*)dictionary {
	
}

- (NSDictionary*) copyToDictionaryForcingStrings: (BOOL)forceStrings {
	NSMutableDictionary* attributes = [[NSMutableDictionary alloc]
						 			   initWithDictionary:props];
	ZNModelDefinition* definition = [[ZNMSRegistry sharedRegistry]
									 definitionForModelClass:[self class]];
	
	NSDictionary* defAttributes = [definition attributes];
	for (NSString* attributeName in defAttributes) {
		ZNModelDefinitionAttribute* attribute = [defAttributes
												 objectForKey:attributeName];
		ZNMSAttributeType* attributeType = [attribute type];
		NSObject* boxedValue = [attributeType boxInstanceVar:[attribute
															  runtimeIvar]
												  inInstance:self
												 forceString:forceStrings];
		[attributes setObject:boxedValue forKey:attributeName];
	}
	NSDictionary* dictionary = [[NSDictionary alloc]
								initWithDictionary:attributes];
	[attributes release];
	return dictionary;
}

@end

//
//  ZNMSAttributeTypes.h
//  upside
//
//  Created by Victor Costan on 1/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZNModelDefinition;
@class ZNMSAttributeType;

@interface ZNMSRegistry : NSObject {
	ZNMSAttributeType* dateType;
	ZNMSAttributeType* doubleType;
	ZNMSAttributeType* integerType;
	ZNMSAttributeType* stringType;
	ZNMSAttributeType* uintegerType;
	
	NSMutableDictionary* modelDefinitions;
}

@property (nonatomic, readonly) ZNMSAttributeType* dateType;
@property (nonatomic, readonly) ZNMSAttributeType* doubleType;
@property (nonatomic, readonly) ZNMSAttributeType* integerType;
@property (nonatomic, readonly) ZNMSAttributeType* stringType;
@property (nonatomic, readonly) ZNMSAttributeType* uintegerType;

- (ZNModelDefinition*) definitionForModelClass: (Class)klass;

- (ZNModelDefinition*) definitionForModelClassNamed: (NSString*)className;

// The singleton ZNMSRegistry instance.
+ (ZNMSRegistry*) sharedRegistry;

@end

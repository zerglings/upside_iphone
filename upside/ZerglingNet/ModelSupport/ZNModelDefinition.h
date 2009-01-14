//
//  ZNModelDefinition.h
//  upside
//
//  Created by Victor Costan on 1/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZNModelDefinitionAttribute;

@interface ZNModelDefinition : NSObject {
	NSString* name;
	NSDictionary* attributes;
}

@property (nonatomic, readonly, retain) NSString* name;
@property (nonatomic, readonly, retain) NSDictionary* attributes;

- (ZNModelDefinitionAttribute*) attributeNamed: (NSString*)name;

+ (ZNModelDefinition*) definitionForClass: (Class)klass;

@end

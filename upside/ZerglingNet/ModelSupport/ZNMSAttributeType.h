//
//  ZNAttributeType.h
//  upside
//
//  Created by Victor Costan on 1/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <objc/runtime.h>

@class ZNModel;
@class ZNModelDefinitionAttribute;

@interface ZNMSAttributeType : NSObject {

}

- (NSObject*) boxAttribute: (ZNModelDefinitionAttribute*)attribute
				inInstance: (ZNModel*)instance
			   forceString: (BOOL)forceString;

- (void) unboxAttribute: (ZNModelDefinitionAttribute*)attribute
			 inInstance: (ZNModel*)instance
				   from: (NSObject*)boxedObject;

+ (ZNMSAttributeType*) newTypeFromString: (const char*)encodedType;

@end

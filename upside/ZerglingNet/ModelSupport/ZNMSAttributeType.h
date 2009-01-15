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

@interface ZNMSAttributeType : NSObject {

}

- (NSObject*) boxInstanceVar: (Ivar)instanceVar
				  inInstance: (ZNModel*)instance
			     forceString: (BOOL)forceString;

- (void) unboxInstanceVar: (Ivar)instanceVar
			   inInstance: (ZNModel*)instance
					 from: (NSObject*)boxedObject;

+ (ZNMSAttributeType*) newTypeFromString: (const char*)encodedType;

@end

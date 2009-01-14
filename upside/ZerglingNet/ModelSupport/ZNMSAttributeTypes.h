//
//  ZNMSAttributeTypes.h
//  upside
//
//  Created by Victor Costan on 1/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZNMSAttributeType.h"

@interface ZNMSAttributeTypes : NSObject {
	ZNMSAttributeType* dateType;
	ZNMSAttributeType* doubleType;
	ZNMSAttributeType* integerType;
	ZNMSAttributeType* stringType;
	ZNMSAttributeType* uintegerType;
}

@property (nonatomic, readonly) ZNMSAttributeType* dateType;
@property (nonatomic, readonly) ZNMSAttributeType* doubleType;
@property (nonatomic, readonly) ZNMSAttributeType* integerType;
@property (nonatomic, readonly) ZNMSAttributeType* stringType;
@property (nonatomic, readonly) ZNMSAttributeType* uintegerType;

+ (ZNMSAttributeTypes*) sharedInstance;

@end

@interface ZNMSAttributeType (Types)

+ (ZNMSAttributeType*) newTypeFromString: (const char*)encodedType;

@end

//
//  ZNAttributeType.m
//  upside
//
//  Created by Victor Costan on 1/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ZNMSAttributeType.h"

#import "ZNMSRegistry.h"


@implementation ZNMSAttributeType

+ (ZNMSAttributeType*) newTypeFromString: (const char*)encodedType {
	switch (*encodedType) {
		case '@':
			encodedType++;
			if (*encodedType == '"') {
				// class following the type
				if (!strncmp(encodedType, "\"NSString\"", 10))
					return [[ZNMSRegistry sharedRegistry] stringType];
				else if (!strncmp(encodedType, "\"NSDate\"", 8))
					return [[ZNMSRegistry sharedRegistry] dateType];
				else
					return nil;
			}
			else
				return [[ZNMSRegistry sharedRegistry] stringType];
		case 'd':
			return [[ZNMSRegistry sharedRegistry] doubleType];
		case 'i':
			return [[ZNMSRegistry sharedRegistry] integerType];
		case 'I':
			return [[ZNMSRegistry sharedRegistry] uintegerType];
		default:
			return nil;
	}
}

@end

//
//  ZNMSAttributeTypes.m
//  upside
//
//  Created by Victor Costan on 1/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ZNMSAttributeTypes.h"

#import "ZNMSDate.h"
#import "ZNMSDouble.h"
#import "ZNMSInteger.h"
#import "ZNMSString.h"
#import "ZNMSUInteger.h"


@implementation ZNMSAttributeType (Types)

+ (ZNMSAttributeType*) newTypeFromString: (const char*)encodedType {
	switch (*encodedType) {
		case '@':
			encodedType++;
			if (*encodedType == '"') {
				// class following the type
				if (!strncmp(encodedType, "\"NSString\"", 10))
					return [[ZNMSAttributeTypes sharedInstance] stringType];
				else if (!strncmp(encodedType, "\"NSDate\"", 8))
					return [[ZNMSAttributeTypes sharedInstance] dateType];
				else
					return nil;
			}
			else
				return [[ZNMSAttributeTypes sharedInstance] stringType];
		case 'd':
			return [[ZNMSAttributeTypes sharedInstance] doubleType];
		case 'i':
			return [[ZNMSAttributeTypes sharedInstance] integerType];
		case 'I':
			return [[ZNMSAttributeTypes sharedInstance] uintegerType];
		default:
			return nil;
	}
}

@end


@implementation ZNMSAttributeTypes

@synthesize dateType, doubleType, integerType, stringType, uintegerType;

#pragma mark Lifecycle

- (id) init {
	if ((self = [super init])) {
		dateType = [[ZNMSDate alloc] init];
		doubleType = [[ZNMSDouble alloc] init];
		integerType = [[ZNMSInteger alloc] init];
		stringType = [[ZNMSString alloc] init];
		uintegerType = [[ZNMSUInteger alloc] init];
	}
	return self;
}

- (void) dealloc {
	[dateType release];
	[doubleType release];
	[integerType release];
	[stringType release];
	[uintegerType release];
	
	[super dealloc];
}

#pragma mark Singleton

static ZNMSAttributeTypes* sharedInstance = nil;

+ (ZNMSAttributeTypes*) sharedInstance {
	@synchronized ([ZNMSAttributeTypes class]) {
		if (sharedInstance == nil) {
			sharedInstance = [[ZNMSAttributeTypes alloc] init];
		}
	}
	return sharedInstance;
}

@end

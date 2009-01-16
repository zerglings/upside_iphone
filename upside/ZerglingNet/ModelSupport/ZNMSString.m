//
//  ZNMSString.m
//  upside
//
//  Created by Victor Costan on 1/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ZNMSString.h"

#import "ZNModelDefinitionAttribute.h"

@implementation ZNMSString

#pragma mark Boxing

- (NSObject*) boxAttribute: (ZNModelDefinitionAttribute*)attribute
				inInstance: (ZNModel*)instance
			   forceString: (BOOL)forceString {
	NSString* string = object_getIvar(instance, [attribute runtimeIvar]);
	return string;
}

- (void) unboxAttribute: (ZNModelDefinitionAttribute*)attribute
		 	 inInstance: (ZNModel*)instance
			       from: (NSObject*)boxedObject {
	NSString* string;
	if ([boxedObject isKindOfClass:[NSString class]])
		string = (NSString*)boxedObject;
	else
		string = [boxedObject description];
	
	switch ([attribute setterStrategy]) {
		case kZNPropertyWantsCopy:
			string = [string copy];
			break;
		case kZNPropertyWantsRetain:
			string = [string retain];
			break;
	}
	object_setIvar(instance, [attribute runtimeIvar], string);
}

@end

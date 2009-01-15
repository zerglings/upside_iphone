//
//  NZMSDate.m
//  upside
//
//  Created by Victor Costan on 1/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ZNMSDate.h"

#import "ZNModelDefinitionAttribute.h"

@implementation ZNMSDate

#pragma mark Lifecycle

- (id) init {
	if ((self = [super init])) {
		formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss ZZZ"];
	}
	return self;
}

- (void) dealloc {
	[formatter release];
	[super dealloc];
}

#pragma mark Boxing

- (NSObject*) boxAttribute: (ZNModelDefinitionAttribute*)attribute
				inInstance: (ZNModel*)instance
			   forceString: (BOOL)forceString {
	NSDate* date = object_getIvar(instance, [attribute runtimeIvar]);
	if (forceString)
		return [formatter stringFromDate:date];
	else
		return date;
}

- (void) unboxAttribute: (ZNModelDefinitionAttribute*)attribute
		 	 inInstance: (ZNModel*)instance
			       from: (NSObject*)boxedObject {
	NSDate* date;
	if ([boxedObject isKindOfClass:[NSString class]])
		date = [NSDate dateWithNaturalLanguageString:(NSString*)boxedObject];
	else if ([boxedObject isKindOfClass:[NSDate class]]) {		
		date = (NSDate*)boxedObject;
	}
	else
		date = nil;
	switch ([attribute setterStrategy]) {
		case kZNPropertyWantsCopy:
			date = [date copy];
			break;
		case kZNPropertyWantsRetain:
			date = [date retain];
			break;
	}
	object_setIvar(instance, [attribute runtimeIvar], date);
}

@end

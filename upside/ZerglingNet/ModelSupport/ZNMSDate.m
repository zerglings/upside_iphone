//
//  NZMSDate.m
//  upside
//
//  Created by Victor Costan on 1/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ZNMSDate.h"


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

- (NSObject*) boxInstanceVar: (Ivar)instanceVar
				  inInstance: (ZNModel*)instance
			     forceString: (BOOL)forceString {
	NSDate* date = object_getIvar(instance, instanceVar);
	if (forceString)
		return [formatter stringFromDate:date];
	else
		return date;
}

- (void) unboxInstanceVar: (Ivar)instanceVar
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
	object_setIvar(instance, instanceVar, date);
}

@end

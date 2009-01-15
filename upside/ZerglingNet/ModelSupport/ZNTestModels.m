//
//  ZNTestModels.m
//  upside
//
//  Created by Victor Costan on 1/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ZNTestModels.h"

@implementation ZNTestParsing

@dynamic assign, copy, retain, ro_assign, ro_copy, ro_retain;
@dynamic date_prop, double_prop, integer_prop, string_prop, uinteger_prop;
@dynamic getter, setter, accessor;

@end

@implementation ZNTestProtocolDef

@dynamic win1, win2, win3, fail1, fail2;

@end

@implementation ZNTestDate
@synthesize pubDate;

- (void) dealloc {
	[pubDate release];
	[super dealloc];
}

@end


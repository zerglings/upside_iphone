//
//  DictionaryBackedModel.m
//  upside
//
//  Created by Victor Costan on 1/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DictionaryBackedModel.h"


@implementation DictionaryBackedModel

#pragma mark Lifecycle

- (id)initWithProperties:(NSDictionary*)properties {
	if ((self = [super init])) {
		props = [NSDictionary dictionaryWithDictionary:properties];
		[props retain];
	}
	return self;
}

- (void) dealloc {
	[props release];
	[super dealloc];
}

#pragma mark Accessors

@dynamic properties;

- (NSDictionary*)properties {
	return props;
}



@end

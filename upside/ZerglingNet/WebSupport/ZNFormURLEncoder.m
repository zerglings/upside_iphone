//
//  ZNFormURLEncoder.m
//  upside
//
//  Created by Victor Costan on 1/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ZNFormURLEncoder.h"

#import "ZNModel.h"

@interface ZNFormURLEncoder ()

+ (void) createEncodingFor: (NSObject*)object
						to: (NSMutableData*)output
				 keyPrefix: (NSString*)keyPrefix;
@end


@implementation ZNFormURLEncoder

+ (void) createEncodingForKey: (NSString*)key
						value: (NSObject*)value
						   to: (NSMutableData*)output
					keyPrefix: (NSString*)keyPrefix {
	NSAssert([key isKindOfClass:[NSString class]],
			 @"Attempting to encode non-String key!");
	
	if ([value isKindOfClass:[NSDictionary class]] ||
		[value isKindOfClass:[NSArray class]] ||
		[value isKindOfClass:[ZNModel class]]) {
		NSObject* realValue = [value isKindOfClass:[ZNModel class]] ?
		    [(ZNModel*)value copyToDictionaryForcingStrings:YES] : value;
		
		NSString* newPrefix;
		if ([keyPrefix length] != 0) {
			newPrefix = [[NSString alloc]
						 initWithFormat:@"%@[%@]", keyPrefix, key];
		}
		else
			newPrefix = [key retain];
		[self createEncodingFor:realValue
							 to:output
					  keyPrefix:newPrefix];
		[newPrefix release];
		if (realValue != value)
			[realValue release];
	}
	else {
		NSAssert([value isKindOfClass:[NSString class]],
				 @"Attempting to encode non-String value!");
		
		if ([output length] != 0)
			[output appendBytes:"&" length:1];
		
		NSString* outputKey;
		if ([keyPrefix length] != 0) {
			outputKey = [[NSString alloc]
						 initWithFormat:@"%@[%@]", keyPrefix, key];
		}
		else
			outputKey = [key retain];
		NSString* encodedKey = (NSString*)
		CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
												(CFStringRef)outputKey,
												NULL,
												(CFStringRef)@"&=",
												kCFStringEncodingUTF8);
		[outputKey release];
		[output appendBytes:[encodedKey
							 cStringUsingEncoding:NSUTF8StringEncoding]
					 length:[encodedKey length]];
		[encodedKey release];
		[output appendBytes:"=" length:1];
		
		NSString* encodedValue = (NSString*)
		CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
												(CFStringRef)value,
												NULL,
												(CFStringRef)@"&=",
												kCFStringEncodingUTF8);
		[output appendBytes:[encodedValue
							 cStringUsingEncoding:NSUTF8StringEncoding]
					 length:[encodedValue length]];
		[encodedValue release];
	}	
}

+ (void) createEncodingFor: (NSObject*)object
						to: (NSMutableData*)output
				 keyPrefix: (NSString*)keyPrefix {	
	if ([object isKindOfClass:[NSArray class]]) {
		NSUInteger count = [(NSArray*)object count];
		for (NSUInteger i = 0; i < count; i++) {
			[self createEncodingForKey:@""
								 value:[(NSArray*)object objectAtIndex:i]
									to:output
							 keyPrefix:keyPrefix];
		}
	}
	else {
		for (NSString* key in (NSDictionary*)object) {
			[self createEncodingForKey:key
								 value:[(NSDictionary*)object objectForKey:key]
									to:output
							 keyPrefix:keyPrefix];
		}
	}
}

+ (NSData*) createEncodingFor: (NSDictionary*) dictionary {
	NSMutableData* output = [[NSMutableData alloc] init];
	[self createEncodingFor:dictionary to:output keyPrefix:@""];
	return output;
}

@end

//
//  ZNFormURLEncoder.m
//  upside
//
//  Created by Victor Costan on 1/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ZNFormURLEncoder.h"

#import "ZNModel.h"

@implementation ZNFormURLEncoder

+ (void) createEncodingFor: (NSDictionary*)dictionary
						to: (NSMutableData*)output
				 keyFormat:(NSString*)keyFormat {
	for (NSString* key in dictionary) {
		NSAssert([key isKindOfClass:[NSString class]],
				 @"Attempting to encode non-String key!");
		
		NSObject* value = [dictionary objectForKey:key];
		if ([value isKindOfClass:[NSDictionary class]] ||
			[value isKindOfClass:[ZNModel class]]) {
			NSDictionary* realValue = [value isKindOfClass:[ZNModel class]] ?
			    [(ZNModel*)value copyToDictionaryForcingStrings:YES] :
			    (NSDictionary*)value;
			
			NSString* newFormat = [[NSString alloc]
								   initWithFormat:@"%@[%@]", key, keyFormat];
			[self createEncodingFor:realValue
								 to:output
						  keyFormat:newFormat];
			[newFormat release];
			if (realValue != value)
				[realValue release];
		}
		else {
			NSAssert([value isKindOfClass:[NSString class]],
					 @"Attempting to encode non-String value!");
			
			if ([output length] != 0)
				[output appendBytes:"&" length:1];
			
			NSString* outputKey = [[NSString alloc]
								   initWithFormat:keyFormat, key];
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
}

+ (NSData*) createEncodingFor: (NSDictionary*) dictionary {
	NSMutableData* output = [[NSMutableData alloc] init];
	[self createEncodingFor:dictionary to:output keyFormat:@"%@"];
	return output;
}

@end

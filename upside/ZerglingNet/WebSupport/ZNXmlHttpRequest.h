//
//  ZNXmlHttpRequest.h
//  upside
//
//  Created by Victor Costan on 1/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZNDictionaryXmlParser;

@interface ZNXmlHttpRequest : NSObject {
	NSMutableArray* response;
	ZNDictionaryXmlParser* responseParser;
	NSMutableData* responseData;
	NSDictionary* responseModels;
	NSURLRequest* urlRequest;
	NSObject* target;
	SEL action;
}

// Convenience method for invoking the class.
+ (void) issueRequestToService: (NSString*)service
						  data: (NSDictionary*)data
				responseModels: (NSDictionary*)responseModels
						target: (NSObject*)target
						action: (SEL)action;

+ (NSURLRequest*) createURLRequestToService: (NSString*)service
									   data: (NSDictionary*)data;

- (id) initWithURLRequest: (NSURLRequest*)request
		   responseModels: (NSDictionary*)responseModels
				   target: (NSObject*)target
				   action: (SEL)action;

- (void) start;

@end

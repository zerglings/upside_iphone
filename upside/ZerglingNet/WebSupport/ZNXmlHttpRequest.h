//
//  ZNXmlHttpRequest.h
//  upside
//
//  Created by Victor Costan on 1/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZNHttpRequest.h"

@class ZNDictionaryXmlParser;

@interface ZNXmlHttpRequest : ZNHttpRequest {
	NSMutableArray* response;
	ZNDictionaryXmlParser* responseParser;
	NSDictionary* responseModels;
}

// Convenience method for issuing a request.
+ (void) callService: (NSString*)service
              method: (NSString*)method
                data: (NSDictionary*)data
         fieldCasing: (ZNFormatterCasing)fieldCasing
      responseModels: (NSDictionary*)responseModels
              target: (NSObject*)target
              action: (SEL)action;

// Convenience method for issuing a request with snake-cased form fields.
+ (void) callService: (NSString*)service
              method: (NSString*)method
                data: (NSDictionary*)data
      responseModels: (NSDictionary*)responseModels
              target: (NSObject*)target
              action: (SEL)action;

// Designated initializer.
- (id) initWithURLRequest: (NSURLRequest*)request
           responseModels: (NSDictionary*)responseModels
                   target: (NSObject*)target
                   action: (SEL)action;

@end

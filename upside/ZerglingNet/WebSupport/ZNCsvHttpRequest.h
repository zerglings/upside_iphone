//
//  ZNCsvHttpRequest.h
//  upside
//
//  Created by Victor Costan on 1/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZNHttpRequest.h"

@class ZNArrayCsvParser;
@class ZNModelCsvParser;

@interface ZNCsvHttpRequest : ZNHttpRequest {
	NSMutableArray* response;
	ZNArrayCsvParser* arrayParser;
	ZNModelCsvParser* modelParser;
}

// Convenience method for issuing a request.
+ (void) callService: (NSString*)service
			  method: (NSString*)method
				data: (NSDictionary*)data
	   responseClass: (Class)modelClass
  responseProperties: (NSArray*)modelPropertyNames
			  target: (NSObject*)target
			  action: (SEL)action;

// Designated initializer.
- (id) initWithURLRequest: (NSURLRequest*)request
			responseClass: (Class)modelClass
	   responseProperties: (NSArray*)modelPropertyNames
				   target: (NSObject*)target
				   action: (SEL)action;

@end

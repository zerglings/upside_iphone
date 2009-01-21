//
//  ZNHttpRequest.h
//  upside
//
//  Created by Victor Costan on 1/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Superclass for HTTP request classes.
@interface ZNHttpRequest : NSObject {
	NSMutableData* responseData;
	NSURLRequest* urlRequest;
	NSObject* target;
	SEL action;	
}

#pragma mark Public Interface

+ (void) deleteCookiesForService: (NSString*)service;

#pragma mark Methods for Subclasses

// Issues a request against a HTTP service. When the response is available,
// the given action is invoked on the target, and it is provided a NSData
// in case of success, or an NSError if something went wrong.
//
// Subclasses should provide a convenience method like this.
+ (void) callService: (NSString*)service
			  method: (NSString*)method
				data: (NSDictionary*)data
			  target: (NSObject*)target
			  action: (SEL)action;

// Designated initializer.
- (id) initWithURLRequest: (NSURLRequest*)request
				   target: (id)target
				   action: (SEL)action;

// Creates a NSURLRequest encapsulating data coming from a model.
//
// Subclasses should use this in a convenience method that assembles the request
// and starts it.
+ (NSURLRequest*) newURLRequestToService: (NSString*)service
								  method: (NSString*)method
									data: (NSDictionary*)data;

// Subclasses should call this on the assembled request.
- (void) start;

// Subclasses should parse responseData and message the result to the delegate.
- (void) reportData;

// Subclasses can override this to provide custom parsing for the error.
- (void) reportError: (NSError*) error;

@end

#pragma mark HTTP Method Constants

// GET
extern NSString* kZNHttpMethodGet;
// POST
extern NSString* kZNHttpMethodPost;
// PUT
extern NSString* kZNHttpMethodPut;
// DELETE
extern NSString* kZNHttpMethodDelete;

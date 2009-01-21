//
//  ZNXmlHttpRequest.m
//  upside
//
//  Created by Victor Costan on 1/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ZNXmlHttpRequest.h"

#import "ModelSupport.h"
#import "ZNDictionaryXmlParser.h"


@interface ZNXmlHttpRequest () <ZNDictionaryXmlParserDelegate> 
@end

@implementation ZNXmlHttpRequest

#pragma mark Lifecycle

- (id) initWithURLRequest: (NSURLRequest*)theRequest
		   responseModels: (NSDictionary*)theResponseModels
				   target: (NSObject*)theTarget
				   action: (SEL)theAction {
	if ((self = [super initWithURLRequest:theRequest
								   target:theTarget
								   action:theAction])) {
		response = [[NSMutableArray alloc] init];
		responseParser = [[ZNDictionaryXmlParser alloc]
						  initWithSchema:theResponseModels];
		responseParser.delegate = self;
		responseModels = [theResponseModels retain];		
	}
	return self;
}

- (void) dealloc {
	[response release];
	[responseParser release];
	[responseModels release];
	[super dealloc];
}

+ (void) callService: (NSString*)service
			  method: (NSString*)method
				data: (NSDictionary*)data
	  responseModels: (NSDictionary*)responseModels
			  target: (NSObject*)target
			  action: (SEL)action {
	NSURLRequest* urlRequest = [self newURLRequestToService:service
													 method:method
													   data:data];
	ZNXmlHttpRequest* request =
	    [[ZNXmlHttpRequest alloc] initWithURLRequest:urlRequest
									  responseModels:responseModels
											  target:target
											  action:action];
	[request start];
	[urlRequest release];
	
	// The request will release itself when it is completed.
}

#pragma mark ZNDictionaryXmlParser Delegate

- (void) parsedItem: (NSDictionary*)itemData
			   name: (NSString*)itemName
			context: (NSObject*)context {
	id modelClass = [responseModels objectForKey:itemName];
	if ([ZNModel isModelClass:modelClass]) {
		NSObject* responseModel = [[modelClass alloc]
								   initWithProperties:itemData];
		[response addObject:responseModel];
		[responseModel release];
	}
	else {
		[response addObject:itemData];
	}
}

#pragma mark Delegate Invocation

- (void) reportData {
	NSAutoreleasePool* arp = [[NSAutoreleasePool alloc] init];
	[responseParser parseData:responseData];
	[arp release];
	[target performSelector:action withObject:response];	
}

@end

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
#import "ZNFormURLEncoder.h"


@interface ZNXmlHttpRequest () <ZNDictionaryXmlParserDelegate> 
@end

@implementation ZNXmlHttpRequest

#pragma mark Lifecycle

- (id) initWithURLRequest: (NSURLRequest*)theRequest
		   responseModels: (NSDictionary*)theResponseModels
				   target: (NSObject*)theTarget
				   action: (SEL)theAction {
	if ((self = [super init])) {
		response = [[NSMutableArray alloc] init];
		responseParser = [[ZNDictionaryXmlParser alloc]
						  initWithSchema:theResponseModels];
		responseParser.delegate = self;
		responseData = [[NSMutableData alloc] init];
		urlRequest = [theRequest retain];
		responseModels = [theResponseModels retain];
		
		// NOTE: it is safe to retain the target, it cannot reference us
		target = [theTarget retain];
		action = theAction;
	}
	return self;
}

- (void) dealloc {
	[response release];
	[responseParser release];
	[responseData release];
	[urlRequest release];
	[responseModels release];
	[target release];
	[super dealloc];
}

+ (void) issueRequestToService: (NSString*)service
						  data: (NSDictionary*)data
				responseModels: (NSDictionary*)responseModels
						target: (NSObject*)target
						action: (SEL)action {
	NSURLRequest* urlRequest = [self newURLRequestToService:service
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

- (void) reportError: (NSError*) error {
	[target performSelector:action withObject:error];
}

#pragma mark NSURLConnection Delegate

- (NSURLRequest*) connection: (NSURLConnection*)connection
			 willSendRequest: (NSURLRequest*)request
			redirectResponse: (NSURLResponse*)redirectResponse {
	return request;
}

- (void) connection: (NSURLConnection*)connection
 didReceiveResponse: (NSURLResponse*)response {
	[responseData setLength:0];
}

- (void) connection: (NSURLConnection*)connection
	 didReceiveData: (NSData*)data {
	[responseData appendData:data];
}

- (void) connectionDidFinishLoading: (NSURLConnection*)connection {
	[self reportData];
	[self release];
}

- (void) connection: (NSURLConnection*)connection
   didFailWithError: (NSError*)error {
	[target performSelector:action withObject:error];
	[self release];
}

- (NSCachedURLResponse*) connection: (NSURLConnection*)connection
				  willCacheResponse: (NSCachedURLResponse*)cachedResponse {
	// It's usually a bad idea to cache queries to Web services.
	return nil;
}

#pragma mark NSInputStream Delegate

- (void) stream: (NSStream *)theStream handleEvent: (NSStreamEvent)event {
	NSInputStream* stream = (NSInputStream*)theStream;
	switch (event) {
		case NSStreamEventHasBytesAvailable: {
			uint8_t *streamBuffer;
			NSUInteger length;
			if ([stream getBuffer:&streamBuffer length:&length]) {
				[responseData appendBytes:streamBuffer length:length];
			}
			else {
				uint8_t readBuffer[128];
				NSInteger bytesRead = [stream read:readBuffer maxLength:128];
				[responseData appendBytes:readBuffer length:bytesRead];
			}
			break;
		}
		case NSStreamEventEndEncountered:
		case NSStreamEventErrorOccurred:
			if (NSStreamEventEndEncountered) {
				[self reportData];
			}
			else {
				[self reportError:[stream streamError]];
			}
			[stream removeFromRunLoop:[NSRunLoop currentRunLoop]
							  forMode:NSDefaultRunLoopMode];
			[stream close];			
			[self release];
			break;
		default:
			break;
	}
}

#pragma mark Connection

- (void) start {
	NSURL* url = [urlRequest URL];
	if([url isFileURL]) {
		NSInputStream* stream = [[NSInputStream alloc]
								 initWithFileAtPath:[url path]];
		[stream setDelegate:self];
		[stream scheduleInRunLoop:[NSRunLoop currentRunLoop]
						  forMode:NSDefaultRunLoopMode];
		[stream open];
		[stream release];
	}
	else {
		NSURLConnection* connection =
	    [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
		[connection release];
	}	
}

#pragma mark HTTP Request Creation

+ (NSURLRequest*) newURLRequestToService: (NSString*)service
									data: (NSDictionary*)data {
	NSURL* url = [[NSURL alloc] initWithString:service];	
	NSMutableURLRequest* request = [[NSMutableURLRequest alloc]
									initWithURL:url];
	[url release];
	
	[request setHTTPMethod:@"POST"];
	NSData* encodedBody = [ZNFormURLEncoder createEncodingFor:data];
	[request setHTTPBody:encodedBody];
	[encodedBody release];
	
	[request addValue:@"application/x-www-form-urlencoded"
   forHTTPHeaderField:@"Content-Type"];
	[request addValue:[NSString stringWithFormat:@"%u", [encodedBody length]]
   forHTTPHeaderField:@"Content-Length"];
	[request addValue:@"Zergling.Net Web Support/1.0"
   forHTTPHeaderField:@"User-Agent"];
	return request;
}

@end

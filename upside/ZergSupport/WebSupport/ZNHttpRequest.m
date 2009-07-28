//
//  ZNHttpRequest.m
//  ZergSupport
//
//  Created by Victor Costan on 1/21/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNHttpRequest.h"

#import "ZNFormFieldFormatter.h"
#import "ZNFormURLEncoder.h"


@implementation ZNHttpRequest

#pragma mark Lifecycle

-(id)initWithURLRequest:(NSURLRequest*)theRequest
                 target:(id)theTarget
                 action:(SEL)theAction {
  if ((self = [super init])) {
    responseData = [[NSMutableData alloc] init];
    urlRequest = [theRequest retain];
    statusCode = 0;
    // NOTE: it is safe to retain the target, it cannot reference us
    target = [theTarget retain];
    action = theAction;
  }
  return self;
}

-(void)dealloc {
  [responseData release];
  [urlRequest release];
  [target release];
  [super dealloc];
}

NSString* kZNHttpErrorDomain = @"ZNHttpErrorDomain";

#pragma mark HTTP Request Creation

+(NSURLRequest*)newURLRequestToService:(NSString*)service
                                method:(NSString*)method
                                  data:(NSObject*)dictionaryOrModel
                           fieldCasing:(ZNFormatterCasing)fieldCasing
                          encoderClass:(Class)dataEncodingClass {
  NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];

  [request setHTTPMethod:method];
  [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
  [request setHTTPShouldHandleCookies:YES];

  ZNFormFieldFormatter* fieldFormatter =
      [ZNFormFieldFormatter formatterFromPropertiesTo:fieldCasing];
  NSData* encodedBody = [dataEncodingClass copyEncodingFor:dictionaryOrModel
                                       usingFieldFormatter:fieldFormatter];
  NSString* contentType = [dataEncodingClass copyContentTypeFor:encodedBody];

  if ([encodedBody length] != 0 && [method isEqualToString:kZNHttpMethodGet] ||
      [method isEqualToString:kZNHttpMethodDelete]) {
    // GET and DELETE don't have a body, parameters must be encoded in the URL.
    NSString* urlTail = [[NSString alloc] initWithData:encodedBody
                                              encoding:NSUTF8StringEncoding];
    NSString* urlFormat = ([service rangeOfString:@"?"].length > 0) ? @"%@&%@" :
        @"%@?%@";
    NSString* urlString = [[NSString alloc] initWithFormat:urlFormat,
                           service, urlTail];
    NSURL* url = [[NSURL alloc] initWithString:urlString];
    [request setURL:url];
    [url release];
    [urlString release];
    [urlTail release];
  }
  else {
    // POST and PUT are allowed to have a body.
    NSURL* url = [[NSURL alloc] initWithString:service];
    [request setURL:url];
    [url release];
    [request setHTTPBody:encodedBody];
  }

  [request addValue:contentType
 forHTTPHeaderField:@"Content-Type"];
  [request addValue:[NSString stringWithFormat:@"%u",
                     [[request HTTPBody] length]]
 forHTTPHeaderField:@"Content-Length"];
  [request addValue:@"Zergling.Net Web Support/1.0"
 forHTTPHeaderField:@"User-Agent"];

  [contentType release];
  [encodedBody release];
  return request;
}

#pragma mark Cookie Management

+(void)deleteCookiesForService:(NSString*)service {
  NSHTTPCookieStorage* cookieBox = [NSHTTPCookieStorage
                                    sharedHTTPCookieStorage];
  NSArray* cookies = [cookieBox cookiesForURL:[NSURL URLWithString:service]];
  for (NSHTTPCookie* cookie in cookies) {
    [cookieBox deleteCookie:cookie];
  }
}

#pragma mark Delegate Invocation

-(void)reportData {
  [target performSelector:action withObject:responseData];
}

-(void)reportError:(NSError*) error {
  [target performSelector:action withObject:error];
}

#pragma mark NSURLConnection Delegate

-(NSURLRequest*)connection:(NSURLConnection*)connection
           willSendRequest:(NSURLRequest*)request
          redirectResponse:(NSURLResponse*)redirectResponse {
  return request;
}

-(void)connection:(NSURLConnection*)connection
didReceiveResponse:(NSURLResponse*)response {
  statusCode = [(NSHTTPURLResponse*)response statusCode];
  [responseData setLength:0];
}

-(void)connection:(NSURLConnection*)connection
   didReceiveData:(NSData*)data {
  [responseData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection*)connection {
  if (statusCode >= 200 && statusCode < 300) {
    [self reportData];
  }
  else {
    NSDictionary* errorDict = [[NSDictionary alloc] initWithObjectsAndKeys:
        @"Internal HTTP Server Error", NSLocalizedDescriptionKey,
        @"Internal HTTP Server Error", NSLocalizedFailureReasonErrorKey, nil];
    NSError* error = [[NSError alloc] initWithDomain:kZNHttpErrorDomain
                                                code:statusCode
                                            userInfo:errorDict];
    [errorDict release];
    [self reportError:error];
    [error release];
  }

  [self release];
}

-(void)connection:(NSURLConnection*)connection
 didFailWithError:(NSError*)error {
  [target performSelector:action withObject:error];
  [self release];
}

-(NSCachedURLResponse*)connection:(NSURLConnection*)connection
                willCacheResponse:(NSCachedURLResponse*)cachedResponse {
  // It's usually a bad idea to cache queries to Web services.
  return nil;
}

#pragma mark NSInputStream Delegate

-(void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)event {
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

-(void)start {
  NSURL* url = [urlRequest URL];
  if([url isFileURL]) {
    NSInputStream* stream = [[NSInputStream alloc] initWithFileAtPath:[url
                                                                       path]];
    [stream setDelegate:self];
    [stream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                      forMode:NSDefaultRunLoopMode];
    [stream open];
    [stream release];
  }
  else {
    [[NSHTTPCookieStorage sharedHTTPCookieStorage]
     setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    NSURLConnection* connection =
        [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    [connection release];
  }
  [self retain];
   // The request will release itself when it is completed.
}

+(void)callService:(NSString*)service
            method:(NSString*)method
              data:(NSObject*)dictionaryOrModel
       fieldCasing:(ZNFormatterCasing)fieldCasing
      encoderClass:(Class)dataEncodingClass
            target:(NSObject*)target
            action:(SEL)action {
  NSURLRequest* urlRequest = [self newURLRequestToService:service
                                                   method:method
                                                     data:dictionaryOrModel
                                              fieldCasing:fieldCasing
                                             encoderClass:dataEncodingClass];
  ZNHttpRequest* request =
      [[ZNHttpRequest alloc] initWithURLRequest:urlRequest
                                         target:target
                                         action:action];
  [request start];
  [urlRequest release];
  [request release];
}

@end

#pragma mark HTTP Method Constants

NSString* kZNHttpMethodGet = @"GET";
NSString* kZNHttpMethodPost = @"POST";
NSString* kZNHttpMethodPut = @"PUT";
NSString* kZNHttpMethodDelete = @"DELETE";

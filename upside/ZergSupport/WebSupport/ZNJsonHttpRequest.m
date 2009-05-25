//
//  ZNJsonHttpRequest.m
//  ZergSupport
//
//  Created by Victor Costan on 5/3/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNJsonHttpRequest.h"

#import "FormatSupport.h"
#import "ModelSupport.h"


@interface ZNJsonHttpRequest () <ZNModelJsonParserDelegate>
@end

@implementation ZNJsonHttpRequest

#pragma mark Lifecycle

-(id)initWithURLRequest:(NSURLRequest*)theRequest
        responseQueries:(NSArray*)theResponseQueries
         responseCasing:(enum ZNFormatterCasing)responseCasing
                 target:(NSObject*)theTarget
                 action:(SEL)theAction {
  if ((self = [super initWithURLRequest:theRequest
                                 target:theTarget
                                 action:theAction])) {
    response = [[NSMutableArray alloc] init];
    responseParser = [[ZNModelJsonParser alloc]
                      initWithQueries:theResponseQueries
                      documentCasing:responseCasing];
    responseParser.delegate = self;
  }
  return self;
}

-(void)dealloc {
  [response release];
  [responseParser release];
  [super dealloc];
}

+(void)callService:(NSString*)service
            method:(NSString*)method
              data:(NSDictionary*)data
       fieldCasing:(enum ZNFormatterCasing)fieldCasing
      encoderClass:(Class)dataEncodingClass
   responseQueries:(NSArray*)responseQueries
    responseCasing:(enum ZNFormatterCasing)responseCasing
            target:(NSObject*)target
            action:(SEL)action {
  NSURLRequest* urlRequest = [self newURLRequestToService:service
                                                   method:method
                                                     data:data
                                              fieldCasing:fieldCasing
                                             encoderClass:dataEncodingClass];
  ZNJsonHttpRequest* request =
      [[ZNJsonHttpRequest alloc] initWithURLRequest:urlRequest
                                    responseQueries:responseQueries
                                     responseCasing:responseCasing
                                             target:target
                                             action:action];
  [request start];
  [urlRequest release];
  [request release];
}

+(void)callService:(NSString*)service
            method:(NSString*)method
              data:(NSDictionary*)data
   responseQueries:(NSArray*)responseQueries
            target:(NSObject*)target
            action:(SEL)action {
  return [self callService:service
                    method:method
                      data:data
               fieldCasing:kZNFormatterSnakeCase
              encoderClass:[ZNFormURLEncoder class]
           responseQueries:responseQueries
            responseCasing:kZNFormatterSnakeCase
                    target:target
                    action:action];
}

#pragma mark ZNModelJsonParser Delegate

-(void)parsedObject:(NSObject*)object
          context:(id)context {
  [response addObject:object];
}
-(void)parsedModel:(ZNModel*)model
           context:(id)context {
  [response addObject:model];
}

#pragma mark Delegate Invocation

-(void)reportData {
  NSAutoreleasePool* arp = [[NSAutoreleasePool alloc] init];
  [responseParser parseData:responseData];
  [arp release];
  [target performSelector:action withObject:response];
}

@end
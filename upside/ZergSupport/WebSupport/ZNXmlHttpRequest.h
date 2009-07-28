//
//  ZNXmlHttpRequest.h
//  ZergSupport
//
//  Created by Victor Costan on 1/16/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

#import "ZNHttpRequest.h"

@class ZNModelXmlParser;


@interface ZNXmlHttpRequest : ZNHttpRequest {
  NSMutableArray* response;
  ZNModelXmlParser* responseParser;
}

// Convenience method for issuing a request.
+(void)callService:(NSString*)service
            method:(NSString*)method
              data:(NSObject*)dictionaryOrModel
       fieldCasing:(enum ZNFormatterCasing)fieldCasing
      encoderClass:(Class)dataEncodingClass
    responseModels:(NSDictionary*)responseModels
    responseCasing:(enum ZNFormatterCasing)responseCasing
            target:(NSObject*)target
            action:(SEL)action;

// Convenience method for issuing a request with a snake-cased server.
+(void)callService:(NSString*)service
            method:(NSString*)method
              data:(NSObject*)dictionaryOrModel
    responseModels:(NSDictionary*)responseModels
            target:(NSObject*)target
            action:(SEL)action;

// Designated initializer.
-(id)initWithURLRequest:(NSURLRequest*)request
         responseModels:(NSDictionary*)responseModels
         responseCasing:(enum ZNFormatterCasing)responseCasing
                 target:(NSObject*)target
                 action:(SEL)action;

@end

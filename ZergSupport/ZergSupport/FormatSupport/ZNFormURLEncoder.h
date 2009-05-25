//
//  ZNFormURLEncoder.h
//  ZergSupport
//
//  Created by Victor Costan on 1/16/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

#import "ZNFormEncoder.h"

@class ZNFormFieldFormatter;

// Convert form data into the application/x-www-form-urlencoded MIME encoding.
@interface ZNFormURLEncoder : ZNFormEncoder {
}

// Encodes the given dictionary or ModelSupport model.
+(NSData*)copyEncodingFor:(NSDictionary*)dictionary
        usingFieldFormatter:(ZNFormFieldFormatter*)formatter;

// Computes the correct Content-Type: directed value for some encoded content.
//
// Assumes the encoding was created by calling
// +copyEncodingFor:usingFieldFormatter: on the same class.
+(NSString*)copyContentTypeFor:(NSData*)encodedData;

@end

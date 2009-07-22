//
//  ZNFormMultipartEncoder.h
//  ZergSupport
//
//  Created by Victor Costan on 5/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>
#import "ZNFormEncoder.h"


// Convert form data into the multipart/form-data MIME encoding.
@interface ZNFormMultipartEncoder : ZNFormEncoder {
  NSData* boundary;
  const uint8_t* boundaryBytes;
  NSUInteger boundaryLength;
}

// Encodes the given dictionary or ModelSupport model.
+(NSData*)copyEncodingFor:(NSObject*)dictionaryOrModel
      usingFieldFormatter:(ZNFormFieldFormatter*)formatter;

// Computes the correct Content-Type: directed value for some encoded content.
//
// Assumes the encoding was created by calling
// +copyEncodingFor:usingFieldFormatter: on the same class.
+(NSString*)copyContentTypeFor:(NSData*)encodedData;

@end

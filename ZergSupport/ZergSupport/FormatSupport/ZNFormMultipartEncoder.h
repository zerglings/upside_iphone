//
//  ZNFormMultipartEncoder.h
//  ZergSupport
//
//  Created by Victor Costan on 5/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>
#import "ZNFormEncoder.h"


@interface ZNFormMultipartEncoder : ZNFormEncoder {
  NSData* boundary;
  const uint8_t* boundaryBytes;
  NSUInteger boundaryLength;
}

// Encodes the given dictionary or ModelSupport model.
+(NSData*)copyEncodingFor:(NSDictionary*)dictionary
      usingFieldFormatter:(ZNFormFieldFormatter*)formatter;

@end

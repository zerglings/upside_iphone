//
//  ZNFormMultipartEncoder.h
//  ZergSupport
//
//  Created by Victor Costan on 5/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZNFormEncoder.h"


@interface ZNFormMultipartEncoder : ZNFormEncoder {
  NSData* boundary;
}

// Encodes the given dictionary or ModelSupport model.
+(NSData*)copyEncodingFor:(NSDictionary*)dictionary
      usingFieldFormatter:(ZNFormFieldFormatter*)formatter;

@end

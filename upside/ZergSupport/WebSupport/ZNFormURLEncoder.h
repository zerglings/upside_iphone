//
//  ZNFormURLEncoder.h
//  upside
//
//  Created by Victor Costan on 1/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZNFormFieldFormatter;

// Convert form data into the application/x-www-form-urlencoded MIME encoding.
@interface ZNFormURLEncoder : NSObject {
  NSMutableData* output;
  ZNFormFieldFormatter* fieldFormatter;
}

+ (NSData*) copyEncodingFor: (NSDictionary*)dictionary
        usingFieldFormatter: (ZNFormFieldFormatter*)formatter;

@end

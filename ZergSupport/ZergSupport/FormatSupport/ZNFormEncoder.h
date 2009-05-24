//
//  ZNFormEncoder.h
//  ZergSupport
//
//  Created by Victor Costan on 5/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZNFormFieldFormatter;


// Superclass for converting data from a NSDictionary or ModelSupport model
// into the formats expected by Web services, such as
// application/x-www-form-urlencoded.
//
// The superclass only implements the common functionality for the encoders,
// and should not be used directly. Instead, use one of its sub-classes, like
// ZNFormURLEncoder.
//
// Subclass implementers should take a look at test files for a reference
// implementation.
@interface ZNFormEncoder : NSObject {
  NSMutableData* output;
  ZNFormFieldFormatter* fieldFormatter;
}

#pragma mark Consumer API

// Encodes the given dictionary or ModelSupport model.
+(NSData*)copyEncodingFor:(NSDictionary*)dictionary
      usingFieldFormatter:(ZNFormFieldFormatter*)formatter;

#pragma mark Subclass API

// The output buffer for the encoded data.
@property (nonatomic, readonly, retain) NSMutableData* output;

// Designated initializer.
-(id)initWithFieldFormatter:(ZNFormFieldFormatter*)theFieldFormatter;

// Appends the key,value pair to the output buffer.
-(void)outputValue:(NSString*)value forKey:(NSString*)key;

@end

//
//  ZNFormEncoder.h
//  ZergSupport
//
//  Created by Victor Costan on 5/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
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

// Computes the correct Content-Type: directed value for some encoded content.
//
// Assumes the encoding was created by calling
// +copyEncodingFor:usingFieldFormatter: on the same class.
//
// Subclasses must override this method.
+(NSString*)copyContentTypeFor:(NSData*)encodedData;

#pragma mark Subclass API

// The output buffer for the encoded data.
//
// Subclasses can access the buffer through this property, or directly through
// the output field.
@property (nonatomic, readonly, retain) NSMutableData* output;

// Designated initializer.
//
// Subclasses should override this method if custom encoder lifecycle management
// is desired.
-(id)initWithFieldFormatter:(ZNFormFieldFormatter*)theFieldFormatter;

// Kicks off the encoding process.
//
// Subclasses should only call this method in an overriding implementation of
// +copyEncodingFor:usingFormatter:
-(void)encode:(NSObject*)object;

// Appends the key,value pair to the output buffer.
//
// Subclasses must override this method.
-(void)outputValue:(NSString*)value forKey:(NSString*)key;

@end

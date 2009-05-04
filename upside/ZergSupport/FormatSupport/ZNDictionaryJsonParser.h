//
//  ZNDictionaryJsonParser.h
//  ZergSupport
//
//  Created by Victor Costan on 5/1/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

@protocol ZNDictionaryJsonParserDelegate;
@class ZNFormFieldFormatter;


// Parses objects in JSON notation.
//
// The JSON structures are converted into the obvious Objective C equivalents:
// hashes become NSDictionaries, arrays become NSArrays, strings are represented
// by NSStrings, numbers and booleans become NSNumbers, and nulls are translated
// to NSNull instances.
//
// This JSON parser understands the JSON standard, plus strings deliminted by
// ' (the standard only recognizes " as a string delimiter). This is done to
// facilitate convenient representation of JSON objects inside Objective C
// strings. The feature is expected to be used in tests, together with
// -parseValue, to make up for Objective C's lack of array and dictionary
// literals.
@interface ZNDictionaryJsonParser : NSObject {
  id<ZNDictionaryJsonParserDelegate> delegate;
  id context;
  ZNFormFieldFormatter* keyFormatter;
}
@property (nonatomic, assign) id context;
@property (nonatomic, assign) id<ZNDictionaryJsonParserDelegate> delegate;

// Initializes a parser, which can be used multiple times.
-(id)init;

// Designated initializer. Initializes a parser with the given formatter
// for hash (NSDictionary) keys.
//
// A parser can be used multiple times, once initialized.
-(id)initWithKeyFormatter:(ZNFormFieldFormatter*)keyFormatter;

// Parses a JSON object inside an NSData instance.
-(BOOL)parseData:(NSData*)data;

// Parses a JSON value inside a string. Convenient for testing.
//
// Returns nil if the string does not contain a valid JSON object.
+(NSObject*)parseValue:(NSString*)jsonValue;

@end


@protocol ZNDictionaryJsonParserDelegate

// Called when the JSON root object is parsed.
//
// In the future, might be used for pruning the JSON object being parsed.
-(void)parsedJson:(NSDictionary*)jsonData context:(id)context;

@end

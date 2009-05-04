//
//  ZNModelJsonParser.h
//  ZergSupport
//
//  Created by Victor Costan on 5/3/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

#import "ZNFormatterCasing.h"

@class ZNDictionaryJsonParser;
@class ZNModel;
@protocol ZNModelJsonParserDelegate;


// ModelSupport-enabled wrapper on top of DictionaryJsonParser.
//
// The wrapper instantiates ModelSupport models out of some of the items
// produced by DictionaryJsonParser.
//
// The schema is an array of (model, query) pairs. The model is a ZNModel class
// or a non-model class (suggested: NSNull), and query string is compiled into
// a ZNObjectQuery.
// The queries will be executed in order. Their results will be converted into
// corresponding models, if model classes are supplied. Otherwise, the barebone
// Cocoa objects will be returned to the delegate.
@interface ZNModelJsonParser : NSObject {
  ZNDictionaryJsonParser* parser;
  NSMutableArray* compiledQueries;
  id<ZNModelJsonParserDelegate> delegate;
  Class null;
}

@property (nonatomic, assign) id context;
@property (nonatomic, assign) id<ZNModelJsonParserDelegate> delegate;

// Initializes a parser with a set of queries, which can be used multiple times.
-(id)initWithQueries:(NSArray*)queries
      documentCasing:(ZNFormatterCasing)documentCasing;

// Parses a JSON document inside an NSData instance.
-(BOOL)parseData:(NSData*)data;

@end

// The interface between ZNModelXMLParser and its delegate.
@protocol ZNModelJsonParserDelegate

// Called after parsing a model out of a JSON object.
-(void)parsedModel:(ZNModel*)model
           context:(id)context;

// Called after parsing a JSON object with no model.
-(void)parsedObject:(NSObject*)object
            context:(id)context;
@end

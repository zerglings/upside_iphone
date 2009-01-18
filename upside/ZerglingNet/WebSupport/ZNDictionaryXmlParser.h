//
//  DictionaryXmlParser.h
//  upside
//
//  Created by Victor Costan on 1/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZNDictionaryXmlParserDelegate

- (void) parsedItem: (NSDictionary*)itemData
			   name: (NSString*)itemName
			context: (NSObject*)context;

@end


@interface ZNDictionaryXmlParser : NSObject {
	NSObject<ZNDictionaryXmlParserDelegate>* delegate;
	NSObject* context;
	NSDictionary* schema;
	
	// underlying XML parser
	NSXMLParser* parser;
	// accumulates the properties of the currently parsed item 
	NSMutableDictionary* currentItem;
	// the current item's name
	NSString* currentItemName;
	// the currently parsed property of the currently parsed item
	NSString* currentProperty;
	// the value for the currently parsed property
	NSMutableString* currentValue;
	// the schema for the currently parsed item
	NSSet* currentItemSchema;
	// if YES, the current item accepts all sub-elements given to it
	BOOL currentItemHasOpenSchema;
}

@property (nonatomic, retain) NSDictionary* schema;
@property (nonatomic, retain) NSObject* context;
@property (nonatomic, assign) NSObject<ZNDictionaryXmlParserDelegate>* delegate;

// Initialized a parser for a schema, which can be used multiple times.
- (id) initWithSchema: (NSDictionary*)schema;

- (BOOL) parseData: (NSData*)data;

- (BOOL) parseURL: (NSURL*)url;

@end

//
//  DictionaryXmlParser.m
//  upside
//
//  Created by Victor Costan on 1/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DictionaryXmlParser.h"


@implementation DictionaryXmlParser

#pragma mark Lifecycle

- (id) initWithSchema: (NSDictionary*) theSchema {
	if ((self = [super init])) {
		self.schema = theSchema;
		
		currentValue = [[NSMutableString alloc] init];
		currentItem = [[NSMutableDictionary alloc] init];
		
		currentItemSchema = nil;
		currentItemName = nil;
		currentProperty = nil;		
	}
	
	return self;
}

- (void) dealloc {
	[delegate release];
	[context release];
	[schema release];
	[currentValue release];
	[currentItem release];
	[currentItemName release];
	[currentProperty release];
	[super dealloc];
}

@synthesize context;
@synthesize delegate;
@synthesize schema;

#pragma mark Parsing Lifecycle

- (void) cleanUpAfterParsing {
	currentItemSchema = nil;
	[currentItemName release];
	currentItemName = nil;
	[currentProperty release];
	currentProperty = nil;
	
	[currentItem removeAllObjects];
	[currentValue setString:@""];
	
	[parser release];
	parser = nil;
}

- (BOOL) parseData: (NSData*)data {
	parser = [[NSXMLParser alloc] initWithData:data];
	parser.delegate = self;
	BOOL success = [parser parse];
	[self cleanUpAfterParsing];
	return success;
}

- (BOOL) parseURL: (NSURL*)url {
	parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	parser.delegate = self;
	BOOL success = [parser parse];
	[self cleanUpAfterParsing];
	return success;
}

#pragma mark NSXMLParser Delegate

- (void) parser: (NSXMLParser *)parser didStartElement: (NSString *)elementName
   namespaceURI: (NSString *)namespaceURI
  qualifiedName: (NSString *)qName
	 attributes: (NSDictionary *)attributeDict {
	
	if (currentItemSchema != nil) {
		// already parsing an item, see if it's among the keys
		if (currentItemHasOpenSchema || [currentItemSchema
										 containsObject:elementName]) {
			currentProperty = [elementName retain];
		}
	}
	else if (currentItemSchema = [schema objectForKey:elementName]) {
		// parsing new item
		currentItemName = [elementName retain];
		currentItemHasOpenSchema = [currentItemSchema containsObject:@"<open>"];
	}
}

- (void) parser: (NSXMLParser *)parser foundCharacters: (NSString *)string {
	if (currentProperty != nil) {
		[currentValue appendString:string];
	}
}

- (void) parser: (NSXMLParser *)parser didEndElement: (NSString *)elementName
   namespaceURI: (NSString *)namespaceURI
  qualifiedName: (NSString *)qName {
	
	if (currentProperty != nil) {
		// parsing a property
		if ([currentProperty isEqualToString:elementName]) {
			// done parsing the property
			[currentItem setObject:[NSString stringWithString:currentValue]
							forKey:currentProperty];
			
			[currentProperty release];
			currentProperty = nil;
			[currentValue setString:@""];
		}
	}
	else if ([currentItemName isEqualToString:elementName]) {
		// done parsing an entire item
		[delegate parsedItem:[NSDictionary dictionaryWithDictionary:currentItem]
					withName:currentItemName
						 for:context];
		
		[currentItem removeAllObjects];
		currentItemSchema = nil;
		[currentItemName release];
		currentItemName = nil;
	}	
}

@end

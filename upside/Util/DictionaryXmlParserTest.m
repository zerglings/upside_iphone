//
//  DictionaryXmlParserTest.m
//  upside
//
//  Created by Victor Costan on 1/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#include "GTMSenTestCase.h"

#include "DictionaryXmlParser.h"

@interface DictionaryXmlParserTest : SenTestCase <DictionaryXmlParserDelegate> {
	DictionaryXmlParser* parser;

	NSMutableArray* items;
	NSMutableArray* dupItems;
	NSMutableArray* names;
	NSMutableArray* dupNames;
}

@end

NSString* kContextObject = @"This is the context";

@implementation DictionaryXmlParserTest

- (void) setUp {
	NSDictionary* schema = [NSDictionary dictionaryWithObjectsAndKeys:
							[[NSSet alloc] initWithObjects:@"<open>", nil],
							@"itemA",
							[[NSSet alloc]
							 initWithObjects:@"keyB", @"keyC", nil],
							@"itemB",
							nil];
	
	parser = [[DictionaryXmlParser alloc] initWithSchema:schema];
	parser.context = kContextObject;
	parser.delegate = self;
	
	items = [[NSMutableArray alloc] init];
	dupItems = [[NSMutableArray alloc] init]; 
	names = [[NSMutableArray alloc] init];
	dupNames = [[NSMutableArray alloc] init]; 
	
}

- (void) tearDown {
	[parser release];
	[names release];
	[dupNames release];
	[items release];
	[dupItems release];
}

- (void) checkItems {
	STAssertEqualObjects(names, dupNames, @"Item names changed during parsing");
	STAssertEqualObjects(items, dupItems, @"Item data changed during parsing");
	
	NSArray* goldenNames = [NSArray arrayWithObjects:@"itemA",
							@"itemB", @"itemA", nil];
	STAssertEqualObjects(goldenNames, names,
						 @"Failed to parse all the right items");
	
	NSDictionary* goldenFirst = [NSDictionary dictionaryWithObjectsAndKeys:
								 @"A prime", @"keyA", @"B prime", @"keyB", nil];
	STAssertEqualObjects(goldenFirst, [items objectAtIndex:0],
						 @"Failed to parse item with open schema");

	NSDictionary* goldenSecond = [NSDictionary dictionaryWithObjectsAndKeys:
								 @"B second", @"keyB", nil];
	STAssertEqualObjects(goldenSecond, [items objectAtIndex:1],
						 @"Failed to parse item with closed schema");

	NSDictionary* goldenThird = [NSDictionary dictionaryWithObjectsAndKeys:
								 @"B third", @"keyB",
								 @"Entity fun '>", @"keyC", nil];
	STAssertEqualObjects(goldenThird, [items objectAtIndex:2],
						 @"Failed to parse XML entities");
}

- (void) testParsing {
	NSString *filePath = [[[NSBundle mainBundle] resourcePath]
						  stringByAppendingPathComponent:
						  @"DictionaryXmlParserTest.xml"];
	BOOL success = [parser parseURL:[NSURL fileURLWithPath:filePath]];	
	STAssertTrue(success, @"Parsing failed on DictionaryXmlParserTest.xml");
	
	[self checkItems];
}

- (void) parsedItem: (NSDictionary*) itemData
		   withName:(NSString*)itemName
				for:(NSObject*)context {
	STAssertEquals(kContextObject, context,
				  @"Wrong context passed to -parsedItem");
		
	[names addObject:itemName];
	[dupNames addObject:[NSString stringWithString:itemName]];
	
	[items addObject:itemData];
	[dupItems addObject:[NSDictionary dictionaryWithDictionary:itemData]];	
}

@end
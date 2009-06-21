//
//  DictionaryXmlParser.m
//  ZergSupport
//
//  Created by Victor Costan on 1/9/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNDictionaryXmlParser.h"

#import "ZNFormFieldFormatter.h"


@implementation ZNDictionaryXmlParser

#pragma mark Lifecycle

-(id)initWithSchema:(NSDictionary*)theSchema
       keyFormatter:(ZNFormFieldFormatter*)theKeyFormatter {
  if ((self = [super init])) {
    keyFormatter = [theKeyFormatter retain];

    NSMutableDictionary* rootObject = [[NSMutableDictionary alloc] init];
    parseStack = [[NSMutableArray alloc] initWithObjects:rootObject, nil];
    [rootObject release];

    schemaStack = [[NSMutableArray alloc] initWithObjects:theSchema, nil];
    currentValue = [[NSMutableString alloc] init];
    ignoreDepth = 0;
    currentItemName = nil;
  }

  return self;
}

-(void)dealloc {
  [keyFormatter release];
  [parseStack release];
  [schemaStack release];
  [currentValue release];
  [currentItemName release];
  [super dealloc];
}

@synthesize context;
@synthesize delegate;

#pragma mark Parsing Lifecycle

-(void)cleanUpAfterParsing {
  [parseStack removeObjectsInRange:NSMakeRange(1, [parseStack count] - 1)];
  [schemaStack removeObjectsInRange:NSMakeRange(1, [parseStack count] - 1)];
  [(NSMutableDictionary*)[parseStack objectAtIndex:0] removeAllObjects];
  [currentValue setString:@""];

  [parser release];
  parser = nil;
}

-(BOOL)parseData:(NSData*)data {
  parser = [[NSXMLParser alloc] initWithData:data];
  parser.delegate = self;
  BOOL success = [parser parse];
  [self cleanUpAfterParsing];
  return success;
}

-(BOOL)parseURL:(NSURL*)url {
  parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
  parser.delegate = self;
  BOOL success = [parser parse];
  [self cleanUpAfterParsing];
  return success;
}

#pragma mark Schema management

-(NSObject*)unravelSchema:(NSObject*)schema
          withElementName:(NSString*)name {
  if ([schema isKindOfClass:[NSDictionary class]]) {
    // Sub-schemas.
    NSObject* subSchema = [(NSDictionary*)schema objectForKey:name];
    return subSchema;
  }
  else if ([schema isKindOfClass:[NSSet class]]) {
    // Closed schema.
    return [(NSSet*)schema containsObject:name] ? name : nil;
  }
  else if ([schema isKindOfClass:[NSString class]]) {
    // Schema leaf - should not move forward.
    return nil;
  }
  else {
    // Open schema.
    return schema;
  }
}

#pragma mark NSXMLParser Delegate

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
   attributes:(NSDictionary *)attributeDict {
  if (ignoreDepth > 0) {
    ignoreDepth++;
    return;
  }
  
  NSString* formattedElementName = keyFormatter ?
      [keyFormatter copyFormattedName:elementName] : elementName;

  NSUInteger schemaStackTop = [schemaStack count] - 1;
  NSObject* schema = [schemaStack objectAtIndex:schemaStackTop];
  NSObject* nextSchema = [self unravelSchema:schema
                             withElementName:formattedElementName];
  if (!nextSchema) {
    if (schemaStackTop > 0)
      ignoreDepth++;
    if (formattedElementName != elementName) {
      [formattedElementName release];
    }
    return;
  }

  [schemaStack addObject:nextSchema];

  NSUInteger parseStackTop = [parseStack count] - 1;
  NSObject* stackTop = [parseStack objectAtIndex:parseStackTop];
  if ([stackTop isKindOfClass:[NSString class]]) {
    // Create sub-dictionary and assign it to the proper key in the parent
    // dictionary.
    NSMutableDictionary* parentDictionary = [parseStack
                                             objectAtIndex:(parseStackTop - 1)];
    NSMutableDictionary* childDictionary = [[NSMutableDictionary alloc] init];
    [parentDictionary setObject:childDictionary forKey:stackTop];

    [parseStack replaceObjectAtIndex:parseStackTop
                          withObject:childDictionary];
    [childDictionary release];
  }

  if (schemaStackTop > 0) {
    // Push the formatted element name on the parse stack.
    [parseStack addObject:formattedElementName];

    [currentValue setString:@""];
  }
  else {
    currentItemName = [formattedElementName retain];
  }
  if (formattedElementName != elementName) {
    [formattedElementName release];
  }
  
  // Fast code path for attributes.
  if ([attributeDict count] > 0) {
    NSUInteger parseStackTop = [parseStack count] - 1;
    NSObject* stackTop = [parseStack objectAtIndex:parseStackTop];

    NSMutableDictionary* attributeDictionary = nil;
    for (NSString* attributeName in attributeDict) {
      NSString* formattedAttributeName = keyFormatter ?
          [keyFormatter copyFormattedName:attributeName] : attributeName;
      NSObject* attributeSchema = [self unravelSchema:nextSchema
                                      withElementName:formattedAttributeName];
      if (attributeSchema) {
        // Only allocate attribute dictionary if at least one attribute passes
        // the schema filter. This is important because once an element has
        // attributes, it cannot receive inner text.
        if (!attributeDictionary) {
          if (schemaStackTop > 0) {
            NSMutableDictionary* parentDictionary =
            [parseStack objectAtIndex:(parseStackTop - 1)];
            attributeDictionary = [[NSMutableDictionary alloc]
                                   initWithCapacity:[attributeDict count]];
            [parentDictionary setObject:attributeDictionary forKey:stackTop];
            
            [parseStack replaceObjectAtIndex:parseStackTop
                                  withObject:attributeDictionary];
            [attributeDictionary release];
          }
          else {
            attributeDictionary = (NSMutableDictionary*)stackTop;
          }
        }
        
        [attributeDictionary setObject:[attributeDict
                                        objectForKey:attributeName]
                                forKey:formattedAttributeName];
      }
      if (formattedAttributeName != attributeName) {
        [formattedAttributeName release];
      }
    }
  }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
  if (ignoreDepth > 0)
    return;

  if ([parseStack count] >= 2) {
    [currentValue appendString:string];
  }
}

-(void)parser:(NSXMLParser *)parse didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName {
  if (ignoreDepth > 0) {
    ignoreDepth--;
    return;
  }


  if ([schemaStack count] == 1) {
    // Not parsing an element.
    return;
  }
  [schemaStack removeLastObject];


  NSUInteger parseStackTop = [parseStack count] - 1;
  NSObject* stackTop = [parseStack objectAtIndex:parseStackTop];
  if (parseStackTop == 0) {
    // Done parsing an item.
    [delegate parsedItem:[NSDictionary
                          dictionaryWithDictionary:(NSDictionary*)stackTop]
                    name:currentItemName
                 context:context];
    [(NSMutableDictionary*)stackTop removeAllObjects];
    [currentItemName release];
    currentItemName = nil;
    return;
  }

  if ([stackTop isKindOfClass:[NSString class]]) {
    NSMutableDictionary* parentDictionary = [parseStack
                                             objectAtIndex:(parseStackTop - 1)];
    NSString* propertyValue = [[NSString alloc] initWithString:currentValue];
    [parentDictionary setObject:propertyValue forKey:stackTop];
    [propertyValue release];

    [currentValue setString:@""];
  }
  [parseStack removeLastObject];
}

@end

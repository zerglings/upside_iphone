//
//  ZNModelXmlParser.m
//  ZergSupport
//
//  Created by Victor Costan on 2/16/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNModelXmlParser.h"

#import "ModelSupport.h"
#import "ZNDictionaryXmlParser.h"
#import "ZNFormFieldFormatter.h"


@interface ZNModelXmlParser () <ZNDictionaryXmlParserDelegate>
@end

@implementation ZNModelXmlParser

#pragma mark Lifecycle

// Breaks the master schema apart into a model resolution schema and a parser
// schema.
-(void)splitMasterSchema:(NSDictionary*)masterSchema {
  modelSchema = [[NSMutableDictionary alloc]
                 initWithCapacity:[masterSchema count]];
  parserSchema = [[NSMutableDictionary alloc]
                  initWithCapacity:[masterSchema count]];

  for (NSObject* elementName in masterSchema) {
    NSObject* directive = [masterSchema objectForKey:elementName];

    if ([directive isKindOfClass:[NSArray class]]) {
      [modelSchema setObject:[(NSArray*)directive objectAtIndex:0]
                      forKey:elementName];
      [parserSchema setObject:[(NSArray*)directive objectAtIndex:1]
                       forKey:elementName];
    }
    else if([ZNModel isModelClass:directive]) {
      [modelSchema setObject:directive forKey:elementName];
      [parserSchema setObject:[NSNull null] forKey:elementName];
    }
    else {
      [parserSchema setObject:directive forKey:elementName];
    }
  }
}

-(id)initWithSchema:(NSDictionary*)theSchema
     documentCasing:(ZNFormatterCasing)documentCasing {
  if ((self = [super init])) {
    ZNFormFieldFormatter* keyFormatter =
        [ZNFormFieldFormatter formatterToPropertiesFrom:documentCasing];

    [self splitMasterSchema:theSchema];
    parser = [[ZNDictionaryXmlParser alloc] initWithSchema:parserSchema
                                              keyFormatter:keyFormatter];
    parser.delegate = self;
  }
  return self;
}
-(void)dealloc {
  [modelSchema release];
  [parserSchema release];
  [parser release];
  [super dealloc];
}

@synthesize delegate;

-(void)setContext:(id)context {
  parser.context = context;
}
-(id)context {
  return parser.context;
}

-(BOOL)parseData:(NSData*)data {
  return [parser parseData:data];
}
-(BOOL)parseURL:(NSURL*)url {
  return [parser parseURL:url];
}


#pragma mark ZNDictionaryXmlParser Delegate

-(void)parsedItem:(NSDictionary*)itemData
             name:(NSString*)itemName
          context:(id)context {
  id modelClass = [modelSchema objectForKey:itemName];
  if (modelClass) {
    ZNModel* model = [[modelClass alloc] initWithModel:nil properties:itemData];
    [delegate parsedModel:model context:context];
    [model release];
  }
  else {
    [delegate parsedItem:itemData name:itemName context:context];
  }
}

@end

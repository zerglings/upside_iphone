//
//  ZNModelJsonParser.m
//  ZergSupport
//
//  Created by Victor Costan on 5/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ZNModelJsonParser.h"

#import "ModelSupport.h"
#import "ZNDictionaryJsonParser.h"
#import "ZNFormFieldFormatter.h"
#import "ZNObjectQuery.h"


@interface ZNModelJsonParser () <ZNDictionaryJsonParserDelegate>
-(void)parsedJson:(NSDictionary*)jsonData context:(id)context;
@end


@implementation ZNModelJsonParser

#pragma mark Lifecycle

@synthesize context, delegate;

-(id)initWithSchema:(NSArray*)schema
     documentCasing:(ZNFormatterCasing)documentCasing {
  NSAssert([schema count] % 2 == 0,
           @"Schema queries and models are not paired up");
  
  if ((self = [super init])) {
    null = [NSNull class];
    
    // Set up parser.
    parser = [[ZNDictionaryJsonParser alloc]
              initWithKeyFormatter:[ZNFormFieldFormatter
                                    formatterToPropertiesFrom:documentCasing]];
    parser.delegate = self;
    
    // Compile schema.
    compiledSchema = [[NSMutableArray alloc] initWithCapacity:[schema count]];
    for (NSUInteger i = 0; i < [schema count]; i += 2) {
      Class modelClass = [schema objectAtIndex:i];      
      if ([ZNModel isModelClass:modelClass]) {
        [compiledSchema addObject:modelClass];
      }
      else {
        [compiledSchema addObject:null];
      }
      NSString* queryString = [schema objectAtIndex:(i + 1)];
      [compiledSchema addObject:[ZNObjectQuery compile:queryString]];
    }
  }
  return self;
}

-(void)dealloc {
  [parser release];
  [compiledSchema release];
  [super dealloc];
}

-(void)setContext:(id)context {
  parser.context = context;
}
-(id)context {
  return parser.context;
}

-(BOOL)parseData:(NSData*)data {
  return [parser parseData:data];
}

#pragma mark ZNDictionaryJsonParser delegate

-(void)parsedJson:(NSDictionary*)jsonData context:(id)context {
  for (NSUInteger i = 0; i < [compiledSchema count]; i += 2) {
    Class modelClass = [compiledSchema objectAtIndex:i];
    ZNObjectQuery* query = [compiledSchema objectAtIndex:(i + 1)];
    
    NSArray* results = [query run:jsonData];
    for (NSObject* result in results) {
      if (modelClass == null) {
        [delegate parsedObject:result context:context];
      }
      else {
        NSAssert([result isKindOfClass:[NSDictionary class]],
                 @"Non-hash JSON object used to initialize model");
        
        if ([result isKindOfClass:[NSDictionary class]]) {
          ZNModel* model =
              [[modelClass alloc] initWithModel:nil
                                     properties:(NSDictionary*)result];
          [delegate parsedModel:model context:context];
          [model release];
        }
      }
    }
    [results release];
  }
}

@end

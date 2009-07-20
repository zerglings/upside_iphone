//
//  ZNModelJsonParser.m
//  ZergSupport
//
//  Created by Victor Costan on 5/3/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNModelJsonParser.h"

#import "ModelSupport.h"
#import "ZNObjectJsonParser.h"
#import "ZNFormFieldFormatter.h"
#import "ZNObjectQuery.h"


@interface ZNModelJsonParser () <ZNObjectJsonParserDelegate>
@end


@implementation ZNModelJsonParser

#pragma mark Lifecycle

@synthesize delegate;

-(id)initWithQueries:(NSArray*)queries
      documentCasing:(ZNFormatterCasing)documentCasing {
  NSAssert([queries count] % 2 == 0,
           @"Query set has a dangling model (without a query)");

  if ((self = [super init])) {
    null = [NSNull class];

    // Set up parser.
    parser = [[ZNObjectJsonParser alloc]
              initWithKeyFormatter:[ZNFormFieldFormatter
                                    formatterToPropertiesFrom:documentCasing]];
    parser.delegate = self;

    // Compile schema.
    compiledQueries = [[NSMutableArray alloc] initWithCapacity:[queries count]];
    for (NSUInteger i = 0; i < [queries count]; i += 2) {
      Class modelClass = [queries objectAtIndex:i];
      if ([ZNModel isModelClass:modelClass]) {
        [compiledQueries addObject:modelClass];
      }
      else {
        [compiledQueries addObject:null];
      }
      NSString* queryString = [queries objectAtIndex:(i + 1)];
      ZNObjectQuery* query = [ZNObjectQuery newCompile:queryString];
      [compiledQueries addObject:query];
      [query release];
    }
  }
  return self;
}

-(void)dealloc {
  [parser release];
  [compiledQueries release];
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

-(void)parsedJson:(NSObject*)jsonData context:(id)context {
  for (NSUInteger i = 0; i < [compiledQueries count]; i += 2) {
    Class modelClass = [compiledQueries objectAtIndex:i];
    ZNObjectQuery* query = [compiledQueries objectAtIndex:(i + 1)];

    NSArray* results = [query newRun:jsonData];
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

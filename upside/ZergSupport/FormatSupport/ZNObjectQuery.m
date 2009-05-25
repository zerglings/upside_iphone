//
//  ZNObjectQuery.m
//  ZergSupport
//
//  Created by Victor Costan on 5/2/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNObjectQuery.h"

#pragma mark Fast C Code

static NSInteger ZNQueryIndexFromElement(NSString* element) {
  NSUInteger index = 0;
  for (NSUInteger i = 0; i < [element length]; i++) {
    unichar character = [element characterAtIndex:i];
    if (!isdigit(character)) {
      return -1;
    }
    index *= 10;
    index += character - '0';
  }
  return index;
}

static void ZNQueryRun(NSObject* root, NSArray* query, NSUInteger offset,
                       NSMutableArray* results) {
  // Terminal condition.
  if (offset == [query count]) {
    [results addObject:root];
    return;
  }

  // Analyze query element.
  NSObject* element = [query objectAtIndex:offset];
  if ([root isKindOfClass:[NSDictionary class]]) {  // Querying a hash.
    if ([element isKindOfClass:[NSString class]]) {
      NSObject* newRoot = [(NSDictionary*)root objectForKey:element];
      if (newRoot != nil) {
        ZNQueryRun(newRoot, query, offset + 1, results);
      }
    }
    else {
      BOOL multiExpand = [(NSNumber*)element boolValue];
      // NOTE: the compiler should ensure that the next element after a wild
      //       card is concrete (and therefore a String)
      if (offset + 1 < [query count]) {
        element = [query objectAtIndex:(offset + 1)];
      }
      else {
        element = nil;
      }
      for (NSString* key in (NSDictionary*)root) {
        NSObject* newRoot = [(NSDictionary*)root objectForKey:key];
        if ([(NSString*)element isEqualToString:key]) {
          ZNQueryRun(newRoot, query, offset + 2, results);
        }
        else {
          ZNQueryRun(newRoot, query, multiExpand ? offset : offset + 1,
                     results);
        }
      }
    }
  }
  else if ([root isKindOfClass:[NSArray class]]) {  // Querying an array.
    if ([element isKindOfClass:[NSString class]]) {
      NSInteger index = ZNQueryIndexFromElement((NSString*)element);
      if (index >= 0 && index < [(NSArray*)root count]) {
        ZNQueryRun([(NSArray*)root objectAtIndex:index], query, offset + 1,
                   results);
      }
    }
    else {
      BOOL multiExpand = [(NSNumber*)element boolValue];
      // NOTE: the compiler should ensure that the next element after a wild
      //       card is concrete (and therefore a String)
      NSInteger index;
      if (offset + 1 < [query count]) {
        element = [query objectAtIndex:(offset + 1)];
        index = ZNQueryIndexFromElement((NSString*)element);
      }
      else {
        element = nil;
        index = -1;
      }
      if (index >= 0 && index < [(NSArray*)root count]) {
        ZNQueryRun([(NSArray*)root objectAtIndex:index], query, offset + 2,
                   results);
      }
      else {
        for (NSObject* newRoot in (NSArray*)root) {
          ZNQueryRun(newRoot, query, multiExpand ? offset : offset + 1,
                     results);
        }
      }
    }
  }

  // Primitive, back out.
  return;
}

#pragma mark Objective C Code

@implementation ZNObjectQuery

-(NSArray*)newRun:(NSObject*)object {
  NSMutableArray* results = [[NSMutableArray alloc] init];
  ZNQueryRun(object, components, 0, results);

  NSArray* returnValue = [[NSArray alloc] initWithArray:results];
  [results release];
  return returnValue;
}

// Splits a query string into components.
//
// This deviates from the convention of returning immutable objects because the
// return value is a private object to ZNDictionaryQuery, so it cannot be
// modified by accident.
+(NSMutableArray*)copyQueryStringSplit:(NSString*)queryString {
  NSMutableArray* array = [[NSMutableArray alloc] init];

  // NOTE: we're adding the separator at the query's end as a sentinel, to avoid
  //       a special case for the last component in the query
  NSUInteger queryLength = [queryString length];
  unichar* buffer = (unichar*)calloc(queryLength + 1, sizeof(unichar));
  [queryString getCharacters:buffer];
  unichar separator = buffer[0];
  unichar* bufferEnd = buffer + queryLength;
  *bufferEnd = separator;

  unichar* componentStart = buffer + 1;
  for (buffer++; buffer <= bufferEnd; buffer++) {
    if (*buffer == separator) {
      NSUInteger componentLength = buffer - componentStart;
      NSObject* component = nil;
      if (componentLength == 1) {
        // Check for wild-card components.
        switch (*componentStart) {
          case '?':
            component = [[NSNumber alloc] initWithBool:NO];
            break;
          case '*':
            component = [[NSNumber alloc] initWithBool:YES];
            break;
        }
      }
      if (component == nil) {
        component = [[NSString alloc] initWithCharacters:componentStart
                                                  length:componentLength];
      }
      else {
        // TODO(overmind): compress multiple '*' or '?'
      }
      [array addObject:component];
      [component release];
      componentStart = buffer + 1;
    }
  }

  return array;
}

-(id)initWithQueryString:(NSString*)queryString {
  if ((self = [super init])) {
    components = [ZNObjectQuery copyQueryStringSplit:queryString];
  }
  return self;
}

-(void)dealloc {
  [components release];
  [super dealloc];
}


+(ZNObjectQuery*)newCompile:(NSString*)queryString {
  return [[ZNObjectQuery alloc] initWithQueryString:queryString];
}

@end

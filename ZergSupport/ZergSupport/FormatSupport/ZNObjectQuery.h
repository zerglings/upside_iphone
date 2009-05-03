//
//  ZNObjectQuery.h
//  ZergSupport
//
//  Created by Victor Costan on 5/2/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>


// Barebones query language for extracting values out of native collections
// (NSDictionaries + NSArrays + NSStrings + primitives). The query language
// follows the idea of XPath (or CSS selectors), but only supports a couple of
// basic features.
//
// Queries consist of components separated by a character. The separator
// character is the first character in the query.
//   Ex: "/a/b/c" and ".a.b.c" have the components "a", "b", and "c"
//
// A component can be a string, which forces a match against the specified
// dictionary key or array index, or it can be the wildcard '?' or '*'. '?'
// matches the rest of the query against the current object or any of its
// children, while '*' matches the rest of the query against any of the object's
// descendants.
//   Ex: "/a/?/c" will match 1 and 2 in {'a':{'b': {'c': 1}, 'd': {'c': 2}}}
@interface ZNObjectQuery : NSObject {
  NSArray* components;
}

// Turn the given string into a query.
+(ZNObjectQuery*)compile:(NSString*)queryString;

// Run the query on the given object.
//
// The object should be a NSDictionary or NSArray. The query will return no
// results otherwise.
-(NSArray*)run:(NSObject*)object;

// Designated initializer.
-(id)initWithQueryString:(NSString*)queryString;

@end

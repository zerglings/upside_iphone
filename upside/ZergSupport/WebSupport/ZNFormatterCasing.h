//
//  ZNFormatterCasing.h
//  upside
//
//  Created by Victor Costan on 1/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  // no particular casing convetion
  kZNFormatterNoCase = 0,
  // snake_case
  kZNFormatterSnakeCase = 1,  
  // camelCase, except the first letter is lower case
  kZNFormatterLCamelCase = 2
} ZNFormatterCasing;

//
//  ZNFormFieldFormatter+Snake2LCamel.h
//  upside
//
//  Created by Victor Costan on 1/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ZNFormFieldFormatter.h"


@interface ZNFormFieldFormatter (Snake2LCamel)

+ (ZNFormFieldFormatter*) snakeToLCamelFormatter;

+ (ZNFormFieldFormatter*) lCamelToSnakeFormatter;

@end

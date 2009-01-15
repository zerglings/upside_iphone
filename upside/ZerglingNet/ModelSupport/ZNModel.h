//
//  Model.h
//  upside
//
//  Created by Victor Costan on 1/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Base class for the models using ModelSupport.
@interface ZNModel : NSObject {

}

- (void) loadFromDictionary: (NSDictionary*)dictionary;
- (NSDictionary*) saveToDictionary: (NSDictionary*)dictionary;

@end

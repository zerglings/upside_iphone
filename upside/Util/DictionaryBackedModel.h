//
//  DictionaryBackedModel.h
//  upside
//
//  Created by Victor Costan on 1/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DictionaryBackedModel : NSObject {
	NSDictionary* props;
}

// Initializes the order's state from a dictionary of properties.
- (id)initWithProperties:(NSDictionary*)properties;

// The raw properties behind this order.
// Prefer accessor methods to reaching inside the properties directly.
// Use the strings in this file as keys in the properties dictionary.
@property (nonatomic, readonly) NSDictionary* properties;

@end

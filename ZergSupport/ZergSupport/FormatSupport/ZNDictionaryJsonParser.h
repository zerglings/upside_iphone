//
//  ZNDictionaryJsonParser.h
//  ZergSupport
//
//  Created by Victor Costan on 5/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZNDictionaryJsonParserDelegate

-(void)parsedJson:(NSDictionary*)jsonData context:(id)context;

@end


@interface ZNDictionaryJsonParser : NSObject {
  id<ZNDictionaryJsonParserDelegate> delegate;
  id context;

}

@property (nonatomic, assign) id context;
@property (nonatomic, assign) id<ZNDictionaryJsonParserDelegate> delegate;

// Initializes a parser, which can be used multiple times.
-(id)init;

// Parses a JSON object inside an NSData instance.
-(BOOL)parseData:(NSData*)data;

@end

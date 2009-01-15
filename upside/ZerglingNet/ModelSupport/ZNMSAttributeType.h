//
//  ZNAttributeType.h
//  upside
//
//  Created by Victor Costan on 1/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZNMSAttributeType : NSObject {

}

+ (ZNMSAttributeType*) newTypeFromString: (const char*)encodedType;

@end

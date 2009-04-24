//
//  ZNSha2Digest.h
//  ZergSupport
//
//  Created by Victor Costan on 4/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZNSha2Digest : NSObject {
}

// SHA-256 digest of the given data.
+(NSData*)copyDigest:(NSData*)data;

// Hexadecimal form (popular on the Web) of a SHA-256 digest of the given data. 
+(NSString*)copyHexDigest:(NSData*)data;

@end

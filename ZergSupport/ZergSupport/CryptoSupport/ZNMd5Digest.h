//
//  ZNMd5Digest.h
//  ZergSupport
//
//  Created by Victor Costan on 4/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZNDigester.h"


// MD5 has known weaknesses and is not recommended for use in signatures.
//
// However, it's convenient to have around to generate keys and IVs for AES-128.
@interface ZNMd5Digest : NSObject {

}

// MD5 digest of the given data.
+(NSData*)copyDigest:(NSData*)data;

// Hexadecimal form (popular on the Web) of a MD5 digest of the given data. 
+(NSString*)copyHexDigest:(NSData*)data;

// An object conforming to the ZNDigester protocol.
+(id<ZNDigester>)digester;
@end

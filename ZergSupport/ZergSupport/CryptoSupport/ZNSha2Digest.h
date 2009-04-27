//
//  ZNSha2Digest.h
//  ZergSupport
//
//  Created by Victor Costan on 4/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

#import "ZNDigester.h"


@interface ZNSha2Digest : NSObject {
}

// SHA-256 digest of the given data.
+(NSData*)copyDigest:(NSData*)data;

// Hexadecimal form (popular on the Web) of a SHA-256 digest of the given data.
+(NSString*)copyHexDigest:(NSData*)data;

// An object conforming to the ZNDigester protocol.
+(id<ZNDigester>)digester;
@end

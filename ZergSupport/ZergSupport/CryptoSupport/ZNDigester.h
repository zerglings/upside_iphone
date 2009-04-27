//
//  ZNDigest.h
//  ZergSupport
//
//  Created by Victor Costan on 4/26/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>


@protocol ZNDigester

// Produce a digest of the given data.
-(NSData*)copyDigest:(NSData*)data;

// Produce a digest of the given data, in hexadecimal form (popular on the Web).
-(NSString*)copyHexDigest:(NSData*)data;

@end

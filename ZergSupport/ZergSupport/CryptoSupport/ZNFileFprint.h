//
//  ZNFileFprint.h
//  ZergSupport
//
//  Created by Victor Costan on 4/26/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

@protocol ZNCipherClass;
@protocol ZNDigester;


@interface ZNFileFprint : NSObject {

}

// Fingerprints the content of a file using one or two keys.
//
// The fingerprinting process encrypts the file with the first key, and
// optionally uses the second key as an initialization vector in the encryption.
// The encryption is done in CBC mode, and its result is digested using a
// cryptographic hash.
//
// The process is hard to hex-patch, so
+(NSData*)copyFprint:(NSString*)filePath
                 key:(NSData*)key
                  iv:(NSData*)initializationVector
         cipherClass:(id<ZNCipherClass>)cipherClass
            digester:(id<ZNDigester>)digester;

// Fingerprints the content of a file using one or two keys.
//
// The result is formatted as a hex string, which is easier to use with Web
// services. The process is identical to
// +copyFileFprint:key:iv:cipherClass:digester.
+(NSString*)copyHexFprint:(NSString*)filePath
                      key:(NSData*)key
                       iv:(NSData*)initializationVector
              cipherClass:(id<ZNCipherClass>)cipherClass
                 digester:(id<ZNDigester>)digester;
@end

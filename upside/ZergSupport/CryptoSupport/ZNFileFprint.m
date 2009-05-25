//
//  ZNFileFprint.m
//  ZergSupport
//
//  Created by Victor Costan on 4/26/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNFileFprint.h"

#import "ZNCipher.h"
#import "ZNCipherClass.h"
#import "ZNDigester.h"


@implementation ZNFileFprint

// NSData with a file's contents.
+(NSData*)copyFileData:(NSString*)filePath {
  return [[NSData alloc] initWithContentsOfFile:filePath];
}

// Computes a fingerprint over some data (presumably a file's contents).
+(NSData*)copyDataFprint:(NSData*)data
                     key:(NSData*)key
                      iv:(NSData*)initializationVector
             cipherClass:(id<ZNCipherClass>)cipherClass
                digester:(id<ZNDigester>)digester {
  NSObject<ZNCipher> *cipher = [[cipherClass alloc] initWithKey:key
                                                        encrypt:YES];
  NSData* cryptedData = [cipher newCrypted:data withIv:initializationVector];
  [cipher release];

  NSData* fprint = [digester copyDigest:cryptedData];
  [cryptedData release];
  return fprint;
}

// Computes a hex fingerprint over some data (presumably a file's contents).
+(NSString*)copyHexDataFprint:(NSData*)data
                          key:(NSData*)key
                           iv:(NSData*)initializationVector
                  cipherClass:(id<ZNCipherClass>)cipherClass
                     digester:(id<ZNDigester>)digester {
  NSObject<ZNCipher> *cipher = [[cipherClass alloc] initWithKey:key
                                                        encrypt:YES];
  NSData* cryptedData = [cipher newCrypted:data withIv:initializationVector];
  [cipher release];

  NSString* hexFprint = [digester copyHexDigest:cryptedData];
  [cryptedData release];
  return hexFprint;
}

+(NSData*)copyFprint:(NSString*)filePath
                 key:(NSData*)key
                  iv:(NSData*)initializationVector
         cipherClass:(id<ZNCipherClass>)cipherClass
            digester:(id<ZNDigester>)digester {
  NSData* fileData = [ZNFileFprint copyFileData:filePath];
  NSData* fprint = [ZNFileFprint copyDataFprint:fileData
                                            key:key
                                             iv:initializationVector
                                    cipherClass:cipherClass
                                       digester:digester];
  [fileData release];
  return fprint;
}

+(NSString*)copyHexFprint:(NSString*)filePath
                      key:(NSData*)key
                       iv:(NSData*)initializationVector
              cipherClass:(id<ZNCipherClass>)cipherClass
                 digester:(id<ZNDigester>)digester {
  NSData* fileData = [ZNFileFprint copyFileData:filePath];
  NSString* hexFprint = [ZNFileFprint copyHexDataFprint:fileData
                                                    key:key
                                                     iv:initializationVector
                                            cipherClass:cipherClass
                                               digester:digester];
  [fileData release];
  return hexFprint;
}

@end

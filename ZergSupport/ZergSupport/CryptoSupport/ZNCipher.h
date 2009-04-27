/*
 *  ZNCipher.h
 *  ZergSupport
 *
 *  Created by Victor Costan on 4/26/09.
 *  Copyright 2009 Zergling.Net. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

// A cipher encapsulates an encryption algorithm and key.
@protocol ZNCipher

// Initializes crypter / decrypter using CBC.
//
// If doEncrypt is YES, -crypt will encrypt the data that is given to it,
// otherwise it will decrypt the data.
-(NSObject<ZNCipher>*)initWithKey:(NSData*)theKey encrypt:(BOOL)doEncrypt;

// Designated crypter / decrypter initializer.
//
// If doEncrypt is YES, -crypt will encrypt the data that is given to it,
// otherwise it will decrypt the data. If useCbc is YES, the
// encryption/decryption will be done using CBC mode, otherwise it will be done
// using ECB mode.
-(NSObject<ZNCipher>*)initWithKey:(NSData*)theKey
                          encrypt:(BOOL)doEncrypt
                           useCbc:(BOOL)useCbc;

// Encrypts/decrypts the given data.
-(NSData*)crypt:(NSData*)data;

// Encrypts/decrypts the given data.
//
// If the given IV is nil, a default IV consisting of 0s will be used.
// The IV is ignored in ECB mode.
-(NSData*)crypt:(NSData*)data withIv:(NSData*)theInitializationVector;

@end

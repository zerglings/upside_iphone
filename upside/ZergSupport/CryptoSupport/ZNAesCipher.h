//
//  ZNAesCipher.h
//  ZergSupport
//
//  Created by Victor Costan on 4/23/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

#import "ZNCipher.h"
#import "ZNCipherClass.h"

@interface ZNAesCipher : NSObject <ZNCipher> {
  CCCryptorRef cryptorRef;
}

// Initializes AES crypter / decrypter using CBC.
//
// If doEncrypt is YES, -crypt will encrypt the data that is given to it,
// otherwise it will decrypt the data.
-(id)initWithKey:(NSData*)theKey encrypt:(BOOL)doEncrypt;

// Designated AES crypter / decrypter initializer.
//
// If doEncrypt is YES, -crypt will encrypt the data that is given to it,
// otherwise it will decrypt the data. If useCbc is YES, the
// encryption/decryption will be done using CBC mode, otherwise it will be done
// using ECB mode.
-(id)initWithKey:(NSData*)theKey encrypt:(BOOL)doEncrypt useCbc:(BOOL)useCbc;

// Encrypts/decrypts the given data.
-(NSData*)newCrypted:(NSData*)data;

// Encrypts/decrypts the given data.
//
// If the given IV is nil, a default IV consisting of 0s will be used.
// The IV is ignored in ECB mode.
-(NSData*)newCrypted:(NSData*)data withIv:(NSData*)theInitializationVector;

// An object conforming to the ZNCipherClass protocol.
+(id<ZNCipherClass>)cipherClass;

@end

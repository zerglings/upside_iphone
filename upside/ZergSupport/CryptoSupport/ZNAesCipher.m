//
//  ZNAesCipher.m
//  ZergSupport
//
//  Created by Victor Costan on 4/23/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNAesCipher.h"


@implementation ZNAesCipher

-(id)initWithKey:(NSData*)theKey encrypt:(BOOL)doEncrypt {
  return [self initWithKey:theKey encrypt:doEncrypt useCbc:YES];
}

-(id)initWithKey:(NSData*)theKey encrypt:(BOOL)doEncrypt useCbc:(BOOL)useCbc {
  if ((self = [super init])) {
    CCCryptorStatus status =
        CCCryptorCreate(doEncrypt ? kCCEncrypt : kCCDecrypt,
                        kCCAlgorithmAES128, useCbc ? 0 : kCCOptionECBMode,
                        [theKey bytes], [theKey length],
                        NULL, &cryptorRef);
    status;  // This avoids a warning when assertions are disabled.
    NSAssert(status == kCCSuccess, @"CCCryptorCreate failed");
  }
  return self;
}

-(void)dealloc {
  CCCryptorRelease(cryptorRef);

  [super dealloc];
}

-(NSData*)newCrypted:(NSData*)data {
  return [self newCrypted:data withIv:nil];
}

-(NSData*)newCrypted:(NSData*)data withIv:(NSData*)theInitializationVector {
  NSUInteger inputLength = [data length];
  NSUInteger paddingLength = (16 - (inputLength & 0x0f)) & 0x0f;
  size_t outputLength = CCCryptorGetOutputLength(cryptorRef,
                                                 inputLength + paddingLength,
                                                 NO);
  size_t outputWritten, outputWritten2;
  void* outputBytes = CFAllocatorAllocate(kCFAllocatorDefault, outputLength, 0);
  NSAssert(outputBytes,
           @"Failed to allocate memory for encryption operation output");

  CCCryptorReset(cryptorRef, [theInitializationVector bytes]);
  CCCryptorUpdate(cryptorRef, [data bytes], inputLength, outputBytes,
                  outputLength, &outputWritten);
  if (paddingLength != 0) {
    // TODO(overmind): proper padding?
    CCCryptorUpdate(cryptorRef, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", paddingLength,
                    outputBytes + outputWritten, outputLength - outputWritten,
                    &outputWritten2);
    outputWritten += outputWritten2;
  }
  CCCryptorFinal(cryptorRef, outputBytes + outputWritten,
                 outputLength - outputWritten, &outputWritten2);

  return [[NSData alloc] initWithBytesNoCopy:outputBytes
                                      length:outputWritten + outputWritten2
                                freeWhenDone:YES];
}

+(id<ZNCipherClass>)cipherClass {
  return (id<ZNCipherClass>)[ZNAesCipher class];
}

@end

//
//  ZNAesCipher.m
//  ZergSupport
//
//  Created by Victor Costan on 4/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ZNAesCipher.h"


@implementation ZNAesCipher

- (id)initWithKey:(NSData*)theKey encrypt:(BOOL)doEncrypt {
  return [self initWithKey:theKey encrypt:doEncrypt useCbc:YES];
}

-(id)initWithKey:(NSData*)theKey encrypt:(BOOL)doEncrypt useCbc:(BOOL)useCbc {
  if ((self = [super init])) {
    CCCryptorStatus status =
        CCCryptorCreate(doEncrypt ? kCCEncrypt : kCCDecrypt,
                        kCCAlgorithmAES128, useCbc ? 0 : kCCOptionECBMode,
                        [theKey bytes], [theKey length],
                        NULL, &cryptorRef);
    NSAssert(status == kCCSuccess, @"CCCryptorCreate failed");
  }
  return self;
}

-(void)dealloc {
  CCCryptorRelease(cryptorRef);
  
  [super dealloc];
}

-(NSData*)crypt:(NSData*)data {
  return [self crypt:data withIv:nil];
}

-(NSData*)crypt:(NSData*)data withIv:(NSData*)theInitializationVector {
  NSUInteger inputLength = [data length];
  size_t outputLength = CCCryptorGetOutputLength(cryptorRef, inputLength, NO);
  size_t outputWritten, outputWritten2;
  void* outputBytes = CFAllocatorAllocate(kCFAllocatorDefault, outputLength, 0);
  NSAssert(outputBytes,
           @"Failed to allocate memory for encryption operation output");
  
  CCCryptorReset(cryptorRef, [theInitializationVector bytes]);
  CCCryptorUpdate(cryptorRef, [data bytes], inputLength, outputBytes,
                  outputLength, &outputWritten);
  CCCryptorFinal(cryptorRef, outputBytes + outputWritten,
                 outputLength - outputWritten, &outputWritten2);
  
  return [[NSData alloc] initWithBytesNoCopy:outputBytes
                                      length:outputWritten + outputWritten2
                                freeWhenDone:YES];
}

@end

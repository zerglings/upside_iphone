/*
 *  ZNCipherClass.h
 *  ZergSupport
 *
 *  Created by Victor Costan on 4/26/09.
 *  Copyright 2009 Zergling.Net. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

#import "ZNCipher.h"

// A cipher class creates ciphers using a certain encryption algorithm.
@protocol ZNCipherClass

// Declaration for +alloc in Class that will make the type system happy.
-(NSObject<ZNCipher>*)alloc;

@end

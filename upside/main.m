//
//  main.m
//  StockPlay
//
//  Created by Victor Costan on 1/2/09.
//  Copyright Zergling.Net 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CryptoSupport.h"

int main(int argc, char *argv[]) {
  ZNDebugIntegrity();
  
  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
  int retVal = UIApplicationMain(argc, argv, nil, nil);
  [pool release];
  return retVal;
}

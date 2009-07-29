//
//  _ZNExtUIApplicationMain.h
//  ZergSupport
//
//  Created by Victor Costan on 7/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//
//  This file should be included in the project's main.m file. It activates the
//  anti-debugging integrity protection, and initializes the extended
//  UIApplication for multiple-delegate support.
//
//  If you cannot include this file, you should merge its functionality into
//  your main.m file. ZergSupport's push notifications code won't work
//  otherwise.


#import <UIKit/UIKit.h>
#import "ZNDebugIntegrity.h"

#if !defined(ZN_EXT_UI_APPLICATION_MAIN_DELEGATE)
#define ZN_EXT_UI_APPLICATION_MAIN_DELEGATE nil
#endif  // !defined(ZN_EXT_UI_APPLICATION_MAIN_DELEGATE)


int main(int argc, char *argv[]) {
  ZNDebugIntegrity();

  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
  int retVal = UIApplicationMain(argc, argv, @"ZNExtUIApplication",
                                 ZN_EXT_UI_APPLICATION_MAIN_DELEGATE);
  [pool release];
  return retVal;
}

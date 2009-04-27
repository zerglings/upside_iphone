//
//  ZNAppFprint.h
//  ZergSupport
//
//  Created by Victor Costan on 4/27/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>


@interface ZNAppFprint : NSObject {

}

// The application fingerprint.
//
// TODO(overmind): document the fingerprinting process.
//
// The unit tests verify this computation against the code at:
// http://github.com/costan/zn_testbed/blob/master/lib/crypto_support/app_fprint.rb
+(NSString*)hexAppFprint;

@end

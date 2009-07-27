//
//  ZNStringEncoder.h
//  ZergSupport
//
//  Created by Victor Costan on 7/26/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>


@interface ZNStringEncoder : NSObject {
}

+(NSString*)copyHexStringForData:(NSData*)data;

+(NSString*)copyHexStringForBytes:(const uint8_t*)data
                           length:(NSUInteger)length;

@end

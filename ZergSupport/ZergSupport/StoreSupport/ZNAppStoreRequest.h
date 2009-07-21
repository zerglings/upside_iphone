//
//  ZNAppStoreRequest.h
//  ZergSupport
//
//  Created by Victor Costan on 7/21/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

@class SKRequest;


@interface ZNAppStoreRequest : NSObject {
  SKRequest* skRequest;
  NSObject* target;
  SEL action;
}

+(void)getInfoForProductIds:(NSArray*)productIds
                     target:(id)target
                     action:(SEL)action;

+(void)getInfoForProductId:(NSString*)productId
                    target:(id)target
                    action:(SEL)action;


-(id)initWithTarget:(id)target action:(SEL)action;

-(void)getInfoForProductIds:(NSArray*)productIds;

@end

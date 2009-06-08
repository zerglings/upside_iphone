//
//  ZNMSModelAttributeType.h
//  ZergSupport
//
//  Created by Victor Costan on 6/7/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>


@interface ZNMSModelAttributeType : NSObject {
  Class modelClass;
}
@property (nonatomic, assign) Class modelClass;

-(id)initWithModelClass:(Class)modelClass;

@end

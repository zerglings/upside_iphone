//
//  ZNAttributeType.h
//  ZergSupport
//
//  Created by Victor Costan on 1/14/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

#import <objc/runtime.h>

@class ZNModel;
@class ZNModelDefinitionAttribute;

@interface ZNMSAttributeType : NSObject {

}

-(NSObject*)copyBoxedAttribute:(ZNModelDefinitionAttribute*)attribute
                    inInstance:(ZNModel*)instance
                   forceString:(BOOL)forceString;

-(void)unboxAttribute:(ZNModelDefinitionAttribute*)attribute
       inInstance:(ZNModel*)instance
           from:(NSObject*)boxedObject;

-(NSObject*)copyStringForBoxedValue:(NSObject*)boxedValue;

+(NSString*)copyStringForBoxedValue:(NSObject*)boxedValue;

+(ZNMSAttributeType*)copyTypeFromString:(const char*)encodedType;

+(ZNMSAttributeType*)copyTypeFromValue:(NSObject*)value;

@end

//
//  ActivationState+Signature.h
//  StockPlay
//
//  Created by Victor Costan on 1/29/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "ActivationState.h"

@interface ActivationState (Signature)

// Generates a signature that can be used in Game server requests.
-(NSDictionary*)requestSignature;

@end

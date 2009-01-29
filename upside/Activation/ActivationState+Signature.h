//
//  ActivationState+Signature.h
//  upside
//
//  Created by Victor Costan on 1/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ActivationState.h"

@interface ActivationState (Signature)

// Generates a signature that can be used in Game server requests.
- (NSDictionary*)requestSignature;

@end

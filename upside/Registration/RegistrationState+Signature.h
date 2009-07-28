//
//  RegistrationState+Signature.h
//  StockPlay
//
//  Created by Victor Costan on 1/29/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "RegistrationState.h"

@interface RegistrationState (Signature)

// Generates a signature that can be used in Game server requests.
-(NSDictionary*)requestSignature;

@end

//
//  ActivationCommController.h
//  upside
//
//  Created by Victor Costan on 1/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ActivationCommController : NSObject {
	NSString* activationService;
}

- (void) activateDevice;

@end

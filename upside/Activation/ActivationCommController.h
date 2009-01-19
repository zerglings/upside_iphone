//
//  ActivationCommController.h
//  upside
//
//  Created by Victor Costan on 1/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ActivationCommDelegate
- (void)activationFailed: (NSError*)error;
- (void)activationSucceeded;
@end

@interface ActivationCommController : NSObject {
	NSString* activationService;
	NSDictionary* resposeModels;
	
	IBOutlet id<ActivationCommDelegate> delegate;
}

- (void) activateDevice;

@end

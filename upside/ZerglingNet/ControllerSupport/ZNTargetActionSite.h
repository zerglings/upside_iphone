//
//  ZNTargetActionSite.h
//  upside
//
//  Created by Victor Costan on 1/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// A poor man's closure.
@protocol ZNTargetActionSite

// Performs the actions on the targets.
- (void)perform;

// Performs the actions on the targets, supplying an argument.
- (void)performWithObject: (id)object;
@end

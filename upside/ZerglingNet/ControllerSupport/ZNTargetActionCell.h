//
//  ZNTargetActionCell.h
//  upside
//
//  Created by Victor Costan on 1/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Wraps a collection of targets and actions to be invoked on the targets.
//
// Intended to come in handy for senders in the Target-Action paradigm.
// This is mutable, and is not thread-safe.
@interface ZNTargetActionCell : NSObject {
  NSMutableSet* targetActionPairs;
}

// Adds a Target-Action to this cell.
- (void)addTarget: (id)target action: (SEL)action;

// Removes a Target-Action from this cell.
- (void)removeTarget: (id)target action: (SEL)action;

// Performs the actions on the targets.
- (void)perform;

// Performs the actions on the targets, supplying an argument.
- (void)performWithObject: (id)object;

@end

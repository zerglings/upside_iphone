//
//  ZNTargetActionCell.m
//  upside
//
//  Created by Victor Costan on 1/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ZNTargetActionCell.h"

#import "ZNTargetActionPair.h"

@implementation ZNTargetActionCell

- (id)init {
  if ((self = [super init])) {
    targetActionPairs = [[NSMutableSet alloc] init];
  }
  return self;
}
- (void)deinit {
  [targetActionPairs release];
}

- (void)addTarget: (id)target action: (SEL)action {
  ZNTargetActionPair* pair =
      [[ZNTargetActionPair alloc] initWithTarget:target action:action];
  [targetActionPairs addObject:pair];
  [pair release];
}

- (void)removeTarget: (id)target action: (SEL)action {
  ZNTargetActionPair* pair =
      [[ZNTargetActionPair alloc] initWithTarget:target action:action];
  [targetActionPairs removeObject:pair];
  [pair release];  
}

- (void)perform {
  for (ZNTargetActionPair* pair in targetActionPairs) {
    NSAssert([pair isKindOfClass:[ZNTargetActionPair class]],
             @"A foreign object managed to sneak in");
    [pair.target performSelector:pair.action];
  }
}

- (void)performWithObject: (id)object {
  for (ZNTargetActionPair* pair in targetActionPairs) {
    NSAssert([pair isKindOfClass:[ZNTargetActionPair class]],
             @"A foreign object managed to sneak in");
    [pair.target performSelector:pair.action withObject:object];
  }  
}

@end

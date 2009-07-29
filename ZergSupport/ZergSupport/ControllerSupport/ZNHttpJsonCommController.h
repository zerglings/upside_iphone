//
//  ZNHttpJsonCommController.h
//  upside
//
//  Created by Victor Costan on 6/20/09.
//  Copyright 2009 MIT. All rights reserved.
//

#import <Foundation/Foundation.h>


// Plumbing for communication controllers based on ZNHttpJsonRequest.
@interface ZNHttpJsonCommController : NSObject {
  NSArray* responseQueries;
  id target;
  SEL action;
}

// Designated initializer.
-(id)initWithTarget:(id)target action:(SEL)action;

// Starts a service request.
//
// Subclasses should provide a friendlier method that calls this method.
-(void)callService:(NSString*)service
            method:(NSString*)method
              data:(NSDictionary*)request;

// Subclasses must override this to provide ZNHttpJsonRequest' response queries.
+(NSArray*)copyResponseQueries;
@end

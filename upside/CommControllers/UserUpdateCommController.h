//
//  UserUpdateCommController.h
//  upside
//
//  Created by Victor Costan on 6/20/09.
//  Copyright 2009 MIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ControllerSupport.h"

@class User;


@interface UserUpdateCommController : ZNHttpJsonCommController {
}
-(void)updateUser:(User*)userName;
@end

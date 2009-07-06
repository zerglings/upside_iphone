//
//  UserUpdateCommController.m
//  upside
//
//  Created by Victor Costan on 6/20/09.
//  Copyright 2009 MIT. All rights reserved.
//

#import "UserUpdateCommController.h"

#import "ServerPaths.h"
#import "ServiceError.h"
#import "User.h"


@implementation UserUpdateCommController

+(NSArray*)copyResponseQueries {
  return [[NSArray alloc] initWithObjects:
          [User class], @"/user",
          [ServiceError class], @"/error", nil];
}

-(void)updateUser:(User*)user {
  NSDictionary* request = [[NSDictionary alloc] initWithObjectsAndKeys:
                           user, @"user", nil];  
  [self callService:[ServerPaths userUpdateService]
             method:[ServerPaths userUpdateMethod]
               data:request];
  [request release];
}
@end

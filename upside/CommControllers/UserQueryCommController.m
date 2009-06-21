//
//  UserQueryCommController.m
//  StockPlay
//
//  Created by Victor Costan on 5/9/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "UserQueryCommController.h"

#import "ModelSupport.h"
#import "ServerPaths.h"
#import "ServiceError.h"
#import "User.h"
#import "WebSupport.h"


@implementation UserQueryCommController

+(NSArray*)copyResponseQueries {
  return [[NSArray alloc] initWithObjects:
          [UserQueryResponse class], @"/result",
          [ServiceError class], @"/error", nil];
}

-(void)startQueryForName:(NSString*)userName {
  User* queryUser = [[User alloc] initWithName:userName password:nil];

  NSDictionary* request = [[NSDictionary alloc] initWithObjectsAndKeys:
                           queryUser, @"user", nil];  
  [self callService:[ServerPaths userQueryService]
             method:[ServerPaths userQueryMethod]
               data:request];
  [queryUser release];
  [request release];
}
@end

@implementation UserQueryResponse
@synthesize name, taken;

-(void)dealloc {
  [name release];
  [super dealloc];
}
@end

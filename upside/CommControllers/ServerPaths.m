//
//  ServerPaths.m
//  StockPlay
//
//  Created by Victor Costan on 1/19/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "ServerPaths.h"

#import "WebSupport.h"

@implementation ServerPaths

+(NSString*)serverUrl {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString* urlPrefKey = [defaults boolForKey:@"use_custom_server"] ?
      @"custom_server_url" : @"server_url";
  NSString* serverUrl = [defaults stringForKey:urlPrefKey];
  if (!serverUrl)
    serverUrl = @"http://istockplay.com";

  return serverUrl;
}

+(NSString*)registrationUrl {
  return [NSString stringWithFormat:@"%@/devices/register.json",
      [self serverUrl]];
}
+(NSString*)registrationMethod {
  return kZNHttpMethodPut;
}
+(NSString*)loginUrl {
  return [NSString stringWithFormat:@"%@/sessions.json",
      [self serverUrl]];
}
+(NSString*)loginMethod {
  return kZNHttpMethodPost;
}
+(NSString*)portfolioSyncUrl {
  return [NSString stringWithFormat:@"%@/portfolios/sync/0.json",
      [self serverUrl]];
}
+(NSString*)portfolioSyncMethod {
  return kZNHttpMethodPut;
}
+(NSString*)orderSubmissionUrl {
  return [NSString stringWithFormat:@"%@/trade_orders.json",
          [self serverUrl]];
}
+(NSString*)orderSubmissionMethod {
  return kZNHttpMethodPost;
}
+(NSString*)userQueryService {
  return [NSString stringWithFormat:@"%@/users/is_user_taken.json",
          [self serverUrl]];
}
+(NSString*)userQueryMethod {
  return kZNHttpMethodGet;
}
+(NSString*)userUpdateService {
  return [NSString stringWithFormat:@"%@/users/0.json",
          [self serverUrl]];
}
+(NSString*)userUpdateMethod {
  return kZNHttpMethodPut;
}

@end

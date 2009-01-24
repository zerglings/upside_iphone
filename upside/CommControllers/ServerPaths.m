//
//  ServerPaths.m
//  upside
//
//  Created by Victor Costan on 1/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ServerPaths.h"

#import "WebSupport.h"

@implementation ServerPaths

+ (NSString*) serverUrl {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString* urlPrefKey = [defaults boolForKey:@"use_custom_server"] ?
	    @"custom_server_url" : @"server_url";
	NSString* serverUrl = [defaults stringForKey:urlPrefKey];
	if (!serverUrl)
		serverUrl = @"http://upside.zerg.me";
	    
	return serverUrl;
}

+ (NSString*) registrationUrl {
	return [NSString stringWithFormat:@"%@/devices/register.xml",
			[self serverUrl]];
}
+ (NSString*) registrationMethod {
	return kZNHttpMethodPut;
}
+ (NSString*) loginUrl {
	return [NSString stringWithFormat:@"%@/sessions.xml",
			[self serverUrl]];
}
+ (NSString*) loginMethod {
	return kZNHttpMethodPost;
}
+ (NSString*) portfolioSyncUrl {
	return [NSString stringWithFormat:@"%@/portfolios/sync/0.xml",
			[self serverUrl]];
}
+ (NSString*) portfolioSyncMethod {
	return kZNHttpMethodPut;
}

@end

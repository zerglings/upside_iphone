//
//  ServerPaths.h
//  StockPlay
//
//  Created by Victor Costan on 1/19/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <Foundation/Foundation.h>

// Interface to all the server paths used by the iPhone application.
@interface ServerPaths : NSObject {
}

// The root server URL.
+(NSString*)serverUrl;

// Points to the device registration service.
+(NSString*)registrationUrl;
// Method to use for the registration service.
+(NSString*)registrationMethod;

// Points to the user login service.
+(NSString*)loginUrl;
// Method to use for the login service.
+(NSString*)loginMethod;

// Points to the portfolio sync service.
+(NSString*)portfolioSyncUrl;
// Method to use for the portfolio sync service.
+(NSString*)portfolioSyncMethod;

// Points to the trade order submission service.
+(NSString*)orderSubmissionUrl;
// Method to use for submitting trade orders.
+(NSString*)orderSubmissionMethod;

// Points to the user querying service.
+(NSString*)userQueryService;
// Method to use with the user querying service.
+(NSString*)userQueryMethod;

@end

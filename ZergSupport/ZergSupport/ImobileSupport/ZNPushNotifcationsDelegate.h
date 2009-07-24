//
//  ZNPushNotifcationsDelegate.h
//  ZergSupport
//
//  Created by Victor Costan on 7/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <UIKit/UIKit.h>

#import "ZNExtUIApplication.h"


// Chained (secondary) application delegate handling push notifications.
@interface ZNPushNotifcationsDelegate :
    NSObject<UIApplicationDelegate, ZNAutoUIApplicationDelegate> {

}
@end

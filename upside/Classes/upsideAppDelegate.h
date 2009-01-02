//
//  upsideAppDelegate.h
//  upside
//
//  Created by Victor Costan on 1/2/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class upsideViewController;

@interface upsideAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    upsideViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet upsideViewController *viewController;

@end


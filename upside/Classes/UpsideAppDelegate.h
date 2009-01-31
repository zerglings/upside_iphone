//
//  UpsideAppDelegate.h
//  Upside
//
//  Created by Victor Costan on 1/2/09.
//  Copyright Zergling.Net 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpsideAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UIViewController* viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow* window;
@property (nonatomic, retain) IBOutlet UIViewController* viewController;

// Convenience: returns the application's delegate cast to UpsideAppDelegate.
+(UpsideAppDelegate*)sharedDelegate;

@end


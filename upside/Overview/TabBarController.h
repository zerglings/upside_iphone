//
//  TabBarController.h
//  upside
//
//  Created by Victor Costan on 1/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UpsideAppDelegate;

@interface TabBarController : UITabBarController {

}

// Loads the controller from a nib containing the tab bar.
+ (UITabBarController*) loadFromNib: (NSString*)nibName
							  owner:(UpsideAppDelegate*)owner;

@end

//
//  ZNExtUIApplicationDelegate.h
//  ZergSupport
//
//  Created by Victor Costan on 7/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <UIKit/UIKit.h>


// Proxy supporting multiple application delegates.
//
// The proxy has a main delegate, which maps to UIApplication's delegate
// property, and some chained delegates.
//
// When a message is sent to the proxy, all delegates receive the message. The
// main delegate receives the message last, and its return value is the
// message's return value. If the main message doesn't respond to a message,
// the message's return value is chosen arbitrarily from the chained delegates.
@interface ZNExtUIApplicationDelegate : NSProxy<UIApplicationDelegate> {
  NSObject<UIApplicationDelegate>* mainDelegate;
  NSMutableSet* chainedDelegates;  
}
// The main delegate (UIApplication's delegate property).
@property (nonatomic, assign) NSObject<UIApplicationDelegate>* mainDelegate;

// Adds a delegate to the set of chained delegates.
-(void)chainDelegate:(NSObject<UIApplicationDelegate>*)delegate;
// Adds a delegate from the set of chained delegates.
-(void)unchainDelegate:(NSObject<UIApplicationDelegate>*)delegate;
@end

//
//  ZNExtUIApplication.h
//  ZergSupport
//
//  Created by Victor Costan on 7/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <UIKit/UIKit.h>

@class ZNMulticastDelegateProxy;


// Classes implementing this protocol will be automatically instantiated and
// chained as application delegates by ZNExtUIApplication.
@protocol ZNAutoUIApplicationDelegate
@end


// Classes implementing this protocol will be automatically instantiated and
// chained as hidden application delegates by ZNExtUIApplication.
@protocol ZNAutoUIHiddenApplicationDelegate
@end


// Extended UIApplication class which support multiple delegates.
//
// Multiple delegates are useful to have because Apple shove too much stuff into
// the application delegate, ruining separation of concerns.
@interface ZNExtUIApplication : UIApplication {
  ZNMulticastDelegateProxy* delegateProxy;
}

// Overrides UIApplication's delegate property.
@property(nonatomic, assign, readwrite) id<UIApplicationDelegate> delegate;

// Overrides UIApplication's sharedApplication global.
+(ZNExtUIApplication*)sharedApplication;


// Adds a delegate to the delegate chain.
-(void)chainDelegate:(NSObject<UIApplicationDelegate>*)delegate;
// Adds a hidden delegate to the delegate chain.
//
// Hidden delegates have their methods invoked, but their methods don't factor
// into the responses to -respondsToSelector:
-(void)chainHiddenDelegate:(NSObject<UIApplicationDelegate>*)delegate;
// Removes a delegate from the delegate chain.
-(void)unchainDelegate:(NSObject<UIApplicationDelegate>*)delegate;

// The classes that should be automatically instantiated and chained as
// application delegates.
+(NSArray*)copyAllAutoChainedClasses;

// The classes that should be automatically instantiated and chained as
// hidden application delegates.
+(NSArray*)copyAllHiddenAutoChainedClasses;

@end

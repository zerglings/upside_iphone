//
//  ZNExtUIApplication.h
//  ZergSupport
//
//  Created by Victor Costan on 7/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <UIKit/UIKit.h>

@class ZNExtUIApplicationDelegate;


// Classes implementing this protocol will be automatically instantiated and
// chained as application delegates by ZNExtUIApplication.
@protocol ZNAutoUIApplicationDelegate
@end


// Extended UIApplication class which support multiple delegates.
//
// Multiple delegates are useful to have because Apple shove too much stuff into
// the application delegate, ruining separation of concerns.
@interface ZNExtUIApplication : UIApplication {
  ZNExtUIApplicationDelegate* fakeDelegate;
}

// Overrides UIApplication's delegate property.
@property(nonatomic, assign) id<UIApplicationDelegate> delegate;

// Overrides UIApplication's sharedApplication global.
+(ZNExtUIApplication*)sharedApplication;


// Add a delegate to the delegate chain.
-(void)chainDelegate:(NSObject<UIApplicationDelegate>*)delegate;
// Remove a delegate from the delegate chain.
-(void)unchainDelegate:(NSObject<UIApplicationDelegate>*)delegate;

// The classes that should be automatically instantiated and chained as
// application delegates.
+(NSArray*)copyAllAutoChainedClasses;

@end

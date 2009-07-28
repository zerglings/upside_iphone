//
//  ZNMulticastDelegateProxy.h
//  ZergSupport
//
//  Created by Victor Costan on 7/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>


// Proxy implementing multicasting for Cocoa delegates.
//
// The proxy has a main delegate, which maps to the delegate property in UIKit
// objects, and many secondary delegates, chained in the delegation process.
//
// When a message is sent to the proxy, the message is repeated to all the
// proxy's delegates. The main delegate receives the message last, and its
// return value becomes the message's return value. If the main message doesn't
// respond to a message, the message's return value is chosen arbitrarily from
// the chained delegates.
//
// This approach is intended to facilitate separation of concerns. The main
// delegate can be written in a way that is almost completely oblivious to the
// proxy's existence. Separate concerns can be handled in chained delegates.
@interface ZNMulticastDelegateProxy : NSProxy {
  NSObject* mainDelegate;
  NSMutableSet* chainedDelegates;
  NSMutableSet* hiddenDelegates;
}
// The main delegate (the UIKit object's delegate property).
@property (nonatomic, assign) NSObject* mainDelegate;

// Adds a delegate to the set of chained delegates.
-(void)chainDelegate:(NSObject*)delegate;
// Adds a delegate to the set of hidden chained delegates.
//
// The hidden delegates are not factored into the -respondsToSelecto: method.
-(void)chainHiddenDelegate:(NSObject*)delegate;
// Removes a set from the set of chained and/or hidden delegates.
-(void)unchainDelegate:(NSObject*)delegate;
@end

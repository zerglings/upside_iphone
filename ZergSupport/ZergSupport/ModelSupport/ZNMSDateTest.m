//
//  ZNMSDateTest.m
//  ZergSupport
//
//  Created by Victor Costan on 7/22/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ZNMSDate.h"
#import "ZNTestModels.h"


@interface ZNMSDateTest : SenTestCase {
}
@end


@implementation ZNMSDateTest
-(void)checkDateString:(NSString*)dateString against:(NSTimeInterval)golden {
  ZNTestDate* model = [[ZNTestDate alloc] initWithProperties:
                       [NSDictionary dictionaryWithObject:dateString
                                                   forKey:@"pubDate"]];
  NSLog(@"%@", [model.pubDate description]);
  STAssertEqualsWithAccuracy(golden, [model.pubDate timeIntervalSince1970],
                             0.01, @"Date string %@ isn't parsed correctly",
                             dateString);
}

-(void)testAppStoreParsing {
  [self checkDateString:@"2009-07-22 09:09:52 GMT"
                against:1248253792.0];

  // TODO(costan): make this pass -- the App Store spits out this format
  //[self checkDateString:@"2009-07-22 09:09:52 Etc/GMT"
  //              against:1248253792.0];
}
-(void)testRailsParsing {
  [self checkDateString:@"2009-07-22T09:09:52+00:00"
                against:1248253792.0];
}
@end

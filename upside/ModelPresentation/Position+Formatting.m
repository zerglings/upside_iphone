//
//  Position+Formatting.m
//  StockPlay
//
//  Created by Victor Costan on 1/6/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "Position+Formatting.h"

@implementation Position (Formatting)

#pragma mark Lifecycle

static NSNumberFormatter* countFormatter = nil;

#pragma mark Formatting

static void SetupFormatters() {
  @synchronized([Position class]) {
    if (countFormatter == nil) {
      countFormatter = [[NSNumberFormatter alloc] init];
      [countFormatter setPositiveFormat:@"#,##0"];
      [countFormatter setNegativeFormat:@"-#,##0"];
    }
  }
}

-(NSString*)formattedQuantity {
  SetupFormatters();
  return [countFormatter stringFromNumber:[NSNumber
                       numberWithUnsignedInt:quantity]];
}

@end

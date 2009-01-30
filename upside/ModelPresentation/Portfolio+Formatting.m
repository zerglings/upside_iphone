//
//  Portfolio+Formatting.m
//  upside
//
//  Created by Victor Costan on 1/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Portfolio+Formatting.h"


static NSNumberFormatter* cashFormatter = nil;

static void SetupFormatters() {
	@synchronized([Portfolio class]) {
		if (cashFormatter == nil) {
			cashFormatter = [[NSNumberFormatter alloc] init];
			[cashFormatter setPositiveFormat:@"$#,##0.00"];
			[cashFormatter setNegativeFormat:@"$-#,##0.00"];
    }
  }
}

@implementation Portfolio (Formatting)

- (NSString*)formattedCash {
  SetupFormatters();
  return [cashFormatter stringFromNumber:[NSNumber numberWithDouble:cash]];
}

- (UIColor*)colorForCash {
  if (cash > 0)
		return [UIColor colorWithRed:0.0f green:0.5f blue:0.0f alpha:1.0f];
	else
		return [UIColor colorWithRed:0.5f green:0.0f blue:0.0f alpha:1.0f];
}

@end
